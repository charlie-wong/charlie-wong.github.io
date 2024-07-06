// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-05T01:24:31+08:00 Asia/Shanghai
// Repository: git@gitlab.com:xwlc/zeta

// 浏览器控制台
//   console.error('报错信息 => 默认红色');
//   console.log('%c绿色信息', 'color: #529b2e');
// 浏览器控制台 + 终端
//   console.log(  '\x1B[32m%s\x1B[0m', '绿色信息');
//   console.log('\u001B[31m%s\x1B[0m', '红色信息');
//
// https://developer.mozilla.org/en-US/docs/Web/API/console
// log() info() warn() error() debug() assert() trace() clear()
//
// 参考代码 https://github.com/chalk/chalk
class ZLog {
  // 静态公共属性
  static _instance_ = null; // 确保仅创建单个实例

  static RTME = {}; // Runtime Environment
  static { // 静态构造器(类实例初始化时执行一次)
    if (typeof(process) === 'object') {
      this.RTME.nodejs = true;
      this.RTME.supports = {
        nocolor: false, ansi: true, ansi256: false, truecolor: false,
      };

      const tty = require('tty');
      const proc = require('process');
      if(! tty.isatty(1) || ! tty.isatty(2)) {
        this.RTME.supports.ansi = false;
        this.RTME.supports.nocolor = true;
      } else {
        function hasFlag(flag) {
          const prefix = flag.startsWith('-') ? '' : (flag.length === 1 ? '-' : '--');
          const position = proc.argv.indexOf(prefix + flag);
          const terminator = proc.argv.indexOf('--');
          return position !== -1 && (terminator === -1 || position < terminator);
        }

        if(hasFlag('no-color')  || hasFlag('no-colors')  || hasFlag('color=false')  || hasFlag('color=never')) {
          this.RTME.supports.ansi = false;
          this.RTME.supports.nocolor = true;
        } else {
          if(  proc.env.TERM === 'xterm-kitty'
            || proc.env.COLORTERM === 'truecolor'
            || hasFlag('color=16m')
            || hasFlag('color=full')
            || hasFlag('color=truecolor')
          ) {
            this.RTME.supports.truecolor = true;
          }

          if(hasFlag('color=256') || /-256(color)?$/i.test(proc.env.TERM)) {
            this.RTME.supports.ansi256 = true;
          }

          if ('CI' in proc.env) {
            if ('GITHUB_ACTIONS' in proc.env || 'GITEA_ACTIONS' in proc.env) {
              this.RTME.supports.truecolor = true;
            }
          }

          if(proc.platform === 'win32') {
            const release = require('os').release().split('.');
            // Windows 10 build 10586 is the first release supports 256colors.
            // Windows 10 build 14931 is the first release supports trueColor.
            if(Number(release[0]) >= 10  && Number(release[2]) >= 10_586  ) {
              if(Number(release[2]) >= 14_931) {
                this.RTME.supports.truecolor = true;
              } else {
                this.RTME.supports.ansi256 = true;
              }
            }
          }
        }
      }
    } else {
      this.RTME.browser = true;
      this.RTME.supports = {
        nocolor: false, ansi: true, ansi256: true, truecolor: true,
      };
    }
  }

