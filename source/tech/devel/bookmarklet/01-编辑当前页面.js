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
  var isIe = false;

  function fe(a, fn) {
    var i, l = a.length;
    for (i = 0; i < l; i++) {
      fn(a[i]);
    }
  }

  function ae(el, n, fn, ix) {
    function wfn(ev) {
      var el = (isIe ? window.event.srcElement : ev.target);
      if (ix || !el.xmt) fn(el);
    }
    if (isIe) {
      n = 'on' + n;
      el.attachEvent(n, wfn);
    } else {
      el.addEventListener(n, wfn, false);
    }
    if (!el.es) el.es = [];
    el.es.push(function() {
      if (isIe) {
        el.detachEvent(n, wfn);
      } else {
        el.removeEventListener(n, wfn, false);
      }
    });
    el.re = function() {
      fe(el.es, function(f) {
        f()
      });
    }
  }

  function sce(el) {
    var oldclick = el.onclick,
    oldmu = el.onmouseup,
    oldmd = el.onmousedown;
    el.onclick = function() {
      return false;
    };
    el.onmouseup = function() {
      return false;
    };
    el.onmousedown = function() {
      return false;
    };
    el.rce = function() {
      el.onclick = oldclick;
      el.onmouseup = oldmu;
      el.onmousedown = oldmd;
    };
  }
  if (!window.r_) window.r_ = [];
  var r = window.r_;
  var D = document;
  ae(D.body, 'mouseover', function(el) {
    el.style.backgroundColor = '#ffff99';
    sce(el)
  });
  ae(D.body, 'mouseout', function(el) {
    el.style.backgroundColor = '';
    if (el.rce) el.rce();
  });
    ae(D.body, 'click', function(el) {
      el.style.display = 'none';
      r.push(el);
    });

    function ac(p, tn, ih) {
      var e = D.createElement(tn);
      if (ih) e.innerHTML = ih;
      p.appendChild(e);
      return e;
    }
    var p = 0;
    var bx = ac(D.body, 'div');
    bx.style.cssText  = 'position:' + (isIe ? 'absolute' : 'fixed') + ';';
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

    var ul = ac(bx, 'a', ' Undo |');
    ae(ul, 'click', function() {
      var e = r.pop();
      if (e) e.style.display = '';
    }, true);

    var ual = ac(bx, 'a', ' Undo All |');
    ae(ual, 'click', function() {
      var e; while (e = r.pop()) e.style.display = '';
    }, true);

    var ml = ac(bx, 'a', ' Move |');
    ae(ml, 'click', function() { p++; sp(); }, true);

    var xl = ac(bx, 'a', ' Exit ');
    ae(xl, 'click', function() {
      D.body.re(); bx.parentNode.removeChild(bx);
    }, true);

    fe([bx, ul, ml, xl, ual], function(e) {
      e.style.cursor = 'pointer'; e.xmt = 1;
    });
}
