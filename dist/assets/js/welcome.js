// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-05T07:56:07+08:00 Asia/Shanghai
// Repository: https://github.com/xwlc/xwlc.github.io

const timezoneName = Intl.DateTimeFormat().resolvedOptions().timeZone;
const timezoneOffset = (function() {
  let hh, mm, sign, val = new Date().getTimezoneOffset();
  if(val < 0) { sign = '+'; val = -val; } else { sign = '-'; }
  hh = Math.floor(val / 60).toString().padStart(2, '0');
  mm = (val % 60).toString().padStart(2, '0');
  return sign + hh + mm;
})();

const wUpdate = {
  cancelId: -1, nowSecond: 0, lunarMinute: 0, treeCnt: 0, treeMax: 3,
};

const wAnimation = {
  gzShiCiName: '', gzShiCiDesc: '',
  figureIdx: 0, figureIcon: [ '🯅', '🯆', '🯇', '🯈' ],
  clocksIdx: 0, clocksIcon: [
    '🕐', '🕜', '🕑', '🕝', '🕒', '🕞', '🕓', '🕟',
    '🕔', '🕠', '🕕', '🕡', '🕖', '🕢', '🕗', '🕣',
    '🕘', '🕤', '🕙', '🕥', '🕚', '🕦', '🕛', '🕧'
  ]
};

// https://drafts.csswg.org/css-color/#named-colors
function waD9(msg) { return `<a style='color: darkgray'>${msg}</a>` }
function waR3(msg) { return `<a style='color: hotpink'>${msg}</a>` }
function waG3(msg) { return `<a style='color: lawngreen'>${msg}</a>` }
function waB3(msg) { return `<a style='color: deepskyblue'>${msg}</a>` }
function waY3(msg) { return `<a style='color: yellow'>${msg}</a>` }
function waO3(msg) { return `<a style='color: darkorange'>${msg}</a>` }
function waC3(msg) { return `<a style='color: turquoise'>${msg}</a>` }
function waZ1(msg) { return `<a style='color: khaki'>${msg}</a>` }
function waZ2(msg) { return `<a style='color: lightcyan'>${msg}</a>` }

function updateWelcome() {
  const now = new Date(); let loc ={}, utc = {};
  loc.Y = now.getFullYear(); loc.M = now.getMonth() + 1; loc.D = now.getDate();
  loc.h = now.getHours();    loc.m = now.getMinutes();   loc.s = now.getSeconds();
  wUpdate.nowSecond = loc.s;
  utc.Y = now.getUTCFullYear(); utc.M = now.getUTCMonth() + 1; utc.D = now.getUTCDate();
  utc.h = now.getUTCHours();    utc.m = now.getUTCMinutes();   utc.s = now.getUTCSeconds();

  let upLunar = Math.floor(loc.m / 15) > wUpdate.lunarMinute;
  if(!wAnimation.gzShiCiName) upLunar = true;
  if(wUpdate.lunarMinute == 3 && Math.floor(loc.m / 15) == 0) upLunar = true;
  if(upLunar) { // 天干地址 => 每刻钟更新
    wUpdate.lunarMinute = Math.floor( loc.m / 15 );
    const lunar = LunarCalendar.lunarNow();
    const  yA = lunar.year.gz.y.ani.name,
           yG = lunar.year.gz.y.gan,     yZ = lunar.year.gz.y.zhi,
           mG = lunar.year.gz.m.gan,     mZ = lunar.year.gz.m.zhi,
           dG = lunar.year.gz.d.gan,     dZ = lunar.year.gz.d.zhi;
    const gzN = lunar.time.ganzhi.name, gzX = lunar.time.ganzhi.nick,
          gzH = lunar.time.ganzhi.hour, gzM = lunar.time.ganzhi.mins
          gzG = lunar.time.ganzhi.geng;

    wAnimation.gzShiCiName = lunar.time.hisart.name;
    wAnimation.gzShiCiDesc = lunar.time.hisart.desc;

    const gzTimeYears = document.getElementById("gzTimeYears");
    gzTimeYears.innerHTML =
        waG3(yG)  + waB3(yZ)  + waR3("❲"+yA+"❳") + waD9('年 ')
      + waG3(mG)  + waB3(mZ)  + waD9('月 ')
      + waG3(dG)  + waB3(dZ)  + waD9('日 ➠ ')
      + waO3(gzN) + waY3(gzH) + waC3(gzM) + waD9(' ￮ '+gzX);
    if(gzG) { gzTimeYears.innerHTML += waD9(gzG); }
  }

  loc.M = padNum(loc.M); loc.D = padNum(loc.D);
  loc.h = padNum(loc.h); loc.m = padNum(loc.m); loc.s = padNum(loc.s);

  utc.M = padNum(utc.M); utc.D = padNum(utc.D);
  utc.h = padNum(utc.h); utc.m = padNum(utc.m); utc.s = padNum(utc.s);

  let YMDhmsZ, gzShiCi;
  gzShiCi = wAnimation.clocksIcon[wAnimation.clocksIdx] + ' ';
  wAnimation.clocksIdx = ( wAnimation.clocksIdx + 1 ) % 24;
  gzShiCi += waZ1(wAnimation.gzShiCiName) + ' ';
  if(!wUpdate.isMobile) {
    gzShiCi += waD9(wAnimation.figureIcon[wAnimation.figureIdx]) + ' ';
    wAnimation.figureIdx = ( wAnimation.figureIdx + 1 ) % 4;
  }
  gzShiCi += waZ2(wAnimation.gzShiCiDesc);
  document.getElementById("gzTimeShiCi").innerHTML = gzShiCi;

  YMDhmsZ  = loc.Y + '-' + loc.M + '-' + loc.D + ' ';
  YMDhmsZ += loc.h + ':' + loc.m + ':' + loc.s + ' ' + timezoneOffset;
  document.getElementById("showTimeLoc").innerHTML = waD9(YMDhmsZ);
  YMDhmsZ  = utc.Y + '-' + utc.M + '-' + utc.D + ' ';
  YMDhmsZ += utc.h + ':' + utc.m + ':' + utc.s + ' +0000';
  document.getElementById("showTimeUtc").innerHTML = waD9(YMDhmsZ);

  if(wUpdate.isMobile) { return; }

  if(wUpdate.nowSecond % 30 == 0) { // 每半秒刷新一次
    if(wUpdate.treeCnt % wUpdate.treeMax == 0) {
      wUpdate.treeCnt = 0; // [1, 9] 次后清空画布
      wUpdate.treeMax = ZATree.randomInteger(1, 9);
      const zatree = document.getElementById('ZATreeCanvas');
      const ctx = zatree.getContext('2d'); // 清空画布
      ctx.clearRect(0, 0, zatree.width, zatree.height);
    }
    drawZATree(); wUpdate.treeCnt++;
    const zatTitle = document.getElementById('ZATreeTitle');
    if(zatTitle.innerText == 'Download') {
      zatTitle.classList.add("xlabel");
      zatTitle.classList.remove("xbutton");
      zatTitle.removeEventListener('click', saveZATreeAsIamge);
    }
    zatTitle.innerText = wUpdate.treeCnt + '/' + wUpdate.treeMax;
  }
}

