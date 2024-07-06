// SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Created By: Charles Wong 2024-05-27T14:31:25+08:00 Asia/Shanghai
// Repository: https://github.com/xwlc/zeta

class LunarCalendar {
  static Gan=[ // 干支纪标记法以 60 为循环周期
    "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"
  ];
  static Zhi=[
    "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"
  ];
  static Animals=[
    "鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"
  ];
  static JieQi = [ // 数组索引编号从 0 开始, 小寒数字编号 01
    "小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
    "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑",
    "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"
  ];

  static MIN_YEAR = 1900; static MAX_YEAR = 2100;
  static LunarLeapInfo = [ // 农历 1900 ~ 2100 的润年速查表
  0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2, // 1900-1909
  0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977, // 1910-1919
  0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970, // 1920-1929
  0x06566, 0x0d4a0, 0x0ea50, 0x16a95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950, // 1930-1939
  0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557, // 1940-1949
  0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5b0, 0x14573, 0x052b0, 0x0a9a8, 0x0e950, 0x06aa0, // 1950-1959
  0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0, // 1960-1969
  0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b6a0, 0x195a6, // 1970-1979
  0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570, // 1980-1989
  0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x05ac0, 0x0ab60, 0x096d5, 0x092e0, // 1990-1999
  0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5, // 2000-2009
  0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930, // 2010-2019
  0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530, // 2020-2029
  0x05aa0, 0x076a3, 0x096d0, 0x04afb, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45, // 2030-2039
  0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0, // 2040-2049
  0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6, 0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0, // 2050-2059
  0x092e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4, // 2060-2069
  0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0, // 2070-2079
  0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160, // 2080-2089
  0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252, // 2090-2099
  0x0d520 // 2100
  ];

