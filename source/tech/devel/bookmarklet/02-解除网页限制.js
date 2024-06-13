// 解除网页<选择复制>和<右键菜单>等限制
function main() {
  document.querySelectorAll('*').forEach(e => {
    if ('none' === window.getComputedStyle(e, null).getPropertyValue('user-select')) {
      e.style.setProperty('user-select', 'text', 'important')
    }
  });

  function handler(e) {
    e.stopPropagation();
    e.stopImmediatePropagation && e.stopImmediatePropagation()
  }

  const actions = [
    'copy', 'cut', 'contextmenu', 'selectstart', 'mousedown', 'mouseup', 'mousemove', 'keydown', 'keypress', 'keyup'
  ];
  actions.forEach(function(e) {
    document.documentElement.addEventListener(e, handler, { capture: !0 })
  })
}
