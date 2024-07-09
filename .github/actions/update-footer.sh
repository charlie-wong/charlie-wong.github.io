#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Created By: Charles Wong 2024-07-09T09:24:42+08:00 Asia/Shanghai
# Repository: https://github.com/xwlc/xwlc.github.io

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径

REPO_DIR="$(realpath "${THIS_DIR}/../..")" # 仓库根目录
source "${REPO_DIR}/util/common.sh"

! is-inside-git-work-tree && {
  echo "$(@R3 ERROR:) not inside git work tree"; exit 1
}

FooterJS="${REPO_DIR}/dist/assets/js/footer.js"

jsKey='xwlcRepositoryHome'; jsVal='https://github.com/xwlc/xwlc.github.io'
echo "const ${jsKey} = '${jsVal}';"  > "${FooterJS}"

jsKey='xwlcRepoUpdateTime'; jsVal="$(date +%Y-%m-%d)"
echo "const ${jsKey} = '${jsVal}';" >> "${FooterJS}"

jsKey='xwlcRepoCommitHash'; jsVal="$(git rev-parse --short HEAD)"
echo "const ${jsKey} = '${jsVal}';" >> "${FooterJS}"