  static SolarJieQi = [ // 公历 1900 ~ 2100 的二十四节气速查表
  '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bcf97c3598082c95f8c965cc920f',
  '97bd0b06bdb0722c965ce1cfcc920f', 'b027097bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
  '97bcf97c359801ec95f8c965cc920f', '97bd0b06bdb0722c965ce1cfcc920f', 'b027097bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e', '97bcf97c359801ec95f8c965cc920f', '97bd0b06bdb0722c965ce1cfcc920f',
  'b027097bd097c36b0b6fc9274c91aa', '9778397bd19801ec9210c965cc920e', '97b6b97bd19801ec95f8c965cc920f',
  '97bd09801d98082c95f8e1cfcc920f', '97bd097bd097c36b0b6fc9210c8dc2', '9778397bd197c36c9210c9274c91aa',
  '97b6b97bd19801ec95f8c965cc920e', '97bd09801d98082c95f8e1cfcc920f', '97bd097bd097c36b0b6fc9210c8dc2',
  '9778397bd097c36c9210c9274c91aa', '97b6b97bd19801ec95f8c965cc920e', '97bcf97c3598082c95f8e1cfcc920f',
  '97bd097bd097c36b0b6fc9210c8dc2', '9778397bd097c36c9210c9274c91aa', '97b6b97bd19801ec9210c965cc920e',
  '97bcf97c3598082c95f8c965cc920f', '97bd097bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e', '97bcf97c3598082c95f8c965cc920f', '97bd097bd097c35b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bcf97c359801ec95f8c965cc920f',
  '97bd097bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
  '97bcf97c359801ec95f8c965cc920f', '97bd097bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e', '97bcf97c359801ec95f8c965cc920f', '97bd097bd07f595b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9210c8dc2', '9778397bd19801ec9210c9274c920e', '97b6b97bd19801ec95f8c965cc920f',
  '97bd07f5307f595b0b0bc920fb0722', '7f0e397bd097c36b0b6fc9210c8dc2', '9778397bd097c36c9210c9274c920e',
  '97b6b97bd19801ec95f8c965cc920f', '97bd07f5307f595b0b0bc920fb0722', '7f0e397bd097c36b0b6fc9210c8dc2',
  '9778397bd097c36c9210c9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bd07f1487f595b0b0bc920fb0722',
  '7f0e397bd097c36b0b6fc9210c8dc2', '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
  '97bcf7f1487f595b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c965cc920e', '97bcf7f1487f595b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bcf7f1487f531b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
  '97bcf7f1487f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
  '97b6b97bd19801ec9210c9274c920e', '97bcf7f0e47f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722',
  '9778397bd097c36b0b6fc9210c91aa', '97b6b97bd197c36c9210c9274c920e', '97bcf7f0e47f531b0b0bb0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722', '9778397bd097c36b0b6fc9210c8dc2', '9778397bd097c36c9210c9274c920e',
  '97b6b7f0e47f531b0723b0b6fb0722', '7f0e37f5307f595b0b0bc920fb0722', '7f0e397bd097c36b0b6fc9210c8dc2',
  '9778397bd097c36b0b70c9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721', '7f0e37f1487f595b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc9210c8dc2', '9778397bd097c36b0b6fc9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f595b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
  '97b6b7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722',
  '9778397bd097c36b0b6fc9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
  '97b6b7f0e47f531b0723b0787b0721', '7f0e27f0e47f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722',
  '9778397bd097c36b0b6fc9210c91aa', '97b6b7f0e47f149b0723b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722', '9778397bd097c36b0b6fc9210c8dc2', '977837f0e37f149b0723b0787b0721',
  '7f07e7f0e47f531b0723b0b6fb0722', '7f0e37f5307f595b0b0bc920fb0722', '7f0e397bd097c35b0b6fc9210c8dc2',
  '977837f0e37f14998082b0787b0721', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e37f1487f595b0b0bb0b6fb0722',
  '7f0e397bd097c35b0b6fc9210c8dc2', '977837f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722', '977837f0e37f14998082b0787b06bd',
  '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722',
  '977837f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722', '977837f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722', '977837f0e37f14998082b0787b06bd',
  '7f07e7f0e47f149b0723b0787b0721', '7f0e27f0e47f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722',
  '977837f0e37f14998082b0723b06bd', '7f07e7f0e37f149b0723b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722',
  '7f0e397bd07f595b0b0bc920fb0722', '977837f0e37f14898082b0723b02d5', '7ec967f0e37f14998082b0787b0721',
  '7f07e7f0e47f531b0723b0b6fb0722', '7f0e37f1487f595b0b0bb0b6fb0722', '7f0e37f0e37f14898082b0723b02d5',
  '7ec967f0e37f14998082b0787b0721', '7f07e7f0e47f531b0723b0b6fb0722', '7f0e37f1487f531b0b0bb0b6fb0722',
  '7f0e37f0e37f14898082b0723b02d5', '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e37f1487f531b0b0bb0b6fb0722', '7f0e37f0e37f14898082b072297c35', '7ec967f0e37f14998082b0787b06bd',
  '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e37f0e37f14898082b072297c35',
  '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722',
  '7f0e37f0e366aa89801eb072297c35', '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f149b0723b0787b0721',
  '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e37f0e366aa89801eb072297c35', '7ec967f0e37f14998082b0723b06bd',
  '7f07e7f0e47f149b0723b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722', '7f0e37f0e366aa89801eb072297c35',
  '7ec967f0e37f14998082b0723b06bd', '7f07e7f0e37f14998083b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722',
  '7f0e37f0e366aa89801eb072297c35', '7ec967f0e37f14898082b0723b02d5', '7f07e7f0e37f14998082b0787b0721',
  '7f07e7f0e47f531b0723b0b6fb0722', '7f0e36665b66aa89801e9808297c35', '665f67f0e37f14898082b0723b02d5',
  '7ec967f0e37f14998082b0787b0721', '7f07e7f0e47f531b0723b0b6fb0722', '7f0e36665b66a449801e9808297c35',
  '665f67f0e37f14898082b0723b02d5', '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
  '7f0e36665b66a449801e9808297c35', '665f67f0e37f14898082b072297c35', '7ec967f0e37f14998082b0787b06bd',
  '7f07e7f0e47f531b0723b0b6fb0721', '7f0e26665b66a449801e9808297c35', '665f67f0e37f1489801eb072297c35',
  '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722'
  ];

  // 返回农历 Y 年的闰月, 若没有闰月则返回零
  static getLeapMonth(Y) { // 闰字编码 \u95f0
    return (LunarCalendar.LunarLeapInfo[Y - LunarCalendar.MIN_YEAR] & 0xf);
  }

