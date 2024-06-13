// 刷新网页取消编辑状态
function main() {
  document.designMode = document.designMode === 'on' ? 'off' : 'on'
}

// ESC 取消编辑状态
function main() {
  document.body.setAttribute('contenteditable', 'true');
  document.onkeydown = function(e) {
    e = e || window.event;
    if (e.keyCode == 27) {
      document.body.setAttribute('contenteditable', 'false');
    }
  }
}

// 网页剪切工具: 手动选择删除网页中的某个元素
function main() {
  function fe(a, fn) {
    let i, l = a.length;
    for (i = 0; i < l; i++) {
      fn(a[i]);
    }
  }

  function ae(el, n, fn, ix) {
    function wfn(ev) {
      var el = ev.target;
      if (ix || !el.xmt) fn(el);
    }

    el.addEventListener(n, wfn, false);
    if (!el.es) el.es = [];

    el.es.push(function() {
      el.removeEventListener(n, wfn, false);
    });

    el.re = function() {
      fe(el.es, function(f) { f(); });
    }
  }

  function sce(el) {
    var oldclick = el.onclick;
    var oldmu = el.onmouseup;
    var oldmd = el.onmousedown;

    el.onclick = function() { return false; }
    el.onmouseup = function() { return false; }
    el.onmousedown = function() { return false; }
    el.rce = function() {
      el.onclick = oldclick;
      el.onmouseup = oldmu;
      el.onmousedown = oldmd;
    }
  }

  if (!window._priv_) window._priv_ = [];
  const priv = window._priv_;

  ae(document.body, 'mouseover', function(el) {
    el.style.backgroundColor = '#ffff99';
    sce(el)
  })

  ae(document.body, 'mouseout', function(el) {
    el.style.backgroundColor = '';
    if (el.rce) el.rce();
  })

  ae(document.body, 'click', function(el) {
    el.style.display = 'none';
    priv.push(el);
  });

  function ac(p, tn, ih) {
    var e = document.createElement(tn);
    if (ih) e.innerHTML = ih;
    p.appendChild(e);
    return e;
  }

  var p = 0;
  var bx = ac(document.body, 'div');
  bx.style.cssText  = 'position: fixed;';
  bx.style.cssText += 'padding: 2px; background-color: #99FF99;';
  bx.style.cssText += 'border: 1px solid green; z-index: 9999;';
  bx.style.cssText += 'font-family: sans-serif; font-size: 10px;';

  function sp() {
    bx.style.top    = (p & 2) ? ''     : '10px';
    bx.style.bottom = (p & 2) ? '10px' : '';
    bx.style.left   = (p & 1) ? ''     : '10px';
    bx.style.right  = (p & 1) ? '10px' : '';
  }

  sp();

  var ul = ac(bx, 'a', ' Undo Pre |');
  ae(ul, 'click', function() {
    var e = priv.pop();
    if (e) e.style.display = '';
  }, true);

  var ual = ac(bx, 'a', ' Undo All |');
  ae(ual, 'click', function() {
    var e; while (e = priv.pop()) e.style.display = '';
  }, true);

  var ml = ac(bx, 'a', ' Delete |');
  ae(ml, 'click', function() { p++; sp(); }, true);

  var xl = ac(bx, 'a', ' Exit ');
  ae(xl, 'click', function() {
    document.body.re(); bx.parentNode.removeChild(bx);
  }, true);

  fe([bx, ul, ml, xl, ual], function(e) {
    e.style.cursor = 'pointer'; e.xmt = 1;
  });
}