function drawZATree() {
  ZATree.draw(document.getElementById('ZATreeCanvas'), { randomColor: true });
}

function saveZATreeAsIamge() {
  const now = new Date(); let Y, M, D, h, m, s;
  Y = now.getFullYear(); M = now.getMonth() + 1; D = now.getDate();
  h = now.getHours();    m = now.getMinutes();   s = now.getSeconds();

  M = padNum(M); D = padNum(D);
  h = padNum(h); m = padNum(m); s = padNum(s);

  const a = document.createElement('a');
  a.download = 'ZATree-'+Y+'-'+M+'-'+D+'-'+'T'+h+'-'+m+'-'+s;
  a.href = ZATree.base64(document.getElementById('ZATreeCanvas'));
  a.dispatchEvent(new MouseEvent('click'));
}

function downloadZATreeIamge() {
  const zatTitle = document.getElementById('ZATreeTitle');
  if(zatTitle.innerText == 'Download') { return; }
  zatTitle.innerText = 'Download';
  zatTitle.classList.add("xbutton");
  zatTitle.classList.remove("xlabel");
  zatTitle.addEventListener('click', saveZATreeAsIamge);
}

function loadArt(what) {
  //window.removeEventListener('dblclick', loadArt);
  if(wUpdate.cancelId > -1) clearInterval(wUpdate.cancelId);

  const timebox = document.getElementById('timeInfo');
  timebox.removeEventListener('click', loadArt);
  const zatree = document.getElementById('ZATreeCanvas');
  zatree.removeEventListener('click', downloadZATreeIamge);

  window.location.href = getFullUrl(window.location.href, '/art.html');
}

//window.addEventListener('dblclick', loadArt);
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('wBlog').setAttribute(
    'href', getFullUrl(window.location.href, '/blog.html')
  );
  document.getElementById('wArts').setAttribute(
    'href', getFullUrl(window.location.href, '/art.html')
  );

  const timebox = document.getElementById('timeInfo');
  const zatree = document.getElementById('ZATreeCanvas');

  if(isMobile()) {
    wUpdate.isMobile = true;
    timebox.style.width = '60%';
    zatree.style.display = 'none';
    document.getElementById('wNavigation').style.width = '80%';

    let item = document.getElementById('wNavigation');
    item = item.querySelectorAll('div');
    item[2].remove(); item[3].remove();

    item = document.getElementById('ZATreeCanvas');
    item.parentNode.removeChild(item);

    item = document.createElement('div');
    item.style.height = '32%'; // appendChild();
    document.querySelector('main').prepend(item);

    item = document.getElementById('ganzhi');
    item.style.cssText = 'font-size: 2vmin';
    item = document.getElementById('locutc');
    item.style.cssText = 'font-size: 4vmin';
  } else {
    zatree.width  = window.screen.width  * 0.6;
    zatree.height = window.screen.height * 0.6;

    timebox.addEventListener('click', loadArt);
    zatree.addEventListener('click', downloadZATreeIamge);

    wUpdate.treeCnt++; drawZATree();
  }

  updateWelcome();
  wUpdate.cancelId = setInterval(updateWelcome, 1000); // 每秒刷新
});
