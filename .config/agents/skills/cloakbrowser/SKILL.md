---
name: cloakbrowser
description: |
  Use cloakbrowser for ALL web searching and web scraping. This is the REQUIRED
  tool for any online research, search engine queries, or extracting content
  from web pages. NEVER use WebSearch or WebFetch — always use cloakbrowser
  instead. Triggers on any request to search the web, look up documentation,
  scrape a webpage, or research anything online.

  cloakbrowser drives a DEDICATED, isolated Chromium (Google Chrome) instance —
  a separate app and a separate profile from any browser Max uses interactively.
  It NEVER touches Max's daily browser (Helium) or his normal Chrome profile.

  Platform: darwin-arm64 (macOS Apple Silicon)
  Binary:  /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
  Profile: ~/.cache/cloakbrowser/profile   (dedicated, never the default)
---

# Cloakbrowser

Drive a dedicated, isolated Chrome instance for ALL web searches and web page
scraping. Never use `WebSearch` or `WebFetch` — cloakbrowser replaces both.

## Isolation invariant (read this first — it is the whole point)

Automation MUST run in a browser that is fully separated from Max's interactive
sessions, so that launching, driving, or cleaning up the automation browser can
never disturb, hijack, or kill a window Max is actually using.

Two rules make this true. Both are mandatory on every invocation:

1. **Dedicated binary.** Use Google Chrome, NOT Helium. Helium is Max's daily
   browser; Chrome is reserved here for automation. They are different apps, so
   an automation crash or a stray `kill` can't take down Max's Helium session.
2. **Dedicated profile.** ALWAYS pass `--user-data-dir="$PROFILE"` pointing at
   `~/.cache/cloakbrowser/profile`. Never launch against the default profile.
   Chromium enforces one process per profile (a singleton lock); sharing a
   profile is exactly what used to collide with, and kill, the real session.

Never run a blanket `pkill -f Helium`, `pkill -f "Google Chrome"`, or
`pkill -f chromium`. That would kill Max's interactive windows. Clean up by PID,
or scope any `pkill` to the unique profile path (see cleanup below).

## Setup (every snippet assumes these)

```bash
BROWSER="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
PROFILE="$HOME/.cache/cloakbrowser/profile"
FLAGS="--headless=new --no-sandbox --no-first-run --no-default-browser-check --user-data-dir=$PROFILE"
mkdir -p "$PROFILE"
```

`$FLAGS` bundles the two isolation flags (`--no-sandbox`, `--user-data-dir`)
with fresh-profile hygiene (`--no-first-run`, `--no-default-browser-check`, which
stop a brand-new dedicated profile from hanging on first-run setup). Every launch
below uses it. Do not drop `--user-data-dir`.

## Quick reference

One-shot `--dump-dom`/`--screenshot` fetches do NOT reliably self-exit — always
wrap them in `timeout` so they can't hang; the output is emitted before the cap.

```bash
# Basic page fetch (static HTML only — NOT for JS-heavy pages)
timeout 30 "$BROWSER" $FLAGS \
  --dump-dom --virtual-time-budget=10000 'https://example.com'

# Screenshot
timeout 30 "$BROWSER" $FLAGS \
  --screenshot=/tmp/out.png --window-size=1200,900 'https://example.com'

# JS-rendered pages: use CDP (see below)
```

## Critical pitfall: `--dump-dom` does NOT capture JavaScript-rendered content

`--dump-dom` outputs the HTML AS DELIVERED from the server, before any
JavaScript executes. For SPAs (React, Vue, Doxygen, etc.), the dump is just
an empty shell with `<script>` tags — useless.

**Do NOT waste time with `--dump-dom` on modern websites.** Almost every site
today is JS-rendered. If you see only CSS/boilerplate in the output, the page
is JS-rendered and you need CDP.

## The correct approach: Chrome DevTools Protocol (CDP)

For any page where JavaScript modifies the DOM after load, use
`--remote-debugging-port` + a Python script that connects via WebSocket and
executes `Runtime.evaluate` to extract the final rendered DOM.

### Step 1: Start Chrome with remote debugging

```bash
"$BROWSER" $FLAGS \
  --remote-debugging-port=9229 \
  'https://target-url.com' &
CHROME_PID=$!
```

The long-running CDP instance holds the port open, so it does not need a
`timeout` wrapper — you reap it by PID in Step 4. For stubborn pages, add:
```
--disable-web-security --disable-features=IsolateOrigins,site-per-process
```

### Step 2: Wait for the page to load

Chrome loads asynchronously. **Poll the CDP endpoint** until a page appears:

```bash
for i in $(seq 1 10); do
  sleep 3
  PAGES=$(curl -s http://localhost:9229/json | python3 -c "import json,sys; print(len(json.load(sys.stdin)))" 2>/dev/null)
  [ "$PAGES" -gt 0 ] && break
done
```

### Step 3: Connect via WebSocket and wait for JS to finish rendering

