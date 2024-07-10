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