  // 转移序列 $ man console_codes
  // 38 设置 fg 颜色, 48 设置 bg 颜色
  // https://talyian.github.io/ansicolors
  // https://ss64.com/nt/syntax-ansi.html
  static CODE = {};
  static ANSI = {
    attrs: {        // 开  关
      reset:          [0,   0],
      bold:           [1,  22], // 粗体
      dim:            [2,  22], // 暗色(降低亮度)   NOTE 仅 NodeJS 终端有效
      italic:         [3,  23], // 斜体
      underline:      [4,  24], // 下划线
      blink:          [5,  25], // 闪烁             NOTE 仅 NodeJS 终端有效
      inverse:        [7,  27], // bg/fg 颜色反转   NOTE 仅 NodeJS 终端有效
      hidden:         [8,  28], // 隐藏             NOTE 仅 NodeJS 终端有效
      strikethrough:  [9,  29], // 删除线
      overline:       [53, 55], // 上划线           NOTE 仅 NodeJS 终端有效
    },
    color: {
      fg: { // 39 默认 fg 颜色
        black:    { normal: [30, 39],   bright: [90, 39] },
        red:      { normal: [31, 39],   bright: [91, 39] },
        green:    { normal: [32, 39],   bright: [92, 39] },
        yellow:   { normal: [33, 39],   bright: [93, 39] },
        blue:     { normal: [34, 39],   bright: [94, 39] },
        purple:   { normal: [35, 39],   bright: [95, 39] },
        cyan:     { normal: [36, 39],   bright: [96, 39] },
        white:    { normal: [37, 39],   bright: [97, 39] },

        gray:     { bright: [2,  39],   normal: [90, 39] },
        grey:     { bright: [2,  39],   normal: [90, 39] },
      },
      bg: { // 49 默认 bg 颜色
        black:    { normal: [40, 49],   bright: [100, 49] },
        red:      { normal: [41, 49],   bright: [101, 49] },
        green:    { normal: [42, 49],   bright: [102, 49] },
        yellow:   { normal: [43, 49],   bright: [103, 49] },
        blue:     { normal: [44, 49],   bright: [104, 49] },
        purple:   { normal: [45, 49],   bright: [105, 49] },
        cyan:     { normal: [46, 49],   bright: [106, 49] },
        white:    { normal: [47, 49],   bright: [107, 49] },

        gray:     { bright: [2,  49],   normal: [100, 49] },
        grey:     { bright: [2,  49],   normal: [100, 49] },
      }
    }
  }
  static {
    const ansi256 = (offset = 0) => (msg, index, attrs='') => '\u001B[0m' + `\u001B[${attrs}${38 + offset};5;${index}m`       + msg + '\u001B[0m';
    const ansi16m = (offset = 0) => (msg, R,G,B, attrs='') => '\u001B[0m' + `\u001B[${attrs}${38 + offset};2;${R};${G};${B}m` + msg + '\u001B[0m';

    this.CODE.ansi256FG = ansi256(); this.CODE.ansi256BG = ansi256(10);
    this.CODE.ansi16mFG = ansi16m(); this.CODE.ansi16mBG = ansi16m(10);
    this.CODE.ansiColor = (msg, index, attrs='') => '\u001B[0m' + `\u001B[${attrs}${index}m` + msg + '\u001B[0m';
  }