```python
import json, asyncio, urllib.request
import websockets

async def scrape():
    # Get the WebSocket URL
    resp = urllib.request.urlopen("http://localhost:9229/json")
    pages = json.loads(resp.read())
    ws_url = pages[0]["webSocketDebuggerUrl"]

    async with websockets.connect(ws_url, max_size=10*1024*1024) as ws:
        # Poll document.title until JS rendering completes.
        # Doxygen pages show empty title until MathJax finishes.
        # SPAs show "Loading..." or empty until React mounts.
        for i in range(10):
            await asyncio.sleep(2)
            cmd = json.dumps({"id": i, "method": "Runtime.evaluate",
                "params": {"expression": "document.title"}})
            await ws.send(cmd)
            resp = await ws.recv()
            title = json.loads(resp)["result"]["result"]["value"]
            # Adapt this check to the target site
            if title and "Loading" not in title and title != "":
                break

        # Now extract data with querySelectorAll
        cmd = json.dumps({"id": 99, "method": "Runtime.evaluate",
            "params": {"expression": "your JS expression here"}})
        await ws.send(cmd)
        resp = await ws.recv()
        result = json.loads(resp)["result"]["result"]["value"]
        return json.loads(result)

data = asyncio.run(scrape())
```

### Step 4: Clean up (scoped — never a blanket kill)

Kill only the instance you started, by PID. If you must sweep stragglers, match
the unique profile path — which only the automation browser uses — so Max's
interactive windows are never in scope:

```bash
kill $CHROME_PID 2>/dev/null
wait $CHROME_PID 2>/dev/null
# Straggler sweep, scoped to the dedicated profile ONLY:
pkill -f "user-data-dir=$PROFILE" 2>/dev/null
```

Do NOT run `pkill -f Helium`, `pkill -f "Google Chrome"`, or `pkill -f chromium`
— those match Max's real browser windows.

## Common extraction patterns

### Extract all links matching a pattern
```javascript
JSON.stringify(Array.from(document.querySelectorAll('a.el')).map(a => ({
    href: a.getAttribute('href'),
    text: a.textContent.trim()
})).slice(0, 50))
```

### Extract Doxygen method signatures
```javascript
JSON.stringify(Array.from(document.querySelectorAll('.memitem .memname'))
    .slice(0, 30).map(el => el.textContent.replace(/\s+/g, ' ').trim()))
```

### Extract page text content
```javascript
document.body.innerText.substring(0, 5000)
```

### Extract full rendered HTML
```javascript
document.documentElement.outerHTML
```

## Pitfalls encountered (do NOT repeat)

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| Omitting `--user-data-dir` | Collides with / kills Max's real browser | ALWAYS pass `--user-data-dir="$PROFILE"` (use `$FLAGS`) |
| `--dump-dom` never exits | Command hangs after printing the DOM | Wrap one-shot fetches in `timeout 30` |
| Fresh profile stalls on launch | First run hangs before loading | `--no-first-run --no-default-browser-check` (in `$FLAGS`) |
| Blanket `pkill Helium`/`chromium` | Kills Max's interactive windows | Kill by PID, or `pkill -f "user-data-dir=$PROFILE"` |
| `--dump-dom` on SPA | Only CSS/script tags, no content | Use CDP |
| `--virtual-time-budget` alone | Still no JS rendering in dump | CDP is the only reliable way |
| Page not loaded yet | CDP returns empty page list | Poll `/json` endpoint until page count > 0 |
| JS not finished rendering | `document.title` is empty | Poll title every 2s until it stabilizes |
| websockets not installed | `ModuleNotFoundError` | `pip3 install websockets` |
| Lingering Chrome processes | Port already in use | `pkill -f "user-data-dir=$PROFILE"` before starting |
| Doxygen/MathJax slow | Title loaded but content missing | Wait 5-8s after title appears, then extract |
| Google search redirects to login | Blank search results | Google requires login in headless; try Bing or use `site:` operators |
| Stack Overflow JS-rendered | Empty answers in dump | Use `stackoverflow.com/questions/ID?answertab=votes` or old.reddit.com |
| React SPA never finishes | Title never changes from "Loading..." | Accept the limitation; use the site's API instead |

## WebSearch replacement

For Google searches, use this pattern:

```bash
timeout 30 "$BROWSER" $FLAGS \
  --virtual-time-budget=10000 --dump-dom \
  'https://www.google.com/search?q=URL_ENCODED_QUERY' 2>/dev/null | python3 -c "
import sys, re, html as h
text = h.unescape(sys.stdin.read())
text = re.sub(r'<[^>]+>', ' ', text)
text = re.sub(r'\s+', ' ', text)
# Extract URLs or search for patterns
urls = re.findall(r'https?://[^\s\"<>]+', text)
for u in urls:
    if 'google' not in u and 'accounts.' not in u:
        print(u)
"
```

Google may block headless requests. If you get no results, try alternative search
engines or use `site:stackoverflow.com` type queries that are more likely to
return results.

## Port management

Use incrementing port numbers (9229, 9230, 9231...) to avoid conflicts with any
stale processes. Always kill Chrome after use — by PID, per the cleanup rules above.
