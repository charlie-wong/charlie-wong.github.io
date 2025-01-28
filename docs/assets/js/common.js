// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-05T10:39:41+08:00 Asia/Shanghai
// Repository: https://github.com/xwlc/xwlc.github.io

function padNum(val) {
  return val.toString().padStart(2, "0");
}

function isMobile() {
  if (/Android|iPhone|iPad|iPod/i.test(navigator.userAgent)) {
    return true;
  } else {
    return false;
  }
}

function updateEmojiFavicon(icon) {
  let svg = '';
  svg += '<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22>';
  svg += '  <text y=%22.9em%22 font-size=%2290%22>';
  svg += icon;
  svg += '  </text>';
  svg += '</svg>';
  document.querySelector(`head > link[rel='icon']`).setAttribute(
    'href', 'data:image/svg+xml,' + svg.trim()
  );
}