  // 返回农历 Y 年闰月天数, 若该年没有闰月则返回零
  static getDaysOfLeapMonth(Y) {
    if (LunarCalendar.getLeapMonth(Y)) {
      return ((LunarCalendar.LunarLeapInfo[Y - LunarCalendar.MIN_YEAR] & 0x10000) ? 30 : 29);
    }
    return 0;
  }

  // 返回农历 Y 年的总天数
  static getDaysOfYear(Y) {
    let i, sum = 348;
    for (i = 0x8000; i > 0x8; i >>= 1) {
      sum += (LunarCalendar.LunarLeapInfo[Y - LunarCalendar.MIN_YEAR] & i) ? 1 : 0;
    }
    return (sum + LunarCalendar.getDaysOfLeapMonth(Y));
  }

  // 返回农历 Y 年 M 月(非闰月)总天数
  static getDaysOfMonth(Y, M) {
    if (M > 12 || M < 1) {
      return -1; // 月份从 01 至 12，参数错误返回 -1
    }
    return ((LunarCalendar.LunarLeapInfo[Y - LunarCalendar.MIN_YEAR] & (0x10000 >> M)) ? 30 : 29);
  }

  // 农历 Y 年转换为干支纪年
  static getGanZhiYear(Y) {
    let gan = (Y - 3) % 10;
    let zhi = (Y - 3) % 12;  // 天干/地支的索引从 0 开始
    if (gan === 0) gan = 10; // 余数为 0 则为最后一个天干
    if (zhi === 0) zhi = 12; // 余数为 0 则为最后一个地支
    return {
      gan: LunarCalendar.Gan[gan - 1],
      zhi: LunarCalendar.Zhi[zhi - 1],
      ani: LunarCalendar.Animals[zhi -1]
    };
  }

  // 获取农历 Y 年的生肖属性(非精确)
  static getAnimalOfYear(Y) {
    return LunarCalendar.getGanZhiYear(Y).ani;
  }

  // 相对<甲子>偏移量
  static toGanZhi(offset) {
    const gan = offset % 10;
    const zhi = offset % 12;
    return { gan: LunarCalendar.Gan[gan], zhi: LunarCalendar.Zhi[zhi] };
  }

  // 获取公历 Y 年的第 N个节气的公历日期
  //
  // 小寒/01  大寒/02  立春/03  雨水/04  惊蛰/05  春分/06  清明/07  谷雨/08
  // 立夏/09  小满/10  芒种/11  夏至/12  小暑/13  大暑/14  立秋/15  处暑/16
  // 白露/17  秋分/18  寒露/19  霜降/20  立冬/21  小雪/22  大雪/23  冬至/24
  static getSolarMonthDayAtJieQi(Y, N) {
    if (Y < LunarCalendar.MIN_YEAR || Y > LunarCalendar.MAX_YEAR || N < 1 || N > 24) {
      return -1;
    }

    const xcalday = []
    const xtable = LunarCalendar.SolarJieQi[Y - LunarCalendar.MIN_YEAR];

    for (let index = 0; index < xtable.length; index += 5) {
      const chunk = parseInt('0x' + xtable.substr(index, 5)).toString()
      xcalday.push(chunk[0], chunk.substr(1, 2), chunk[3], chunk.substr(4, 2))
    }
    return parseInt(xcalday[N - 1]);
  }

  // Y 是否是闰年 => 0 平年, 1 闰年
  static isSolarLeapYear(year) {
    if(year % 400 == 0 )
      return 1;
    else if(year % 100 == 0)
      return 0;
    else if(year % 4 == 0)
      return 1;
    else
      return 0;
  }

  // 返回公历 Y 年 M 月的天数 -1, 28, 29, 30, 31
  static getSolarDaysOfMonth(Y, M) {
    if (M > 12 || M < 1) {
      return -1
    }
    const ms = M - 1;
    if (ms === 1) { // 检测二月份闰平后返回 28 或 29
      return LunarCalendar.isSolarLeapYear(Y) ? 29 : 28;
    } else {
      // 公历每个月份的天数(常规)
      const SolarDaysPerMonthNormal = [
        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
      ];
      return SolarDaysPerMonthNormal[ms];
    }
  }

  // 夜半者子也  鸡鸣者丑也  平旦者寅也  日出者卯也
  // 食时者辰也  隅中者巳也  日中者午也  日佚者未也
  // 哺时者申也  日入者酉也  黄昏者戌也  人定者亥也

