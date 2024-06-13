# 浏览器 JS 小书签(bookmarklet)

- 最小化 JS 代码 https://minify-js.com
- 格式化 JS 代码 https://jsbeautify.org

- 书签栏分隔符 https://separator.mayastudios.com
- 小书签汇总表 https://www.runningcheese.com/bookmarklets
- 小书签在线生成工具
  * http://js.do/blog/bookmarklets
  * https://mrcoles.com/bookmarklet
  * https://caiorss.github.io/bookmarklet-maker
  * http://www.4umi.com/web/bookmarklet/edit.php
  * http://subsimple.com/bookmarklets/jsbuilder.htm
  * https://w-shadow.com/bookmarklet-combiner
  * https://sandbox.self.li/bookmarklet-to-extension
  * https://www.squarefree.com/userstyles/make-bookmarklet.html

```js
javascript: function main() { ; } main(); void (0);
javascript: (() => { alert('Hi, Bookmarklet!'); })(); void (0);
javascript: (() => { location.assign("https://www.baidu.com/"); })();
javascript: (() => { window.open('https://www.baidu.com','_blank'); })();

javascript: function main() {
 let wikiURL = "https://www.baidu.com";
 if(/(windows)/i.test(navigator.userAgent)) {
   wikiURL = "https://cn.bing.com/?FORM=BEHPTB&ensearch=1";
  } // window.location.href
  window.open(wikiURL); // ----- 浏览器小书签不能有注释 -----
} main(); void (0); // void (0); 阻止当前页面跳转到其它页面

window.open('https://www.baidu.com', '_self');    // 覆盖当前页
window.open('https://www.baidu.com', '_blank');   // 新窗口打开
```

<!--
function main() { ... }
javascript:(()=>{ ... })();

浏览器 Edge 和 Chrome 的数据通用
书签数据：path/to/User Data/Default/Bookmarks
书签图标：path/to/User Data/Default/Favicons
历史记录：path/to/User Data/Default/History
搜索引擎：path/to/User Data/Default/Web Data
-->

```html
<a href="javascript: ( () => { ; } )();">匿名函数立即执行</a>
<a href="javascript: function main() { ; } main();">标签名</a>
```

## 小书签 JS 代码列表

```js
function main() {
  const color = () => Math.floor(Math.random() * 255);
  const list = document.body.getElementsByTagName('*');
  for (let item of list) {
    const rgb = 'rgb(' + color() + ',' + color() + ',' + color() + ')';
    const { style } = item;
    style.outline = style.outline ? '' : '2px solid ' + rgb;
  }
}
```
