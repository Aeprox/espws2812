(function() {
  function D() {
    var d = new XMLHttpRequest;
    d.open("GET", "/setAjax?r=" + ~~g[0] + "?g=" + ~~g[1] + "?b=" + ~~g[2], !0);
    d.send();
  }
  function p(d) {
    f = d.pageX - c.offsetLeft - 200 || f;
    e = d.pageY - c.offsetTop - 200 || e;
    d = u(e, f);
    var v = f * f + e * e;
    36100 < v && (f = 190 * m.cos(d), e = 190 * m.sin(d), d = u(e, f), v = f * f + e * e);
    g = E((d + w) / z, F(v) / 190, k.value / G);
    n.textContent = g[3];
    a.putImageData(H, 0, 0);
    a.beginPath();
    a.strokeStyle = "#000";
    a.arc(~~f + 200, ~~e + 200, 4, 0, z);
    a.stroke();
  }
  function E(d, e, h) {
    d *= 6;
    var f = ~~d, g = d - f;
    d = h * (1 - e);
    var k = h * (1 - g * e);
    e = h * (1 - (1 - g) * e);
    var l = f % 6, f = 255 * [h, k, d, d, e, h][l], g = 255 * [e, h, h, k, d, d][l];
    h = 255 * [d, d, e, h, h, k][l];
    return [f, g, h, "rgb(" + ~~f + "," + ~~g + "," + ~~h + ")"];
  }
  var l = document;
  l.c = l.createElement;
  b.a = b.appendChild;
  var q = c.width = c.height = 400, n = b.a(l.c("p")), k = b.a(l.c("input")), H = a.createImageData(q, q), r = H.data, G = k.value = k.max = 100, g, e = G, f = -e, t = 16040, A, m = Math, w = m.PI, z = 2 * w, F = m.sqrt, u = m.atan2;
  b.style.textAlign = "center";
  n.style.font = "2em courier";
  k.type = "range";
  for (y = k.min = 0;y < q;y++) {
    for (x = 0;x < q;x++) {
      var B = x - 190, C = y - 190, I = B * B + C * C;
      g = E((u(C, B) + w) / z, F(I) / 190, 1);
      r[t++] = g[0];
      r[t++] = g[1];
      r[t++] = g[2];
      r[t++] = 36100 < I ? 0 : 255;
    }
  }
  k.onchange = p;
  c.onmousedown = l.onmouseup = function(d) {
    l.onmousemove = /p/.test(d.type) ? 0 : (p(d), p);
  };
  k.onchange = c.onmouseup = D;
  p(0);
  setInterval(function() {
    A != n.textContent && (A = n.textContent, D());
  }, 100);
  A = n.textContent;
})();