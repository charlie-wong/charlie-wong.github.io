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