  // https://github.com/colorjs/color-name
  // https://www.w3.org/TR/css-color-3/#html4
  // https://www.w3.org/TR/css-color-3/#svg-color
  // https://drafts.csswg.org/css-color/#named-colors
  static cssNamedColorToHex(name) {
    const rgb = ZLog.CssNamedColor[name];
    return rgb ? rgb : [ 0, 0, 0 ];
  }
  static CssNamedColor = {
    aliceblue:            [240,  248,  255],
    antiquewhite:         [250,  235,  215],
    aqua:                 [0,    255,  255],
    aquamarine:           [127,  255,  212],
    azure:                [240,  255,  255],
    beige:                [245,  245,  220],
    bisque:               [255,  228,  196],
    black:                [0,    0,    0  ],
    blanchedalmond:       [255,  235,  205],
    blue:                 [0,    0,    255],
    blueviolet:           [138,  43,   226],
    brown:                [165,  42,   42 ],
    burlywood:            [222,  184,  135],
    cadetblue:            [95,   158,  160],
    chartreuse:           [127,  255,  0  ],
    chocolate:            [210,  105,  30 ],
    coral:                [255,  127,  80 ],
    cornflowerblue:       [100,  149,  237],
    cornsilk:             [255,  248,  220],
    crimson:              [220,  20,   60 ],
    cyan:                 [0,    255,  255],
    darkblue:             [0,    0,    139],
    darkcyan:             [0,    139,  139],
    darkgoldenrod:        [184,  134,  11 ],
    darkgray:             [169,  169,  169],
    darkgreen:            [0,    100,  0  ],
    darkgrey:             [169,  169,  169],
    darkkhaki:            [189,  183,  107],
    darkmagenta:          [139,  0,    139],
    darkolivegreen:       [85,   107,  47 ],
    darkorange:           [255,  140,  0  ],
    darkorchid:           [153,  50,   204],
    darkred:              [139,  0,    0  ],
    darksalmon:           [233,  150,  122],
    darkseagreen:         [143,  188,  143],
    darkslateblue:        [72,   61,   139],
    darkslategray:        [47,   79,   79 ],
    darkslategrey:        [47,   79,   79 ],
    darkturquoise:        [0,    206,  209],
    darkviolet:           [148,  0,    211],
    deeppink:             [255,  20,   147],
    deepskyblue:          [0,    191,  255],
    dimgray:              [105,  105,  105],
    dimgrey:              [105,  105,  105],
    dodgerblue:           [30,   144,  255],
    firebrick:            [178,  34,   34 ],
    floralwhite:          [255,  250,  240],
    forestgreen:          [34,   139,  34 ],
    fuchsia:              [255,  0,    255],
    gainsboro:            [220,  220,  220],
    ghostwhite:           [248,  248,  255],
    gold:                 [255,  215,  0  ],
    goldenrod:            [218,  165,  32 ],
    gray:                 [128,  128,  128],
    green:                [0,    128,  0  ],
    greenyellow:          [173,  255,  47 ],
    grey:                 [128,  128,  128],
    honeydew:             [240,  255,  240],
    hotpink:              [255,  105,  180],
    indianred:            [205,  92,   92 ],
    indigo:               [75,   0,    130],
    ivory:                [255,  255,  240],
    khaki:                [240,  230,  140],
    lavender:             [230,  230,  250],
    lavenderblush:        [255,  240,  245],
    lawngreen:            [124,  252,  0  ],
    lemonchiffon:         [255,  250,  205],
    lightblue:            [173,  216,  230],
    lightcoral:           [240,  128,  128],
    lightcyan:            [224,  255,  255],
    lightgoldenrodyellow: [250,  250,  210],
    lightgray:            [211,  211,  211],
    lightgreen:           [144,  238,  144],
    lightgrey:            [211,  211,  211],
    lightpink:            [255,  182,  193],
    lightsalmon:          [255,  160,  122],
    lightseagreen:        [32,   178,  170],
    lightskyblue:         [135,  206,  250],
    lightslategray:       [119,  136,  153],
    lightslategrey:       [119,  136,  153],
    lightsteelblue:       [176,  196,  222],
    lightyellow:          [255,  255,  224],
    lime:                 [0,    255,  0  ],
    limegreen:            [50,   205,  50 ],
    linen:                [250,  240,  230],
    magenta:              [255,  0,    255],
    maroon:               [128,  0,    0  ],
    mediumaquamarine:     [102,  205,  170],
    mediumblue:           [0,    0,    205],
    mediumorchid:         [186,  85,   211],
    mediumpurple:         [147,  112,  219],
    mediumseagreen:       [60,   179,  113],
    mediumslateblue:      [123,  104,  238],
    mediumspringgreen:    [0,    250,  154],
    mediumturquoise:      [72,   209,  204],
    mediumvioletred:      [199,  21,   133],
    midnightblue:         [25,   25,   112],
    mintcream:            [245,  255,  250],
    mistyrose:            [255,  228,  225],
    moccasin:             [255,  228,  181],
    navajowhite:          [255,  222,  173],
    navy:                 [0,    0,    128],
    oldlace:              [253,  245,  230],
    olive:                [128,  128,  0  ],
    olivedrab:            [107,  142,  35 ],
    orange:               [255,  165,  0  ],
    orangered:            [255,  69,   0  ],
    orchid:               [218,  112,  214],
    palegoldenrod:        [238,  232,  170],
    palegreen:            [152,  251,  152],
    paleturquoise:        [175,  238,  238],
    palevioletred:        [219,  112,  147],
    papayawhip:           [255,  239,  213],
    peachpuff:            [255,  218,  185],
    peru:                 [205,  133,  63 ],
    pink:                 [255,  192,  203],
    plum:                 [221,  160,  221],
    powderblue:           [176,  224,  230],
    purple:               [128,  0,    128],
    rebeccapurple:        [102,  51,   153],
    red:                  [255,  0,    0  ],
    rosybrown:            [188,  143,  143],
    royalblue:            [65,   105,  225],
    saddlebrown:          [139,  69,   19 ],
    salmon:               [250,  128,  114],
    sandybrown:           [244,  164,  96 ],
    seagreen:             [46,   139,  87 ],
    seashell:             [255,  245,  238],
    sienna:               [160,  82,   45 ],
    silver:               [192,  192,  192],
    skyblue:              [135,  206,  235],
    slateblue:            [106,  90,   205],
    slategray:            [112,  128,  144],
    slategrey:            [112,  128,  144],
    snow:                 [255,  250,  250],
    springgreen:          [0,    255,  127],
    steelblue:            [70,   130,  180],
    tan:                  [210,  180,  140],
    teal:                 [0,    128,  128],
    thistle:              [216,  191,  216],
    tomato:               [255,  99,   71 ],
    turquoise:            [64,   224,  208],
    violet:               [238,  130,  238],
    wheat:                [245,  222,  179],
    white:                [255,  255,  255],
    whitesmoke:           [245,  245,  245],
    yellow:               [255,  255,  0  ],
    yellowgreen:          [154,  205,  50 ]
  }

