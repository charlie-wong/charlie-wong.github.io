#!/usr/bin/env node
// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-07-06T10:26:55+08:00 Asia/Shanghai
// Repository: https://github.com/xwlc/xwlc.github.io

function XX(...args) {} // 函数变长参数 args 是数组
console.log(...array);  // 数组元素展开作为函数参数
console.dir(obj, { depth: 2}); console.dir(obj, { depth: Infinity });
// 性能检测(运行时间) 通用库 https://benchmarkjs.com
console.time('耗时'); /* 测试代码 */ console.timeEnd('耗时');


document.getElementById("xId").style.backgroundColor = "red";
document.getElementById("xId").style.cssText = "color: blue; width: 1%;";
document.getElementById("xId").classList.add("active");
document.getElementById("xId").classList.remove("active");
document.getElementById("xId").setAttribute("style", "font-size: 14px;");


const obj = {
  zkey_: '11属性值11', // get/set 绑定属性操作
  get zkey()    { return this.zkey_; },                   // 触发 obj.zkey
  set zkey(val) { this.zkey_ = val; return this.zkey_; }, // 触发 obj.zkey = 1;
}; console.log(obj.zkey); obj.zkey = 'xx属性值xx'; console.log(obj.zkey);


class Person { // ES2019 私有属性
  #name;          // 私有实例属性
  static #author; // 私有静态属性
  #who()        { return '123'; }
  static #what() { return '456'; }
  constructor(name) { this.#name = name; }
  hello() {
    Person.#author = "Alice";
    console.log('私有>实例>属性 #name   : ' + this.#name);
    console.log('私有>实例>函数 #who()  : ' + this.#who());

    console.log('私有>静态>属性 #author : ' + Person.#author);
    console.log('私有>静态>函数 #what() : ' + Person.#what());
  }
}; const person = new Person("Bob"); person.hello();


class Outer {
  static #Inter() { // 内部>私有>静态>子类
    return class Inter {
      static ok() { console.log('#Inter - 类>静态>函数'); }
      ok1 = 'ok1';
      hello() { console.log('#Inter - 实例>',this.ok1,this.ok2); }
      constructor(ok2) { this.ok2 = ok2; }
    };
  }
  constructor() {
    Outer.#Inter().ok(); // 调用: 内部>静态>函数
    const Inter = (...args) => new (Outer.#Inter())(...args);
    this.inter = Inter('ok2'); this.inter.hello();
  }
}; const outer = new Outer();
