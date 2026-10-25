---
name: phone-previews
description: How to put a web app in front of Max's phone and measure it there - previews over the tailnet with HTTPS, a production build served gzipped, a telemetry beacon that reports real-device timings back, and the traps that make phone numbers lie (insecure origins, Low Power Mode, dev servers). Also how to reach his other Macs over Tailscale SSH (check links, launchd env, Keychain). Use whenever Max will test something on his phone or iPad, asks for a preview URL, reports mobile slowness or jank, or work needs a command run on another machine on the tailnet.
---

# phone-previews

Max often reviews from his phone, and many users of what he builds are on phones.
A phone test is only worth asking for if the numbers it produces are real, so set it up the way users get the site.

## Talking to Max while he is on his phone

- Give one tappable URL per message, on its own line, with the hash or route already in it.
- Say exactly what to do and for how long ("open it, leave it 15 seconds").
  The beacon reports back on its own; don't ask him to read numbers off the screen.
- Ask once whether Low Power Mode is on, and record the answer with the run (see below).

## Serving a preview

- **HTTPS on the tailnet, never plain HTTP to a tailnet IP.**
  An `http://100.x.y.z` origin is an insecure context.
  WebKit then runs JavaScript and WebAssembly 7-30x slower (no JIT tiers), and some APIs are missing.
  Every phone number measured that way is wrong; it cost a day of wrong conclusions once.
  - Get a cert for this Mac: `tailscale cert --cert-file <dir>/ts.crt --key-file <dir>/ts.key <machine>.<tailnet>.ts.net` (HTTPS Certificates must be on in the Tailscale admin console; it is).
  - The URL is `https://<machine>.<tailnet>.ts.net:<port>/`; `tailscale status` and `tailscale cert` show the name.
  - Bind to the Mac's tailnet IP (`tailscale ip -4`), not 0.0.0.0.
  - `tailscale serve` needs Serve enabled on the tailnet; it isn't, so use your own server.
- **A production build, compressed.**
  A dev server ships unbundled, uncompressed modules (tens of MB) and misleads about load time.
  Build, then serve the output with gzip.
- Use a fresh port per preview and never the project's own dev port.
  Note each preview's port and what it serves; stop them when the work merges.
- Do not use public hosting (Cloudflare previews etc.) for unreleased work unless Max asks; the tailnet is private.

`scripts/serve.cjs` does all of this:

```sh
TLS_CERT=<dir>/ts.crt TLS_KEY=<dir>/ts.key \
  node ~/.claude/skills/phone-previews/scripts/serve.cjs <build dir> <port> <tailnet ip> <log file> [/data=<dir> ...]
```

It serves the build gzipped with `no-store`, mounts extra directories by URL prefix, logs every request (ms since the load started, ms until the last byte left, bytes sent), and injects `scripts/telemetry.js` into HTML.
Check it with `curl -sI https://<name>:<port>/` before sending the link.

## Measuring on the phone

`telemetry.js` (injected by the server) sends one JSON beacon to `/__beacon` 15 seconds after load or on pagehide; the server writes it beside the log as `<log>-beacon-<ms>.json`.
It records:

- `gaps`: main-thread stalls, as requestAnimationFrame gaps over 50 ms, `[at ms, length ms]`.
- `marks`: first worker message, first WebGL draw, and anything the page marks with `window.__mark?.("name")`.
- `gl`: shader compile/link waits and texture/buffer upload times over 2 ms.
- `tm`: whatever the page pushes to `window.__tm` as `[label, start ms, duration ms]` (add temporary timers in a scratch copy, never commit them).
- `jit.loopMs`: a fixed tight loop. About 30 ms on a recent iPhone in a secure context with Low Power Mode off; about 2x with Low Power Mode on; about 10x on an insecure origin; around a second in Lockdown Mode.
  It tells you which of those the run was, so read it before reading anything else.

Read the request log beside the beacon: on a first visit over the tailnet, much of the time before first paint is transfer, not CPU.

## Desktop proxies

- Playwright **WebKit** with `devices["iPhone 15 Pro"]` on a secure origin (localhost or the HTTPS preview) tracks a real iPhone closely.
  Use it to iterate; ask Max for a phone run to confirm.
- Chromium CPU throttling does not track an iPhone; don't use it as the phone proxy.
- Headless Chromium falls back to software GL; for GPU work launch it with `--use-angle=metal --ignore-gpu-blocklist --enable-gpu`.
- Verify a fallback path (no WebGL2, no worker) by forcing it off (e.g. make `getContext("webgl2")` return null) and comparing screenshots with the last build that used that path.

## Reaching Max's other Macs

- `ssh <user>@<host>` over Tailscale SSH; the user name may differ per machine (`tailscale status` shows hosts and owners).
  Use `-o BatchMode=yes -o ConnectTimeout=10`.
- **Check links.** Tailscale SSH may print `To authenticate, visit: https://login.tailscale.com/a/...` and wait.
  Run the ssh in the background, wait for that line, and send Max the link.
  It expires in a few minutes; if he misses it, start a fresh ssh for a fresh link rather than resending the old one.
- The login shell may be fish: write the remote command in fish, or wrap it in `sh -c "..."`.
- **launchd jobs** get only their plist's environment (`EnvironmentVariables`), not the shell's.
  To test what a job will see: `env -i HOME=$HOME PATH=<plist PATH> <other plist vars> <command>`.
- **Keychain over SSH.** An SSH session's keychain search list lacks the login keychain, so `security find-generic-password -s <service>` returns 44 there though the job finds it.
  Name the keychain: `security find-generic-password -s <service> -w ~/Library/Keychains/login.keychain-db`, into an env var for the one command; never print a secret.
- Paths under `~/Library/Application Support` have a space.
  In Node, take file paths from `fileURLToPath(new URL(..., import.meta.url))`, never `URL.pathname` (it keeps `%20`).
- Deploys and other outward actions run only from the machine the project designates, and only when Max asks.