  // https://github.com/Qix-/color-convert/blob/master/conversions.js
  static ansi256ToAnsi16(code) {
    if(code < 8)  { return 30 + code; }
    if(code < 16) { return 90 + code - 8; }

    let red, green, blue;
    if(code >= 232) {
      red = (((code - 232) * 10) + 8) / 255;
      green = red; blue = red;
    } else {
      code -= 16;
      const remainder = code % 36;
      red   = Math.floor(code / 36) / 5;
      green = Math.floor(remainder / 6) / 5;
      blue  = (remainder % 6) / 5;
    }

    const value = Math.max(red, green, blue) * 2;
    if(value === 0) { return 30; }
    let result = 30 + ((Math.round(blue) << 2) | (Math.round(green) << 1) | Math.round(red));
    if(value === 2) { result += 60; }
    return result;
  }

  static rgbToAnsi16(R, G, B) {
    return ZLog.ansi256ToAnsi16(ZLog.rgbToAnsi256(R, G, B));
  }

  static rgbToAnsi256(R, G, B) {
    // We use the extended greyscale palette here, with the exception
    // of black and white. normal palette only has 4 greyscale shades.
    if(R === G && G === B) {
      if(R < 8)   { return 16; }
      if(R > 248) { return 231; }
      return Math.round(((R - 8) / 247) * 24) + 232;
    }
    return 16
      + (36 * Math.round(R / 255 * 5))
      + ( 6 * Math.round(G / 255 * 5))
      + Math.round(B / 255 * 5);
  }

  static hexToAnsi16(hex) {
    return ZLog.ansi256ToAnsi16(ZLog.hexToAnsi256(hex));
  }

  static hexToAnsi256(hex) {
    return ZLog.rgbToAnsi256(...ZLog.hexToRgb(hex));
  }

  static hexToRgb(hex) {
    //  123 => [ 1,2,3 ]    1a2b3c => [ 1a, 2b, 3c ] 返回十进制版数组
    // #123 => [ 1,2,3 ]   #1a2b3c => [ 1a, 2b, 3c ] 返回十进制版数组
    let rgb, R, G, B;
    if(/^#([a-f\d]{6})$/i.exec(hex.toString(16))) {
      [, rgb ] = /^#([a-f\d]{6})$/i.exec(hex.toString(16));
    } else if(/^#([a-f\d]{3})$/i.exec(hex.toString(16))) {
      [, rgb ] = /^#([a-f\d]{3})$/i.exec(hex.toString(16));
    } else if(/^([a-f\d]{6})$/i.exec(hex.toString(16))) {
      [ rgb ] = /^([a-f\d]{6})$/i.exec(hex.toString(16));
    } else if(/^([a-f\d]{3})$/i.exec(hex.toString(16))) {
      [ rgb ] = /^([a-f\d]{3})$/i.exec(hex.toString(16));
    }

    if(rgb.length === 3) {
      R = rgb.substring(0, 1); G = rgb.substring(1, 2); B = rgb.substring(2, 3);
    } else if(rgb.length === 6) {
      R = rgb.substring(0, 2); G = rgb.substring(2, 4); B = rgb.substring(4, 6);
    } else {
      return [0, 0, 0];
    }
    return [
      Number.parseInt('0x'+R), Number.parseInt('0x'+G), Number.parseInt('0x'+B)
    ];
  }