  // 获取 hh:mm 的干支时间(十二时辰)
  static convTimeToGanZhi(hh, mm) {
    const SCT = {
      "00": { // 23:00 -> 00:00 -> 00:59
        name: "子", nick: "夜半", geng:"三更",
        t1: { h: '23', n: "初" }, t2: { h: '00', n: "正" },
        desc: { n: "困敦", d: "混沌万物之初萌, 藏黄泉之下" }
      },
      "02": { // 01:00 -> 02:00 -> 02:59
        name: "丑", nick: "鸡鸣", geng:"四更",
        t1: { h: '01', n: "初" }, t2: { h: '02', n: "正" },
        desc: { n: "赤奋若", d: "气运奋迅而起, 万物无不若其性" }
      },
      "04": { // 03:00 -> 04:00 -> 04:59
        name: "寅", nick: "平旦", geng:"五更",
        t1: { h: '03', n: "初" }, t2: { h: '04', n: "正" },
        desc: { n: "摄提格", d: "万物承阳而起" }
      },
      "06": { // 05:00 -> 06:00 -> 06:59
        name: "卯", nick: "日出", geng:"",
        t1: { h: '05', n: "初" }, t2: { h: '06', n: "正" },
        desc: { n: "单阏", d: "阳气推万物而起" }
      },
      "08": { // 07:00 -> 08:00 -> 08:59
        name: "辰", nick: "食时", geng:"",
        t1: { h: '07', n: "初" }, t2: { h: '08', n: "正" },
        desc: { n: "执徐", d: "伏蛰之物, 而敷舒出" }
      },
      "10": { // 09:00 -> 10:00 -> 10:59
        name: "巳", nick: "隅中", geng:"",
        t1: { h: '09', n: "初" }, t2: { h: '10', n: "正" },
        desc: { n: "大荒落", d: "万物炽盛而出, 霍然落之" }
      },
      "12": { // 11:00 -> 12:00 -> 12:59
        name: "午", nick: "日中", geng:"",
        t1: { h: '11', n: "初" }, t2: { h: '12', n: "正" },
        desc: { n: "敦牂", d: "万物壮盛也" }
      },
      "14": { // 13:00 -> 14:00 -> 14:59
        name: "未", nick: "日昳", geng:"",
        t1: { h: '13', n: "初" }, t2: { h: '14', n: "正" },
        desc: { n: "协洽", d: "阴阳和合，万物化生" }
      },
      "16": { // 15:00 -> 16:00 -> 16:59
        name: "申", nick: "日晡", geng:"",
        t1: { h: '15', n: "初" }, t2: { h: '16', n: "正" },
        desc: { n: "涒滩", d: "万物吐秀, 倾垂也" }
      },
      "18": { // 17:00 -> 18:00 -> 18:59
        name: "酉", nick: "日入", geng:"",
        t1: { h: '17', n: "初" }, t2: { h: '18', n: "正" },
        desc: { n: "作噩", d: "万物皆芒枝起" }
      },
      "20": { // 19:00 -> 20:00 -> 20:59
        name: "戌", nick: "日暮", geng:"一更",
        t1: { h: '19', n: "初" }, t2: { h: '20', n: "正" },
        desc: { n: "阉茂", d: "万物皆蔽冒也" }
      },
      "22": { // 21:00 -> 22:00 -> 22:59
        name: "亥", nick: "人定", geng:"二更",
        t1: { h: '21', n: "初" }, t2: { h: '22', n: "正" },
        desc: { n: "大渊献", d: "万物于天, 深盖藏也" }
      },
    };

    const now=new Date();
    if (!hh || !mm) {
      hh = now.getHours();
      mm = now.getMinutes();
    }

    if (hh == 24) hh = 0;
    // 前一小时, 当前小时, 后一小时 => 方便查询时辰表
    let xh = { pre: "", now: hh.toString(), nxt: "" };

    if ((hh + 1) < 24 ) {
      xh.nxt = (hh + 1).toString();
    } else {
      xh.nxt = "00";
    }

    if ((hh - 1) >= 0 ) {
      xh.pre = (hh - 1).toString();
    } else {
      xh.pre = "23";
    }

    let sci = {};
    xh.pre = xh.pre.padStart(2, "0");
    xh.now = xh.now.padStart(2, "0");
    xh.nxt = xh.nxt.padStart(2, "0");

    if (SCT[xh.now]) {
      sci = SCT[xh.now];
    } else {
      if ( SCT[xh.pre].t1.h == hh.toString().padStart(2, "0")
        || SCT[xh.pre].t2.h == hh.toString().padStart(2, "0")) {
        sci = SCT[xh.pre];
      } else {
        sci = SCT[xh.nxt] ;
      }
    }

    // 十二时辰标(时刻)名
    function shiKeName(mm) {
      if      ( mm <= 15 )  return '一刻';
      else if ( mm <= 30 )  return '二刻';
      else if ( mm <= 45 )  return '三刻';
      else                  return '四刻';
    }
    sci.mins = shiKeName(mm);

    return { ok: 1, now: { h: hh, m: mm }, sci };
  }

