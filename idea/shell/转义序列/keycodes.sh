# SPDX-License-Identifier: Apache-2.0+ OR GPL-3.0-or-later
# SPDX-FileCopyrightText: 2023 Charlie WONG <charlie-wong@outlook.com>
# Created By: Charlie WONG 2023-11-29T20:13:29+08:00 Asia/Shanghai
# Repository: https://github.com/charlie-wong/charlie-wong

# https://stackoverflow.com/questions/13585131
# About keyboard_transmit mode in vt100 terminal emulator

# see `man 5 terminfo` for more
# https://wiki.archlinux.org/title/Zsh
# https://github.com/vapniks/zsh-keybindings

# Make escape sequence readable and easy to use
declare -A Keys

function set-kp2es() { Keys[$1]="$2"; }
function set-kp2ti() { Keys[$1]="${terminfo[$2]}"; }

set-kp2es  Ctrl   "^"
set-kp2es  Alt    "\e"

set-kp2ti  Back  kbs # BackSpace
set-kp2ti  Enter kent

set-kp2ti  F1   kf1
set-kp2ti  F2   kf2
set-kp2ti  F3   kf3
set-kp2ti  F4   kf4
set-kp2ti  F5   kf5
set-kp2ti  F6   kf6
set-kp2ti  F7   kf7
set-kp2ti  F8   kf8
set-kp2ti  F9   kf9
set-kp2ti  F10  kf10
set-kp2ti  F11  kf11
set-kp2ti  F12  kf12

set-kp2ti  Ins   kich1 # Insert
set-kp2ti  Del   kdch1 # Delete
set-kp2ti  Home  khome
set-kp2ti  End   kend
set-kp2ti  PgUp  kpp   # PageUp
set-kp2ti  PgDn  knp   # PageDown

set-kp2ti  KeyL  kcub1 # Arrow Key Left
set-kp2ti  KeyU  kcuu1 # Arrow Key Up
set-kp2ti  KeyD  kcud1 # Arrow Key Down
set-kp2ti  KeyR  kcuf1 # Arrow Key Right

###########
# Shift + #
###########
set-kp2es  ShiftF1   "\e[1;2P"
set-kp2es  ShiftF2   "\e[1;2Q"
set-kp2es  ShiftF3   "\e[1;2R"
set-kp2es  ShiftF4   "\e[1;2S"
set-kp2es  ShiftF5   "\e[15;2~"
set-kp2es  ShiftF6   "\e[17;2~"
set-kp2es  ShiftF7   "\e[18;2~"
set-kp2es  ShiftF8   "\e[19;2~"
set-kp2es  ShiftF9   "\e[20;2~"
set-kp2es  ShiftF10  "\e[21;2~"
set-kp2es  ShiftF11  "\e[23;2~"
set-kp2es  ShiftF12  "\e[24;2~"

set-kp2ti  ShiftHome  kHOM
set-kp2ti  ShiftEnd   kEND
set-kp2ti  ShiftPgUp  kPRV
set-kp2ti  ShiftPgDn  kNXT

set-kp2ti  ShiftKeyL  kLFT
set-kp2ti  ShiftKeyR  kRIT

set-kp2ti  ShiftDel   kDC
set-kp2ti  BackTab    kcbt
set-kp2ti  ShiftTab   kcbt

##########
# Ctrl + #
##########
set-kp2es  CtrlIns   "\e[2;5~"
set-kp2es  CtrlDel   "\e[3;5~"
set-kp2es  CtrlHome  "\e[1;5H"
set-kp2es  CtrlEnd   "\e[1;5F"
set-kp2es  CtrlPgUp  "\e[5;5~"
set-kp2es  CtrlPgDn  "\e[6;5~"

set-kp2es  CtrlKeyL  "\e[1;5D"
set-kp2es  CtrlKeyU  "\e[1;5A"
set-kp2es  CtrlKeyD  "\e[1;5B"
set-kp2es  CtrlKeyR  "\e[1;5C"

set-kp2es  CtrlSpace  "^@"
set-kp2es  CtrlBack   "^H" # Ctrl + backSpace

#########
# ALt + #
#########
set-kp2es  AltF1      "\e[1;3P"
set-kp2es  AltF2      "\e[1;3Q"
set-kp2es  AltF3      "\e[1;3R"
set-kp2es  AltF4      ""
set-kp2es  AltF5      "\e[15;3~"
set-kp2es  AltF6      "\e[17;3~"
set-kp2es  AltF7      "\e[18;3~"
set-kp2es  AltF8      "\e[19;3~"
set-kp2es  AltF9      "\e[20;3~"
set-kp2es  AltF10     ""
set-kp2es  AltF11     "\e[23;3~"
set-kp2es  AltF12     "\e[24;3~"

set-kp2es  AltIns     "\e[2;3~"
set-kp2es  AltDel     "\e[3;3~"
set-kp2es  AltHome    "\e[1;3H"
set-kp2es  AltEnd     "\e[1;3F"
set-kp2es  AltPgUp    "\e[5;3~"
set-kp2es  AltPgDn    "\e[6;3~"

set-kp2es  AltKeyL    "\e[1;3D"
set-kp2es  AltKeyU    "\e[1;3A"
set-kp2es  AltKeyD    "\e[1;3B"
set-kp2es  AltKeyR    "\e[1;3C"

set-kp2es  AltSpace   "\e "
set-kp2es  AltBack    "\e^?"
set-kp2es  AltEnter   "\e^M"

##############
# Ctrl + Alt #
##############
set-kp2es  CtrlAltIns   "\e[2;7~"
set-kp2es  CtrlAltDel   "\e[3;7~"
set-kp2es  CtrlAltHome  "\e[1;7H"
set-kp2es  CtrlAltEnd   "\e[1;7F"
set-kp2es  CtrlAltPgUp  "\e[5;7~"
set-kp2es  CtrlAltPgDn  "\e[6;7~"

set-kp2es  CtrlAltKeyL  "\e[1;7D"
set-kp2es  CtrlAltKeyU  "\e[1;7A"
set-kp2es  CtrlAltKeyD  "\e[1;7B"
set-kp2es  CtrlAltKeyR  "\e[1;7C"

set-kp2es  CtrlAltBack  "\e^H"

function which-emulator() {
  local _tty_  _pid_=${PPID}  items
  _tty_=$(ps -p $$ -o tty=)
  [[ $? -ne 0 ]] && return

  while [[ ${_pid_} -ne 1 ]]; do
    items="$(ps -p ${_pid_} -o ppid= -o tty= -o comm=)"
    [[ $? -ne 0 ]] && return
    set -- ${=items}
    [[ "$2" != "${_tty_}" ]] && break
    _pid_=$1
  done

  case "$3" in
    *tmux*)
      items=$(tmux display-message -p "#{client_pid}")
      printf '%s' "$(ps -p $(ps -p $(ps -p ${items} -o sid=) -o ppid=) -o comm=)"
      ;;
    *)
      shift; shift
      printf '%s' "$*"
      ;;
  esac
}

# https://github.com/kovidgoyal/kitty
# https://sw.kovidgoyal.net/kitty/conf.html
#
# https://github.com/contour-terminal/contour
# https://contour-terminal.org

case "$(which-emulator)" in
  *xterm*) ;;
  *kitty*) ;;
  *konsole*) ;;
  *) ;;
esac

function review-keycodes() {
  local key val escode
  for key val ( "${(@kv)Keys}" ); do
    val="$(echo -n "${val}" | command od -An -w512 -ta)"
    printf '%15s -> %s\n' ${key} "${val}"
  done
}

unset -f set-{kp2es,kp2ti} which-emulator review-keycodes
