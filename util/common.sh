#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Created By: Charles Wong 2024-07-07T03:23:07+08:00 Asia/Shanghai
# Repository: https://github.com/xwlc/mini-repo

function has-cmd() {  command -v "$1" > /dev/null; }
function no-cmd() { ! command -v "$1" > /dev/null; }

function @R3() { builtin printf "\e[0;31m%s\e[0m" "$*"; } # Red
function @G3() { builtin printf "\e[0;32m%s\e[0m" "$*"; } # Green
function @Y3() { builtin printf "\e[0;33m%s\e[0m" "$*"; } # Yellow
function @B3() { builtin printf "\e[0;34m%s\e[0m" "$*"; } # Blue
function @P3() { builtin printf "\e[0;35m%s\e[0m" "$*"; } # Purple
function @C3() { builtin printf "\e[0;36m%s\e[0m" "$*"; } # Cyan

function @D9() { builtin printf "\e[0;90m%s\e[0m" "$*"; } # Grey

function @R9() { builtin printf "\e[0;91m%s\e[0m" "$*"; } # Red
function @G9() { builtin printf "\e[0;92m%s\e[0m" "$*"; } # Green
function @Y9() { builtin printf "\e[0;93m%s\e[0m" "$*"; } # Yellow
function @B9() { builtin printf "\e[0;94m%s\e[0m" "$*"; } # Blue
function @P9() { builtin printf "\e[0;95m%s\e[0m" "$*"; } # Purple
function @C9() { builtin printf "\e[0;96m%s\e[0m" "$*"; } # Cyan

function exit-errmsg() {
  echo >&2 "$(@R3 ERROR): $@"; exit 1;
}
function exit-no-cmd() {
  echo >&2 "$(@R3 ERROR): not found $(@G3 $1) command."; exit 1;
}

function is-inside-git-work-tree() {
  no-cmd git && exit-no-cmd git
  git rev-parse --is-inside-work-tree &> /dev/null
}

function this-repo-https-url() {
  if ! is-inside-git-work-tree; then
    exit-errmsg "not inside git work tree."
  fi
  local item repoURL domain suburl
  for item in "$(git remote --verbose | grep fetch)"; do
    item="$(echo "${item}" | cut -f2 | cut -d' ' -f1)"
    [[ -n "${item}" ]] && {
      if [[ "${item}" =~ ^"git@github.com:".* ]]; then
        repoURL="https://github.com/${item#git@github.com:}"; break
      elif [[ "${item}" =~ ^"git@gitlab.com:".* ]]; then
        repoURL="https://gitlib.com/${item#git@gitlib.com:}"; break
      elif [[ "${item}" =~ ^"git@".* ]]; then
        item="${item#git@}" # git@域名:路径.git
        domain="$(echo "${item}" | cut -d: -f1)"
        suburl="$(echo "${item}" | cut -d: -f2)"
        [[ -n "${domain}" && -n "${suburl}" && "${domain}" != "${suburl}" ]] && {
          repoURL="https://${domain}/${suburl}"; break
        }
      else
        repoURL="${item}"; break
      fi
    }
  done
  [[ -z "${repoURL}" ]] && return 1
  echo "${repoURL%.git}"
}
