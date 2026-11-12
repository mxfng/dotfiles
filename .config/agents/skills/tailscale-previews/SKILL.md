---
name: tailscale-previews
description: Serve a web app preview to Max's phone over Tailscale with HTTPS, and measure real-device performance with a telemetry beacon. Also covers SSH to Max's other Macs over Tailscale (auth links, launchd env, Keychain). Use when Max tests on his phone or iPad, asks for a preview URL, reports mobile slowness, or a command must run on another Mac on the tailnet.
---

# tailscale-previews

A phone test is useful only if its numbers are real.
Serve the preview the way users get the site.

## Messages to Max on his phone

- Send one URL per message, on its own line. Include the route or hash.
- Tell him exactly what to do and for how long, for example "open it, leave it 15 seconds".
- Do not ask him to read numbers. The beacon sends them.
- Ask one time if Low Power Mode is on. Record the answer with the run.

## Serve a preview

- **Use HTTPS on the tailnet.** An `http://100.x.y.z` origin is not a secure context. WebKit then runs JavaScript and WebAssembly 7-30x slower and removes some APIs. All measurements from it are wrong.
- Get a certificate: `tailscale cert --cert-file <dir>/ts.crt --key-file <dir>/ts.key <machine>.<tailnet>.ts.net`.
- The URL is `https://<machine>.<tailnet>.ts.net:<port>/`. `tailscale status` shows the name.
- Bind to the tailnet IP (`tailscale ip -4`), not `0.0.0.0`.
- Do not use `tailscale serve`. Serve is not enabled on the tailnet.
- **Serve a production build with gzip.** A dev server sends large unbundled modules and gives wrong load times.
- Use a new port for each preview. Do not use the project's dev port.
- Record each port and what it serves. Stop the server when the work merges.
- Do not use public hosting for unreleased work unless Max asks.

`scripts/serve.cjs` does all of this:

```sh
TLS_CERT=<dir>/ts.crt TLS_KEY=<dir>/ts.key \
  node ~/.claude/skills/tailscale-previews/scripts/serve.cjs <build dir> <port> <tailnet ip> <log file> [/prefix=<dir> | /prefix=https://origin ...]
```

The server:

- Serves the build with gzip and `Cache-Control: no-store`.
- Mounts more directories by URL prefix.
- Forwards a prefix mapped to an `https://` origin, without the prefix, like a dev server proxy. Use this for routes that the production host serves.
- Logs each request: ms since load start, ms until the last byte, bytes sent, path.
- Injects `scripts/telemetry.js` into HTML.

Check the server with `curl -sI https://<name>:<port>/` before you send the link.

## Measure on the phone

`telemetry.js` sends one JSON beacon to `/__beacon` 15 seconds after load, or on pagehide.
The server writes it next to the log as `<log>-beacon-<ms>.json`.

Fields:

- `jit.loopMs`: a fixed loop. Read this first, because it tells you the device state:
  - about 30 ms: recent iPhone, secure context, Low Power Mode off
  - about 2x: Low Power Mode on
  - about 10x: insecure origin
  - about 1 s: Lockdown Mode
- `gaps`: main-thread stalls longer than 50 ms, as `[at ms, length ms]`.
- `marks`: first worker message, first WebGL draw, and each `window.__mark?.("name")` call.
- `gl`: shader compile and link waits, and texture or buffer uploads longer than 2 ms.
- `tm`: entries the page pushes to `window.__tm` as `[label, start ms, duration ms]`. Add these timers only in a scratch copy. Do not commit them.

Also read the request log. On a first visit, transfer time is often larger than CPU time.

## Desktop proxies

- Playwright WebKit with `devices["iPhone 15 Pro"]` on a secure origin is close to a real iPhone. Use it to iterate. Ask Max for a phone run to confirm.
- Chromium CPU throttling is not close to an iPhone. Do not use it as a phone proxy.
- Headless Chromium uses software GL. For GPU work, launch it with `--use-angle=metal --ignore-gpu-blocklist --enable-gpu`.
- To test a fallback path (no WebGL2, no worker), disable the feature, for example make `getContext("webgl2")` return null. Compare screenshots with the last build that used that path.

## SSH to Max's other Macs

- Use `ssh -o BatchMode=yes -o ConnectTimeout=10 <user>@<host>`. The user name can be different on each machine. `tailscale status` shows hosts and owners.
- Tailscale SSH can print `To authenticate, visit: https://login.tailscale.com/a/...` and wait. Run ssh in the background, wait for that line, and send the link to Max.
- The link expires in a few minutes. If it expires, start a new ssh to get a new link.
- The remote login shell is fish. Wrap remote commands in `bash -c '...'`.
- launchd jobs get only the environment in their plist (`EnvironmentVariables`). To test what a job sees, run `env -i HOME=$HOME PATH=<plist PATH> <other plist vars> <command>`.
- Over SSH, the keychain search list does not include the login keychain. `security find-generic-password -s <service>` then returns 44. Name the keychain: `security find-generic-password -s <service> -w ~/Library/Keychains/login.keychain-db`. Put the result in an env var for one command. Never print a secret.
- Paths under `~/Library/Application Support` contain a space. In Node, use `fileURLToPath(new URL(..., import.meta.url))`, not `URL.pathname`, which keeps `%20`.
- Run deploys and other outward actions only from the machine that the project names, and only when Max asks.
