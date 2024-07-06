#!/usr/bin/env node
// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-06T07:30:02+08:00 Asia/Shanghai
// Repository: git@gitlab.com:xwlc/zeta

// 预览 https://zv.github.io/static/algorithmic-tree.html
// 仓库 https://github.com/zv/tree/commit/71754da13383977838875036f63d4bc1b7d4d6e6

class ZATree {
  // 返回介于 [min, max] 之间的整数
  static #randomInteger(min, max) {
    // ceil 向上进位取整 floor 向下舍弃取整
    min = Math.ceil(min); max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  static #quarterPI = Math.PI / 2; // 转动角度 1/4 π
  static #normalDistribution() { // 标准正态分布(常态分布)
    const u = 1 - Math.random(), v = 1 - Math.random();
    return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
  }

  // 内部>私有>静态>子类
  static #Branch() {
    return class Branch {
      constructor(x, y, r, a) {
        this.x = x; this.y = y; this.r = r; this.a = a;
      }

      step(pixel, rootR, delta) {
        this.r -= delta.diminish;
        this.x += Math.cos(this.a) * delta.stepSize;
        this.y += Math.sin(this.a) * delta.stepSize;
        this.a += ZATree.#normalDistribution() * delta.angleMax * (
          Math.pow(1 + (pixel + rootR - this.r) / rootR, delta.angleExp)
        );
      }

      draw(ctx, grain, square) {
        const mLeft = [
          Math.cos(this.a + ZATree.#quarterPI),
          Math.sin(this.a + ZATree.#quarterPI)
        ];
        const mRight = [
          Math.cos(this.a - ZATree.#quarterPI),
          Math.sin(this.a - ZATree.#quarterPI)
        ];
        const scaler = (num) => num * this.r * square;
        const coordL = mLeft.map(scaler), coordR = mRight.map(scaler);

        // draw the single pixel at (X, Y) with color of `fillStyle`
        // fillRect(X, Y, W, H) => 从 (X, Y) 开始绘制 W,H 像素的矩形
        const fillPixel = (x, y) => ctx.fillRect(x, y, 1, 1);

        // 处理树干阴影纹理
        const shadeTrunk = (x, y, len) => {
          const dd = Math.hypot(x, y);
          for(let i = 0; i <= len; i++) {
            const ts = scaler(dd * Math.random() * Math.random() - 1);
            fillPixel(x * ts, y * ts);
          }
        }

        // https://www.w3school.com.cn/jsref/api_canvas.asp
        ctx.save(); // 保存当前状态
        // translate(x, y) 表示将画布的 (0, 0) 位置设置为 (x, y)
        ctx.translate(this.x * square, this.y * square);

        // fill interior of trunk with the color of `strokeStyle`
        ctx.beginPath(); // 开始新路径绘制并确定起始点 coordL
        // 定义起点 moveTo(x, y) 定义终点 lineTo(x, y) 填充颜色 stroke()
        ctx.moveTo(...coordL); ctx.lineTo(...coordR); ctx.stroke();
        ctx.closePath(); // 绘制从当前点 coordR 到起始点 coordL 的路径

        const shadow = {
          L: grain.dots * grain.density[0], // <左>侧阴影密度(百分比)
          R: grain.dots * grain.density[1], // <右>侧阴影密度(百分比)
        };
        // 绘制树枝<左>侧部分
        fillPixel(...coordL); shadeTrunk(...mLeft,  shadow.L);
        // 绘制树枝<右>侧部分
        fillPixel(...coordR); shadeTrunk(...mRight, shadow.R);

        ctx.restore(); // 恢复之前状态
      }
    };
  }
  static #Tree() {
    return class Tree {
      constructor(x, y, branch, grain, ctrl, square) {
        this.x = x; this.y = y; this.r = ctrl.init; this.branch = branch;
        this.square = square; this.pixel = 1 / square;
        this.grain = grain; this.dice = ctrl.dice;
        this.Q = [new (ZATree.#Branch())(x, y, ctrl.init, -ZATree.#quarterPI)];
      }

      step() {
        for (let i = this.Q.length - 1; i >= 0; --i) {
          const branch = this.Q[i];
          branch.step(this.pixel, this.r, this.branch.delta);
          if (branch.r <= this.pixel) { // get rid of it if it's too small
            // splice(idx, cnt) 删除数组从 idx (包含)开始的后续 cnt 个元素
            this.Q.splice(i, 1); continue;
          }
          // Now, roll the dice and create a new branch if we're lucky
          if (Math.random() < (this.r - branch.r + this.dice)) {
            this.Q.push(new (ZATree.#Branch())(
              branch.x, branch.y, branch.r * this.branch.dense,
              branch.a + this.branch.angle * ((Math.random() * 2) - 1)
            ));
          }
        }
      }

      draw(ctx) {
        for(const branch of this.Q) {
          branch.draw(ctx, this.grain, this.square);
        }
      }
    };
  }

  // 默认配置, 网页 canvas 容器
  static #getDefaultConfig(canvas, magic) {
    if(typeof(magic) != 'number') { magic = 32; }
    const pixel = 1 / canvas.width;
    const dice = ZATree.#randomInteger(10, 50);
    const dots = ZATree.#randomInteger(10, 50) / 1000;

    return {
      lineWidth: 2, lineColor: 'black', fillColor: 'white',
      // 方形画布, 左上角 (0, 0) 起始点, 树根的起始位置
      // 0.5 表示 x 轴中心(50%), 1.0 表示 y 轴最大值(100%)
      square: canvas.width, root: { x: 0.5, y: 1.0 },
      branch: {
        dense: 0.725, // 树枝稠密度(百分比): 越小越稀疏
        angle: Math.PI / 4,
        delta: {
          stepSize: pixel,
          diminish: pixel / magic,
          angleExp: 2,
          angleMax: (4 * Math.PI) / canvas.width,
        }
      },
      grain: { // 树干部分(内部填充像素点)阴影纹理质感(左右暗影密度)
        dots: Math.ceil(canvas.width * dots), density: [ 0.18, 0.55 ]
      },
      ctrl: {
        init: 1 / magic, dice: pixel * pixel * magic * dice,
      }
    };
  }

  // 随机动态生成算法树
  static draw(canvas, config = {}) {
    // NOTE HTML <canvas> 画布坐标系: 水平 X 垂直 Y 左上角 (0, 0)

    if (!canvas || !canvas.getContext) {
      throw new Error('Could not get HTML <canvas> context');
    }

    // NOTE 后面展开添加的 config 内容覆盖(字段相同的)默认参数值
    config = { ...ZATree.#getDefaultConfig(canvas, config.magic), ...config };

    // https://drafts.csswg.org/css-color/#named-colors
    const CssNamedColors = [ // 预定义的 CSS 命名颜色名称
      "aliceblue",        "antiquewhite",     "aqua",
      "aquamarine",       "azure",            "beige",
      "bisque",           "black",            "blanchedalmond",
      "blue",             "blueviolet",       "brown",
      "burlywood",        "cadetblue",        "chartreuse",
      "chocolate",        "coral",            "cornflowerblue",
      "cornsilk",         "crimson",          "cyan",
      "darkblue",         "darkcyan",         "darkgoldenrod",
      "darkgray",         "darkgreen",        "darkgrey",
      "darkkhaki",        "darkmagenta",      "darkolivegreen",
      "darkorange",       "darkorchid",       "darkred",
      "darksalmon",       "darkseagreen",     "darkslateblue",
      "darkslategray",    "darkslategrey",    "darkturquoise",
      "darkviolet",       "deeppink",         "deepskyblue",
      "dimgray",          "dimgrey",          "dodgerblue",
      "firebrick",        "floralwhite",      "forestgreen",
      "fuchsia",          "gainsboro",        "ghostwhite",
      "gold",             "goldenrod",        "gray",
      "green",            "greenyellow",      "grey",
      "honeydew",         "hotpink",          "indianred",
      "indigo",           "ivory",            "khaki",
      "lavender",         "lavenderblush",    "lawngreen",
      "lemonchiffon",     "lightblue",        "lightcoral",
      "lightcyan",        "lightgray",        "lightgreen",
      "lightgrey",        "lightpink",        "lightsalmon",
      "lightseagreen",    "lightskyblue",     "lightslategray",
      "lightslategrey",   "lightsteelblue",   "lightyellow",
      "lime",             "limegreen",        "linen",
      "magenta",          "maroon",           "mediumaquamarine",
      "mediumblue",       "mediumorchid",     "mediumpurple",
      "mediumseagreen",   "mediumslateblue",  "mediumspringgreen",
      "mediumturquoise",  "mediumvioletred",  "midnightblue",
      "mintcream",        "mistyrose",        "moccasin",
      "navajowhite",      "navy",             "oldlace",
      "olive",            "olivedrab",        "orange",
      "orangered",        "orchid",           "palegoldenrod",
      "palegreen",        "paleturquoise",    "palevioletred",
      "papayawhip",       "peachpuff",        "peru",
      "pink",             "plum",             "powderblue",
      "purple",           "rebeccapurple",    "red",
      "rosybrown",        "royalblue",        "saddlebrown",
      "salmon",           "sandybrown",       "seagreen",
      "seashell",         "sienna",           "silver",
      "skyblue",          "slateblue",        "slategray",
      "slategrey",        "snow",             "springgreen",
      "steelblue",        "tan",              "teal",
      "thistle",          "tomato",           "turquoise",
      "violet",           "wheat",            "white",
      "whitesmoke",       "yellow",           "yellowgreen",
    ];

    const ctx = canvas.getContext('2d');

    // 填充色, 线宽度, 画笔/渐变色
    ctx.lineWidth = config.lineWidth;
    if(config.randomColor) {
      const idx1 = ZATree.#randomInteger(0, CssNamedColors.length - 1);
      const idx2 = ZATree.#randomInteger(0, CssNamedColors.length - 1);
      ctx.fillStyle   = CssNamedColors[idx1];
      ctx.strokeStyle = CssNamedColors[idx2];
    } else {
      ctx.fillStyle   = config.lineColor;
      ctx.strokeStyle = config.fillColor;
    }

    const tree = new (ZATree.#Tree())(config.root.x, config.root.y,
      config.branch, config.grain, config.ctrl, config.square
    );

    function growUp() {
      if (tree.Q.length > 0) {
        tree.step(); tree.draw(ctx);
        window.requestAnimationFrame(growUp);
      }
    }

    growUp();
  }
};
