// Injected into a preview's HTML by serve.cjs. Sends one beacon to /__beacon after 15 s (or on pagehide):
// main-thread stalls, first-event marks, WebGL compile and upload waits, the page's own timers, and a JIT probe.
// Plain ES5 so it runs before anything else on any browser.
(function () {
  var T = { url: location.href, ua: navigator.userAgent, secure: window.isSecureContext, gaps: [], marks: {}, gl: { compile: [], upload: [], buffers: 0, bufferBytes: 0 } };
  var now = function () { return Math.round(performance.now()); };
  var mark = function (k) { if (!(k in T.marks)) T.marks[k] = now(); };
  window.__mark = mark; // the page may mark its own milestones
  window.__tm = window.__tm || []; // and push [label, start ms, duration ms] timers

  // Time each requestAnimationFrame callback the page runs, so a frame's interval splits into the page's own
  // JavaScript and everything else (style, layout, paint, compositing, the GPU).
  var raf = window.requestAnimationFrame.bind(window), frameJs = 0;
  window.requestAnimationFrame = function (cb) {
    return raf(function (t) { var a = performance.now(); try { cb(t); } finally { frameJs += performance.now() - a; } });
  };

  // While a finger (or mouse button) is down: every frame as [interval ms, page JS ms], and the gestures' count.
  T.touch = { gestures: 0, frames: [] };
  var down = 0;
  addEventListener("pointerdown", function () { if (down++ === 0) T.touch.gestures++; }, true);
  var up = function () { down = Math.max(0, down - 1); };
  addEventListener("pointerup", up, true);
  addEventListener("pointercancel", up, true);

  // Main-thread stalls: requestAnimationFrame gaps over 50 ms, as [at, length].
  var last = performance.now();
  (function tick(t) {
    var d = t - last;
    if (d > 50) T.gaps.push([Math.round(last), Math.round(d)]);
    if (down > 0 && T.touch.frames.length < 3000) T.touch.frames.push([Math.round(d * 10) / 10, Math.round(frameJs * 10) / 10]);
    frameJs = 0;
    last = t;
    raf(tick);
  })(performance.now());

  var W = window.Worker;
  if (W) {
    window.Worker = function (u, o) { var w = new W(u, o); w.addEventListener("message", function () { mark("first worker message"); }); return w; };
    window.Worker.prototype = W.prototype;
  }

  var G = window.WebGL2RenderingContext && WebGL2RenderingContext.prototype;
  if (G) {
    var timed = function (name, sink, label) {
      var f = G[name];
      G[name] = function () { var a = performance.now(); var r = f.apply(this, arguments); var d = performance.now() - a; if (d > 2) sink.push([label || name, Math.round(a), Math.round(d)]); return r; };
    };
    timed("compileShader", T.gl.compile);
    timed("linkProgram", T.gl.compile);
    timed("getProgramParameter", T.gl.compile, "getProgramParameter (waits for link)");
    timed("getShaderParameter", T.gl.compile, "getShaderParameter (waits for compile)");
    timed("texImage2D", T.gl.upload);
    timed("generateMipmap", T.gl.upload);
    var bd = G.bufferData;
    G.bufferData = function (t, d) {
      T.gl.buffers++;
      if (d && d.byteLength) T.gl.bufferBytes += d.byteLength;
      var a = performance.now(); var r = bd.apply(this, arguments); var x = performance.now() - a;
      if (x > 2) T.gl.upload.push(["bufferData " + (d && d.byteLength), Math.round(a), Math.round(x)]);
      return r;
    };
    ["drawArrays", "drawElements", "drawArraysInstanced", "drawElementsInstanced"].forEach(function (n) { var f = G[n]; G[n] = function () { mark("first GL draw"); return f.apply(this, arguments); }; });
  }

  // A beacon at 15 s, then one whenever the page is hidden or every 20 s while new touch frames come in;
  // each is the whole record so far, numbered by `seq`.
  T.seq = 0;
  var sentFrames = -1;
  var send = function () {
    T.seq++;
    // Read now, not at injection: before the viewport meta is parsed, iOS reports a 980 px layout width.
    T.screen = { dpr: devicePixelRatio, w: innerWidth, h: innerHeight };
    T.marks.sent = now();
    T.tm = window.__tm;
    sentFrames = T.touch.frames.length;
    navigator.sendBeacon("/__beacon", JSON.stringify(T));
  };
  setInterval(function () { if (T.seq > 0 && T.touch.frames.length !== sentFrames) send(); }, 20000);
  addEventListener("visibilitychange", function () { if (document.visibilityState === "hidden") send(); });
  setTimeout(function () {
    // A fixed tight loop: ~30 ms on a recent iPhone (secure context, Low Power Mode off), ~2x in Low Power Mode,
    // ~10x on an insecure origin, about a second in Lockdown Mode.
    var t = performance.now(), a = new Int32Array(65536), s = 0;
    for (var i = 0; i < 20000000; i++) s = (s + a[i & 65535] + i) | 0;
    T.jit = { loopMs: Math.round(performance.now() - t), s: s, wasm: typeof WebAssembly === "object", cores: navigator.hardwareConcurrency };
  }, 12000);
  setTimeout(send, 15000);
  addEventListener("pagehide", send);
})();
