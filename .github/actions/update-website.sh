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

REPO_URL="$(this-repo-https-url)"
if [[ $? -ne 0 || -z "${REPO_URL}" ]]; then
  exit-errmsg "repo upstream URL is none."
fi

websiteJS="${REPO_DIR}/docs/assets/js/website.js"
function updateRepoInfo() { sed -e "s@$1@$2@" --in-place "${websiteJS}"; }

updateRepoInfo "xSrcHomeURL" "${REPO_URL}"
updateRepoInfo "xCommitTime" "$(date +%Y-%m-%d)"
updateRepoInfo "xCommitHash" "$(git rev-parse --short HEAD)"
