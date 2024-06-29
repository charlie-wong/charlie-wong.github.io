// 显示当前页面网格布局结构
function main() {
  const color = () => Math.floor(Math.random() * 255);
  const list = document.body.getElementsByTagName('*');
  for (let item of list) {
    const rgb = 'rgb(' + color() + ',' + color() + ',' + color() + ')';
    const { style } = item;
    style.outline = style.outline ? '' : '2px solid ' + rgb;
  }
}