  // 阳历 => 农历
  static convSolarToLunar(sy, sm, sd) {
    let sYY = parseInt(sy); // 公历年
    let sMM = parseInt(sm); // 公历月
    let sDD = parseInt(sd); // 公历日

    if (sYY < LunarCalendar.MIN_YEAR || sYY > LunarCalendar.MAX_YEAR) { // 公历年上限
      return { ok: 0 };
    }
    if (sYY === LunarCalendar.MIN_YEAR && sMM === 1 && sDD < 31) { // 公历年下限
      return { ok: 0 };
    }

    let xdate, istoday = false;
    if (!sYY || !sMM || !sDD) { // 空传参获得前日期
      istoday = true;
      xdate = new Date();
    } else {
      xdate = new Date(sYY, parseInt(sMM) - 1, sDD);
    }

    // 统一化<年/月/日>格式
    sYY = xdate.getFullYear();  //  YYYY
    sMM = xdate.getMonth() + 1; // 0 ~ 11
    sDD = xdate.getDate();      // 1 ~ 31

    let week = {};
    week.id = xdate.getDay(); // 星期日=0, 星期六=6
    if (week.id === 0) { week.id = 7; }
    switch(week.id) {
      case 1: week.zh = "周一"; week.abbr = "Mon."; week.en = "Monday";    break;
      case 2: week.zh = "周二"; week.abbr = "Tue."; week.en = "Tuesday";   break;
      case 3: week.zh = "周三"; week.abbr = "Wed."; week.en = "Wednesday"; break;
      case 4: week.zh = "周四"; week.abbr = "Thu."; week.en = "Thursday";  break;
      case 5: week.zh = "周五"; week.abbr = "Fri."; week.en = "Friday";    break;
      case 6: week.zh = "周六"; week.abbr = "Sat."; week.en = "Saturday";  break;
      case 7: week.zh = "周日"; week.abbr = "Sun."; week.en = "Sunday";    break;
    }

    // 从 1970/01/01-00:00:00 UTC 开始的毫秒数
    let offset = Date.UTC(sYY, sMM - 1, sDD);
    const MSEC_PER_DAY = 86400000; // 24 小时的毫秒数
    // 现在 offset 表示从 1970/01/31-00:00:00 起的天数
    offset = (offset - Date.UTC(LunarCalendar.MIN_YEAR, 0, 31)) / MSEC_PER_DAY;

    let i, xtmp = 0;
    for (i = LunarCalendar.MIN_YEAR; i <= LunarCalendar.MAX_YEAR && offset > 0; i++) {
      xtmp = LunarCalendar.getDaysOfYear(i);
      offset -= xtmp;
    }
    if (offset < 0) {
      offset += xtmp;
      i--;
    }

    const lYY = i; // 农历年

    // 闰月及验证
    let isleap = false, leapMonth = LunarCalendar.getLeapMonth(i);
    for (i = 1; i < 13 && offset > 0; i++) {
      if (leapMonth > 0 && i === (leapMonth + 1) && isleap === false) {
        --i;
        isleap = true;
        xtmp = LunarCalendar.getDaysOfLeapMonth(lYY); // 计算农历闰月天数
      } else {
        xtmp = LunarCalendar.getDaysOfMonth(lYY, i); // 计算农历普通月天数
      }

      if (isleap === true && i === (leapMonth + 1)) {
        isleap = false; // 非闰月年
      }
      offset -= xtmp;
    }

    // 闰月导致数组下标重叠取反
    if (offset === 0 && leapMonth > 0 && i === leapMonth + 1) {
      if (isleap) {
        isleap = false;
      } else {
        isleap = true;
        --i;
      }
    }
    if (offset < 0) {
      offset += xtmp;
      --i;
    }

    const lMM = i; // 农历月
    const lDD = offset + 1; // 农历日

    // 月初为节, 月中为气: 返回当月的两个节气开始日期
    const jday = LunarCalendar.getSolarMonthDayAtJieQi(sYY, (sMM * 2 - 1)); // 当月第1个节气
    const qday = LunarCalendar.getSolarMonthDayAtJieQi(sYY, (sMM * 2));     // 当月第2个节气

    let gzY, gzM, gzD; // 年月日的干支表示
    gzY = LunarCalendar.getGanZhiYear(lYY);

    // 依据节气修正干支月
    gzM = LunarCalendar.toGanZhi((sYY - LunarCalendar.MIN_YEAR) * 12 + sMM + 11);
    if (sDD >= jday) {
      gzM = LunarCalendar.toGanZhi((sYY - LunarCalendar.MIN_YEAR) * 12 + sMM + 12);
    }

    // 当月的的节气信息
    let jq = {}, jie = {}, qi = {};
    // 数组下标索引从 0 开始, 故需要节气编号再减 1
    jie.m = sMM; jie.d = jday; jie.n = LunarCalendar.JieQi[sMM * 2 - 2]; // 月初节
    qi.m = sMM;  qi.d = qday;  qi.n = LunarCalendar.JieQi[sMM * 2 - 1]; // 月中气
    jq.m = sMM; jq.d = sDD; // 当前公历的月和日
    if (jday === sDD) { jq.n = LunarCalendar.JieQi[sMM * 2 - 2]; }
    if (qday === sDD) { jq.n = LunarCalendar.JieQi[sMM * 2 - 1]; }

    // 日柱: 当月首日与 1900/1/1 相差天数
    offset = Date.UTC(sYY, sMM - 1, 1, 0, 0, 0, 0) / MSEC_PER_DAY + 25567 + 10;
    gzD = LunarCalendar.toGanZhi(offset + sDD - 1);

    return {
      is: { ok: 1, today: istoday, leapYear: isleap }, week,
      solar: { y: sYY, m: sMM, d: sDD }, // 阳历
      lunar: { y: lYY, m: lMM, d: lDD }, // 农历
      gz: { y: gzY, m: gzM, d: gzD }, // 干支
      jq: { j: jie, q: qi, now: jq }, // 节气
      iso8601: {
        solar: sYY + '-' + sMM + '-' + sDD,
        lunar: lYY + '-' + lMM + '-' + lDD
      }
    };
  }