  // 共享原型函数
  _setDefaultValues() {
    this.mode.trace = false;

    if(ZLog.RTME.supports.nocolor) {
      return true;
    }

    this.color.key = null; // key of `this.color.use`
    this.color.use = {
      ansi256: 0, rgb: [0,0,0], css: 'black', html: '#000000'
    };

    this.ansi.fg = true;   this.ansi.normal = true;
    this.ansi.bg = false;  this.ansi.bright = false;

    for(const key of Object.keys(ZLog.ANSI.attrs)) {
      this.ansi.attrs[key] = false;
    }
  }

  _attrsCodes() {
    let attrsCodes = '';
    for(const key of Object.keys(ZLog.ANSI.attrs)) {
      if(this.ansi.attrs[key]) {
        attrsCodes += ZLog.ANSI.attrs[key][0] + ';';
      }
    }
    return attrsCodes;
  }

  attrs(args = []) {
    if(ZLog.RTME.supports.nocolor) {
      return this;
    }

    for(let attr of args) {
      if(ZLog.ANSI.attrs[attr]) {
        this.ansi.attrs[attr] = true;
      } else {
        this.ansi.attrs[attr] = false;
      }
    }
    return this;
  }

  fg(enable = true) {
    if(ZLog.RTME.supports.nocolor) {
      return this;
    }

    if(enable) {
      this.ansi.fg = true;
    } else {
      this.ansi.fg = false;
    }
    return this;
  }

  bg(enable = true) {
    if(ZLog.RTME.supports.nocolor) {
      return this;
    }

    if(enable) {
      this.ansi.bg = true;
    } else {
      this.ansi.bg = false;
    }
    return this;
  }

  normal(enable = true) {
    if(ZLog.RTME.supports.nocolor) {
      return this;
    }

    if(enable) {
      this.ansi.normal = true;
      this.ansi.bright = false;
    } else {
      this.ansi.normal = false;
      this.ansi.bright = true;
    }
    return this;
  }

  bright(enable = true) {
    if(ZLog.RTME.supports.nocolor) {
      return this;
    }

    if(enable) {
      this.ansi.normal = false;
      this.ansi.bright = true;
    } else {
      this.ansi.normal = true;
      this.ansi.bright = false;
    }
    return this;
  }

  ansi256(index) {
    if(ZLog.RTME.supports.nocolor
      || !ZLog.RTME.supports.ansi256
      || !Number.isInteger(index)) {
      this.color.key = null;
      this.color.use.ansi256 = 0;
      return this;
    }

    index = Number.parseInt(index); // 转换为十进制
    if(index >= 0 && index <= 255) {
      this.color.key = 'ansi256';
      this.color.use.ansi256 = index;
    } else {
      this.color.key = null;
      this.color.use.ansi256 = 0;
    }

    return this;
  }

  rgb(R, G, B) {
    if(ZLog.RTME.supports.nocolor
      || !ZLog.RTME.supports.truecolor
      || !Number.isInteger(R) || !Number.isInteger(G) || !Number.isInteger(B)) {
      this.color.key = null;
      this.color.use.rgb = [ 0, 0, 0 ];
      return this;
    }

    R = Number.parseInt(R); G = Number.parseInt(G); B = Number.parseInt(B);
    if((R>=0 && R<=255) && (G>=0 && G<=255) && (B>=0 && B<=255)) {
      this.color.key = 'rgb';
      this.color.use.rgb = [ R, G, B ];
    } else {
      this.color.key = null;
      this.color.use.rgb = [ 0, 0, 0 ];
    }

    return this;
  }

  // HTML & CSS
  html(hex) {
    if(ZLog.RTME.supports.nocolor) {
      this.color.key = null;
      this.color.use.html = '#000000';
      return this;
    }

    if(/^#[a-f\d]{6}$/i.test(hex) || /^#[a-f\d]{3}$/i.test(hex)) {
      this.color.key = 'html';
      this.color.use.html = hex;
      if(ZLog.RTME.supports.truecolor) {
        this.rgb(...ZLog.hexToRgb(hex));
      }
    } else {
      this.color.key = null;
      this.color.use.html = '#000000';
    }

    return this;
  }

