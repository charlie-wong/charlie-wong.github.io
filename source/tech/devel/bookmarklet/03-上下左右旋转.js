// 上下左右旋转网页
function main() {
  if (typeof rotateNum === 'undefined') {
    rotateNum = 180;
  } else {
    rotateNum = rotateNum ? 0: 180;
  }
  document.body.style.cssText +="transition: all 1s;";
  document.body.style.cssText +="transform: rotate(" + rotateNum + "deg);";
}
