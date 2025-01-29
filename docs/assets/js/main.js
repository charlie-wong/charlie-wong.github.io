// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-03T06:18:56+08:00 Asia/Shanghai
// Repository: https://github.com/xwlc/xwlc.github.io

console.log(
    zlog.css('darkgray').words('Welcome to ')
  + zlog.css('limegreen').words('Charles')
  + zlog.blue('<')
  + zlog.css('orangered').words('Wong')
  + zlog.blue('>')
  + zlog.css('darkgray').words(' blog!')
);

document.addEventListener('DOMContentLoaded', () => {
  if(isMobile()) {
    const footer = document.getElementById('thisPageFooter');
    footer.parentNode.removeChild(footer);
    return;
  }

  const thisPageUV = document.getElementById('thisPageUV');
  thisPageUV.innerHTML = WEBSITE.thisPageUV(window.location.href);
  const thisPagePV = document.getElementById('thisPagePV');
  thisPagePV.innerHTML = WEBSITE.thisPagePV(window.location.href);
});