  css(name) {
    if(ZLog.RTME.supports.nocolor) {
      this.color.key = null;
      this.color.use.css = '';
      return this;
    }

    if(ZLog.CssNamedColor[name]) {
      this.color.key = 'css';
      this.color.use.css = name;
      if(ZLog.RTME.supports.truecolor) {
        this.rgb(...ZLog.CssNamedColor[name]);
      }
    } else {
      this.color.key = null;
      this.color.use.css = '';
    }

    return this;
  }

  words(msg) {
    if(ZLog.RTME.supports.nocolor
      || typeof(msg) !== 'string' || !msg || !this.color.key
      || typeof(this.color.use[this.color.key]) === 'undefined') {
      this._setDefaultValues();
      return msg;
    }

    let colorMsg;
    if(this.color.key === 'rgb') {
      if(ZLog.RTME.supports.truecolor) {
        const rgb = this.color.use.rgb;
        if(this.ansi.bg) {
          colorMsg = ZLog.CODE.ansi16mBG(msg, ...rgb, this._attrsCodes());
        } else {
          colorMsg = ZLog.CODE.ansi16mFG(msg, ...rgb, this._attrsCodes());
        }
      } else if(ZLog.RTME.supports.ansi256) {
        const ansi256 = ZLog.rgbToAnsi256(...this.color.use.rgb);
        if(this.ansi.bg) {
          colorMsg = ZLog.CODE.ansi256BG(msg, ansi256, this._attrsCodes());
        } else {
          colorMsg = ZLog.CODE.ansi256FG(msg, ansi256, this._attrsCodes());
        }
      } else {
        const ansi16 = ZLog.rgbToAnsi16(...this.color.use.rgb);
        colorMsg = ZLog.CODE.ansiColor(msg, ansi16, this._attrsCodes());
      }
    } else if(this.color.key === 'ansi256') {
      if(ZLog.RTME.supports.ansi256) {
        const ansi256 = this.color.use.ansi256;
        if(this.ansi.bg) {
          colorMsg = ZLog.CODE.ansi256BG(msg, ansi256, this._attrsCodes());
        } else {
          colorMsg = ZLog.CODE.ansi256FG(msg, ansi256, this._attrsCodes());
        }
      } else {
        const ansi16 = ZLog.ansi256ToAnsi16(this.color.use.ansi256);
        colorMsg = ZLog.CODE.ansiColor(msg, ansi16, this._attrsCodes());
      }
    } else {
      colorMsg = msg;
    }

    this._setDefaultValues(); return colorMsg;
  }

  // 初始化构造器
  constructor() {
    if(ZLog._instance_) {
      return ZLog._instance_;
    }

    this.mode = {};
    this.ansi = {};
    this.color = {};
    this.ansi.attrs = {};
    this._setDefaultValues();

    for(const key of Object.keys(ZLog.ANSI.color.fg)) {
      this[key] = function(msg) {
        if(this.mode.trace) {
          console.trace();
        }

        if(ZLog.RTME.supports.nocolor) {
          return msg;
        }
        if(typeof(msg) !== 'string' || !msg) {
          this._setDefaultValues();
          return msg;
        }

        let colorIndex = 0, variant = 'normal', colorMsg;
        if(this.ansi.normal) { variant = 'normal'; }
        if(this.ansi.bright) { variant = 'bright'; }
        if(this.ansi.bg) {
          colorIndex = ZLog.ANSI.color.bg[key][variant][0];
        } else {
          colorIndex = ZLog.ANSI.color.fg[key][variant][0];
        }
        colorMsg = ZLog.CODE.ansiColor(msg, colorIndex, this._attrsCodes());
        this._setDefaultValues(); return colorMsg;
      }
    }

    ZLog._instance_ = this;
  }

  trace(enable = true) {
    if(enable) {
      this.mode.trace = true;
    } else {
      this.mode.trace = false;
    }
    return this;
  }
}

