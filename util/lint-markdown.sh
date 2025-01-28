#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Created By: Charles Wong 2024-06-30T15:48:33+08:00 Asia/Shanghai
# Repository: https://github.com/xwlc/mini-repo

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径
source "${THIS_DIR}/common.sh"

# https://github.com/DavidAnson/markdownlint-cli2
# 全局安装 $ npm install --global markdownlint-cli2
no-cmd npm && exit-no-cmd npm

MdLintCmd=markdownlint-cli2
npm list -g --depth 0 | grep markdownlint-cli2 > /dev/null
[[ $? -ne 0 ]] && exit-no-cmd markdownlint-cli2

if no-cmd markdownlint-cli2; then
  unset -v MdLintCmd
  for it in $(echo "${NODE_PATH}" | sed 's/:/\n/g'); do
    if [[ -x "${it}/markdownlint-cli2/markdownlint-cli2.js" ]]; then
      MdLintCmd="${it}/markdownlint-cli2/markdownlint-cli2.js"
    fi
  done
fi
[[ -z "${MdLintCmd}" ]] && exit-no-cmd markdownlint-cli2

if [[ $# -eq 0 ]]; then # 递归扫描检测仓库内所有的 *.md 文件
  for it in $(find "${THIS_DIR%/*}" -type f -name '*.md' -print); do
    [[ ! "${it}" =~ *node_modules* ]] && ${MdLintCmd} --no-globs ${it}
  done
else
  for it in $@; do
    if [[ -f "${PWD}/${it}" ]]; then
      ${MdLintCmd} --no-globs "${PWD}/${it}"
    else
      echo "$(@D9 SKIP): ${PWD}/${it}"
    fi
  done
fi
