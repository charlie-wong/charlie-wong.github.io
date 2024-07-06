#!/usr/bin/env node
// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-06T07:30:02+08:00 Asia/Shanghai
// Repository: git@gitlab.com:xwlc/zeta

// 预览 https://zv.github.io/static/algorithmic-tree.html
// 仓库 https://github.com/zv/tree/commit/71754da13383977838875036f63d4bc1b7d4d6e6
class ZATree {
  // 转动角度 1/4 π
  static quarterPI = Math.PI / 2;
  // 正态分布(常态分布)
  static normalDistribution() {
    const u = 1 - Math.random(), v = 1 - Math.random();
    return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
  }
  // 生成默认配置, 网页 canvas 容器
  static defaultConfig(canvas) {
    return {
      initBranch: 1 / 32,
      branchAngleExp: 2,
      branchSplitDiminish: 0.725,
      branchSplitAngle: Math.PI / 4,
      mid: 0.5,
      lineWidth: 2,
      fillStyle: 'black',
      strokeStyle: 'white',
      get size()            { return canvas.width; },
      get one()             { return 1 / this.size; },
      get grains()          { return Math.ceil(this.size / 64); },

      get branchDiminish()  { return this.one / 32; },
      get branchAngleMax()  { return (4 * Math.PI) / this.size; },
      get branchProb()      { return this.one * (this.one / this.initBranch) * 16; }
    };
  }
  // 内部>私有>静态>子类
  static #Branch() {
    return class Branch {
      constructor(x, y, r, a, g, scale, branchAngleMax, branchDiminish, branchAngleExp, branchSplitDiminish, branchSplitAngle, grains) {
        this.x = x
        this.y = y
        this.r = r
        this.a = a
        this.g = g
        this.scale = scale
        this.branchAngleMax = branchAngleMax
        this.branchDiminish = branchDiminish
        this.branchAngleExp = branchAngleExp
        this.branchSplitDiminish = branchSplitDiminish
        this.branchSplitAngle = branchSplitAngle
        this.grains = grains
      }

      step(vw, rootR, stepSize) {
        this.r -= this.branchDiminish
        this.x += Math.cos(this.a) * stepSize
        this.y += Math.sin(this.a) * stepSize
        const da = Math.pow(1 + (vw + rootR - this.r) / rootR, this.branchAngleExp)
        this.a += da * ZATree.normalDistribution() * this.branchAngleMax
      }

      draw(ctx) {
        const { a, r, scale, grains } = this
        const left = [Math.cos(a + ZATree.quarterPI), Math.sin(a + ZATree.quarterPI)]
        const right = [Math.cos(a - ZATree.quarterPI), Math.sin(a - ZATree.quarterPI)]
        const scaleAbsolute = q => q * r * scale
        const absoluteLeft = left.map(scaleAbsolute)
        const absoluteRight = right.map(scaleAbsolute)

        // set a single pixel at (X, Y) the color of `fillStyle'
        const fillPixel = (x, y) => ctx.fillRect(x, y, 1, 1)

        const shadeTrunk = (x, y, len) => {
          const dd = Math.hypot(x, y)
          for (let i = 0; i <= len; i++) {
            const ts = scaleAbsolute(dd * Math.random() * Math.random() - 1)
            fillPixel(x * ts, y * ts)
          }
        }

        ctx.save()
        ctx.translate(this.x * scale, this.y * scale)

        // fill interior of trunk with the color of `strokeStyle'
        ctx.beginPath()
        ctx.moveTo(...absoluteLeft)
        ctx.lineTo(...absoluteRight)
        ctx.stroke()
        ctx.closePath()

        // draw right side of the branch
        fillPixel(...absoluteRight)
        shadeTrunk(...right, grains)

        // draw left side of the branch
        fillPixel(...absoluteLeft)
        shadeTrunk(...left, grains / 5)

        ctx.restore()
      }
    };
  }
  static #Tree() {
    return class Tree {
      constructor(x, y, r, a, stepSize, one, n, grains, branchSplitAngle, branchProb, branchDiminish, branchSplitDiminish, branchAngleMax, branchAngleExp) {
        this.x = x
        this.y = y
        this.r = r
        this.a = a
        this.one = one
        this.stepSize = stepSize
        this.branchProb = branchProb

        // list of branchs
        this.Q = [new (ZATree.#Branch())(
          x, y, r, a, 0, n, branchAngleMax, branchDiminish, branchAngleExp, branchSplitDiminish, branchSplitAngle, grains
        )];
      }

      step() {
        for (let i = this.Q.length - 1; i >= 0; --i) {
          const branch = this.Q[i]

          // Grow our branch
          branch.step(this.one, this.r, this.stepSize)

          // And get rid of it if it is too small
          if (branch.r <= this.one) {
            this.Q.splice(i, 1)
            continue
          }

          // Now, roll the dice and create a new branch if we're lucky
          if (Math.random() < (this.r - branch.r + this.branchProb)) {
            const ra = (Math.random() * 2) - 1

            this.Q.push(new (ZATree.#Branch())(
              branch.x,
              branch.y,
              branch.r * branch.branchSplitDiminish,
              branch.a + ra * branch.branchSplitAngle,
              branch.g + 1,
              branch.scale,
              branch.branchAngleMax,
              branch.branchDiminish,
              branch.branchAngleExp,
              branch.branchSplitDiminish,
              branch.branchSplitAngle,
              branch.grains
            ))
          }
        }
      }

      draw(ctx) {
        for(const branch of this.Q) {
          branch.draw(ctx)
        }
      }
    };
  }
  // 随机动态生成算法树
  static draw(canvas, config = {}) {
    if (!canvas || !canvas.getContext) {
      throw new Error('Could not get HTML <canvas> context');
    }

    config = { ...ZATree.defaultConfig(canvas), ...config };

    const ctx = canvas.getContext('2d');

    ctx.fillStyle = config.fillStyle;
    ctx.lineWidth = config.lineWidth;
    ctx.strokeStyle = config.strokeStyle;

    const tree = new (ZATree.#Tree())(
      config.mid,
      1.0,
      config.initBranch,
      -ZATree.quarterPI,
      config.one,
      config.one,
      config.size,
      config.grains,
      config.branchSplitAngle,
      config.branchProb,
      config.branchDiminish,
      config.branchSplitDiminish,
      config.branchAngleMax,
      config.branchAngleExp
    )

    const drawStep = () => {
      if (tree.Q.length > 0) {
        tree.step()
        tree.draw(ctx)
        window.requestAnimationFrame(drawStep)
      }
    }

    drawStep()
  }
};
