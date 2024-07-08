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
