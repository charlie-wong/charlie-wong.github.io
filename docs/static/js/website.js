class WEBSITE {
  // .github/actions/update-website.sh
  static repositoryHome = 'xSrcHomeURL';
  static repoUpdateTime = 'xCommitTime';
  static repoCommitHash = 'xCommitHash';

  // UV: 独立访客数(Unique Visitor)
  static thisPageUV(url) {
    console.log(zlog.red('TODO') + ' ' + url);
    return 'UV: 0000,0001';
  }
  // PV: 页面浏览量(Page View)
  static thisPagePV(url) {
    console.log(zlog.red('TODO') + ' ' + url);
    return 'PV: 0000,0001';
  }

  static getPageUrl(page) {
    const oldUrl = window.location.href;
    if(/^https:/i.test(oldUrl)) {
      return WEBSITE.repositoryHome + page;
    } else {
      const websiteRoot = '/docs';
      const idx = oldUrl.indexOf(websiteRoot);
      if ( idx >= 0 ) { // 不包含 idx 字符
        return oldUrl.substring(0, idx) + websiteRoot + page;
      }
    }
  }
}
