// A preview server for phones: serves a build gzipped (over HTTPS when TLS_CERT and TLS_KEY are set),
// mounts extra directories by URL prefix, forwards a prefix to another origin (an https:// target, the
// prefix dropped, as a dev server's proxy does), logs every request, injects telemetry.js into HTML pages,
// and writes each telemetry beacon beside the log.
//
//   node serve.cjs <root> <port> <host> <log file> [/prefix=<dir> | /prefix=https://origin[/path] ...]
//
// Log lines: ms since the load began, ms until the last byte left, bytes sent, path.
const http = require("http"), https = require("https"), fs = require("fs"), path = require("path"), zlib = require("zlib"), crypto = require("crypto");
const [root, port, host, logFile, ...mountArgs] = process.argv.slice(2);
if (!logFile) {
  console.error("usage: node serve.cjs <root> <port> <host> <log file> [/prefix=<dir> ...]");
  process.exit(2);
}
const pairs = mountArgs.map((m) => m.split("=")).map(([prefix, to]) => [prefix.replace(/\/?$/, "/"), to]);
const mounts = pairs.filter(([, to]) => !/^https?:\/\//.test(to));
const proxies = pairs.filter(([, to]) => /^https?:\/\//.test(to)).map(([prefix, to]) => [prefix, to.replace(/\/$/, "")]);
const types = {
  ".html": "text/html", ".js": "text/javascript", ".mjs": "text/javascript", ".css": "text/css", ".json": "application/json",
  ".svg": "image/svg+xml", ".png": "image/png", ".jpg": "image/jpeg", ".webp": "image/webp", ".woff2": "font/woff2",
  ".wasm": "application/wasm", ".bin": "application/octet-stream", ".webmanifest": "application/manifest+json",
};
const compressed = /^(image\/(png|jpeg|webp)|font\/woff2)$/;
const telemetry = fs.readFileSync(path.join(__dirname, "telemetry.js"), "utf8");
const gzCache = new Map();
const log = (s) => fs.appendFileSync(logFile, s + "\n");
let t0 = 0, lastAt = 0;

// The file a URL path names, or null when it would leave its directory.
const resolve = (u) => {
  const within = (dir, rel) => {
    const f = path.join(dir, rel);
    return f.startsWith(path.resolve(dir) + path.sep) || f === path.resolve(dir) ? f : null;
  };
  for (const [prefix, dir] of mounts) if (u.startsWith(prefix)) return within(path.resolve(dir), u.slice(prefix.length));
  return within(path.resolve(root), u.endsWith("/") ? u + "index.html" : u);
};

const handler = (req, res) => {
  if (req.url === "/__beacon") {
    let body = "";
    req.on("data", (c) => (body += c));
    req.on("end", () => {
      fs.writeFileSync(`${logFile.replace(/\.log$/, "")}-beacon-${Date.now()}.json`, body);
      log(`beacon ${body.length} bytes`);
      res.end();
    });
    return;
  }
  const now = Date.now();
  // A pause of 15 s starts a new load in the log.
  if (now - lastAt > 15000) {
    t0 = now;
    log(`--- load from ${req.socket.remoteAddress} ${new Date().toISOString()} ${(req.headers["user-agent"] || "").slice(0, 80)}`);
  }
  lastAt = now;
  const proxy = proxies.find(([prefix]) => req.url.startsWith(prefix));
  if (proxy) {
    const target = new URL(proxy[1] + "/" + req.url.slice(proxy[0].length));
    const out = (target.protocol === "https:" ? https : http).get(target, { headers: { "user-agent": req.headers["user-agent"] || "serve.cjs" } }, (up) => {
      res.writeHead(up.statusCode || 502, { "content-type": up.headers["content-type"] || "application/octet-stream", "cache-control": "no-store" });
      up.pipe(res);
      res.on("finish", () => log(`${now - t0}\t${up.statusCode}\tproxy\t${req.url}`));
    });
    out.on("error", () => {
      res.writeHead(502);
      res.end();
      log(`${now - t0}\t502\tproxy\t${req.url}`);
    });
    return;
  }
  const u = decodeURIComponent(req.url.split("?")[0]);
  const file = resolve(u);
  fs.readFile(file ?? "", (err, buf) => {
    if (err) {
      res.writeHead(404);
      res.end();
      return log(`${now - t0}\t404\t${u}`);
    }
    const type = types[path.extname(file)] || "application/octet-stream";
    if (type === "text/html") buf = Buffer.from(buf.toString().replace("<head>", `<head><script>${telemetry}</script>`));
    const gz = /gzip/.test(req.headers["accept-encoding"] || "") && !compressed.test(type);
    let body = buf;
    if (gz) {
      // By content, so a rebuilt file of the same size isn't served stale.
      const key = crypto.createHash("sha1").update(buf).digest("hex");
      body = gzCache.get(key) || zlib.gzipSync(buf, { level: 6 });
      gzCache.set(key, body);
    }
    res.writeHead(200, { "content-type": type, "cache-control": "no-store", ...(gz ? { "content-encoding": "gzip" } : {}) });
    res.on("finish", () => log(`${now - t0}\t+${Date.now() - now}ms\t${body.length}\t${u}`));
    res.end(body);
  });
};

const server = process.env.TLS_CERT
  ? https.createServer({ cert: fs.readFileSync(process.env.TLS_CERT), key: fs.readFileSync(process.env.TLS_KEY) }, handler)
  : http.createServer(handler);
server.listen(+port, host, () => console.log(`${process.env.TLS_CERT ? "https" : "http"}://${host}:${port}/ serving ${root}`));