// attrs([]), fg(on), bg(off), normal(on), bright(off)
//
// black(''), red(''), green(''), yellow(''), blue('')
// purple(''), cyan(''), white(''), gray(''), grey('')
//
// ansi256(), ansi16m(), rgb(), css(), words()

function zlogUsageExamples() {
  function strToHex(str) {
    let hex = '';
    for(let i=0; i<str.length; i++) {
      hex += str.charCodeAt(i).toString(16);
    }
    return hex;
  }

  const zlog = new ZLog();
  let outmsg = 'ZLog 测试: ', outcnt = 0;

  // 默认 .fg() 字体色, .normal(), 无属性 .attrs([])
  for(let it of Object.keys(ZLog.ANSI.color.fg)) {
    let MSG = it.padEnd(13, ' ');
    let msg = zlog[it](MSG);
    // console.log(msg, strToHex(msg))
    outmsg += '[' + msg + '] ';
  }; console.log(outmsg);
  outmsg = 'ZLog 测试: ';
  for(let it of Object.keys(ZLog.ANSI.color.fg)) {
    // 字体色默认, 设置 .bright()
    let MSG = it.padEnd(13, ' ');
    let msg = zlog.bright()[it](MSG);
    // console.log(msg, strToHex(msg))
    outmsg += '[' + msg + '] ';
  }; console.log(outmsg);

  outmsg = 'ZLog 测试: ';
  for(let it of Object.keys(ZLog.ANSI.color.fg)) {
    // 字体色默认, 设置 .bg() 背景色
    let MSG = it.padEnd(13, ' ');
    let msg = zlog.bg()[it](MSG);
    // console.log(msg, strToHex(msg))
    outmsg += '[' + msg + '] ';
  }; console.log(outmsg);
  outmsg = 'ZLog 测试: ';
  for(let it of Object.keys(ZLog.ANSI.color.fg)) {
    // 字体色默认, 设置 .bg() 背景色
    let MSG = it.padEnd(13, ' ');
    let msg = zlog.bg().bright()[it](MSG);
    // console.log(msg, strToHex(msg))
    outmsg += '[' + msg + '] ';
  }; console.log(outmsg);

  outmsg = 'ZLog 测试: ';
  for(let it of Object.keys(ZLog.ANSI.attrs)) {
    // 绿色字体 + 各种属性
    let MSG = it.padEnd(13, ' ');
    let msg = zlog.attrs([it]).green(MSG);
    // console.log(msg, strToHex(msg))
    outmsg += '[' + msg + '] ';
  }; console.log(outmsg);

  console.log(zlog.trace().blue('显示调用栈: 启用 console.trace() 模式'))

  outmsg  = zlog.css('gold').attrs(['blink']).words('gold + blink');
  outmsg += ' & ';
  outmsg += zlog.css('olive').attrs(['underline']).words('olive + underline');
  outmsg += ' & ';
  outmsg += zlog.css('teal').attrs(['strikethrough']).words('teal + strikethrough');
  console.log(outmsg);

  outmsg  = zlog.html('#FFC0CB').attrs(['blink']).words('pink + blink');
  outmsg += ' & ';
  outmsg += zlog.rgb(255, 192, 203).attrs(['underline']).words('pink  + underline');
  outmsg += ' & ';
  outmsg += zlog.ansi256(119).attrs(['strikethrough']).words('teal + strikethrough');
  console.log(outmsg);

  outmsg = 'ZLog 测试: '; outcnt = 0;
  for(let it of Object.keys(ZLog.CssNamedColor)) {
    let MSG = it.padEnd(20, ' ');
    let msg = zlog.css(it).words(MSG);
    // console.log(msg, strToHex(msg))
    outmsg += '[' + msg + '] '; outcnt++;
    if(outcnt%7 == 0 ) outmsg += '\nZLog 测试: ';
  }; console.log(outmsg);

  return;

  console.log('实例属性')
  Object.getOwnPropertyNames(zlog).forEach(function(property) {
    console.log(property, typeof zlog[property]);
  });

  console.log('类属性')
  Object.getOwnPropertyNames(ZLog).forEach(function(property) {
    console.log(property, typeof ZLog[property], ZLog[property]);
  });
}

zlogUsageExamples();
