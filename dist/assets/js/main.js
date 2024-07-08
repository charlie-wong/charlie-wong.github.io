// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-03T06:18:56+08:00 Asia/Shanghai
// Repository: https://github.com/xwlc/xwlc.github.io

console.log(
    zlog.css('darkgray').words('Welcome to ')
  + zlog.css('limegreen').words('Charles')
  + zlog.blue('<')
  + zlog.css('orangered').words('书生')
  + zlog.blue('>')
  + zlog.css('darkgray').words(' blog space!')
);

function faviconEmoji(icon) {
  let svg = '';
  svg += '<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22>';
  svg += '  <text y=%22.9em%22 font-size=%2290%22>';
  svg += icon;
  svg += '  </text>';
  svg += '</svg>';
  return svg.trim();
}

document.addEventListener('DOMContentLoaded', () => {
  const yearAnimalIcon = LunarCalendar.lunarNow().year.gz.y.ani.icon[0];
  document.querySelector(`head > link[rel='icon']`).setAttribute(
    'href', 'data:image/svg+xml,' + faviconEmoji(yearAnimalIcon)
  );
});