  static lunarNow() {
    function isInteger(string) {
      let integer = parseInt(string);
      if (isNaN(integer)) {
        return false;
      }
      return true;
    }

    function intPadZero(strFixedLen, num) {
      return num.toString().padStart(strFixedLen, "0");
    }

    if(false) {
      const now = new Date(); // 公历
      const YY=now.getFullYear(), MM=now.getMonth() + 1, DD=now.getDate();
      const hh=now.getHours(),    mm=now.getMinutes(),   ss=now.getSeconds();
    }

    let hour;
    const gz = LunarCalendar.convTimeToGanZhi();
    const lc = LunarCalendar.convSolarToLunar();
    if (gz.now.h.toString().padStart(2, "0") == gz.sci.t1.h) {
      hour = gz.sci.t1.n;
    } else {
      hour = gz.sci.t2.n;
    }

    return {
      time: {
        now: gz.now,
        hisart: { name: gz.sci.desc.n, desc: gz.sci.desc.d },
        ganzhi: {
          name: gz.sci.name, nick: gz.sci.nick,
          hour: hour, geng: gz.sci.geng, mins: gz.sci.mins,
        },
      },
      week: { zh: lc.week.zh, abbr: lc.week.abbr, en: lc.week.en },
      year: {
        now: { solar: lc.solar, lunar: lc.lunar },
        gz: lc.gz, jq: { j: lc.jq.j, q: lc.jq.q }
      }
    };
  }
}

console.dir(LunarCalendar.lunarNow(), { depth: Infinity })
