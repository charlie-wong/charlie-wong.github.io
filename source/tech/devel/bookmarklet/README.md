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

// 网页元素删除
// 解除网页的<复制>及<右键菜单>限制

// 自动滚屏
// 自动刷新

// 护眼模式
// 黑暗模式
// 阅读模式

// 水平分屏模式
// 垂直分屏模式

// 隐藏已读的网页连接
// 网页背景(书报信纸样式)

// 切换<有>衬线字体
// 切换<无>衬线字体

// 加粗各单词前字符(提高效率)
// 英语长居着色处理(提高效率)

// 将网页转换为简体中文
// 将网页转换为繁体中文
// 新标签页打开百度翻译
// 谷歌网页翻译(旧版)
// 谷歌网页翻译(新版)

// 百度小窗搜索
// 百度站内搜索
// 必应小窗搜索
// 必应站内搜索

// 查看当前网页的所有链接
// 列出当前网页可下载资源

// 新标签页查看图片时按 shift+alt+= 背景黑白切换
// 新标签页查看图片时按 alt+=       顺时旋转图片
// 新标签页查看图片时按 alt+-       逆时旋转图片
// 新标签页查看图片时按 shift+=     图片放至最大
// 新标签页查看图片时按 shift+-     图片恢复原样

// 表格增加<正序>和<反序>按钮

// 查看浏览器 UA(User Agent)
// 查看当前网页 Cookie
// 查看网页图标
// 查看网页<骨架>特效

// IP 查询
// SEO 查询
// DNS 查询
// Whois 查询
// Buildwith 查询
// 网站综合查询

// 查看当前网页网格布局结构
function main() {
  const color = () => Math.floor(Math.random() * 255);
  const list = document.body.getElementsByTagName('*');
  for (let item of list) {
    const rgb = 'rgb(' + color() + ',' + color() + ',' + color() + ')';
    const { style } = item;
    style.outline = style.outline ? '' : '2px solid ' + rgb;
  }
}

// 旋转网页
function main() {
  if (typeof rotateNum === 'undefined') {
    rotateNum = 180;
  } else {
    rotateNum = rotateNum ? 0: 180;
  }
  document.body.style.cssText +="transition: all 1s;";
  document.body.style.cssText +="transform: rotate(" + rotateNum + "deg);";
}

// 旋转视频方向

// 生成网页二维码图片(当前页面弹窗)
function main() {}

// 生成网页二维码图片(新页面显示)
// 博客预设留言
// 网购价格比较
// 查看 firefox 和 chrome 扩展源码
//
```
