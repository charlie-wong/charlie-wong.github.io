(function() { // 百度统计 https://tongji.baidu.com
  const hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?c4bbeba2c5f16a633fe7e912a413092d";
  const s = document.getElementsByTagName("script")[0];
  s.parentNode.insertBefore(hm, s);
})();

class WEBSITE {
  // UV: 独立访客数(Unique Visitor)
  static thisPageUV(url) {
    return 'UV: 0000,0001';
  }
  // PV: 页面浏览量(Page View)
  static thisPagePV(url) {
    return 'PV: 0000,0001';
  }
}
// window.location.href         完整 URL 地址
// window.location.protocol     地址协议类型
// window.location.host         主机名+端口号
// window.location.pathname     当前 URL 相对路径
// window.location.search       当前 URL 的参数
// https://developer.mozilla.org/en-US/docs/Web/API/Location
//
// if(/^https:\/\/xwlc.github.io/i.test(window.location.href))
// window.location.protocol + '//' + window.location.host + '/'
//
// const idx = window.location.href.indexOf(window.location.pathname);
// if ( idx > 0 ) window.location.href.substring(0, idx) // 不含 idx 字符
