# 检测 VAR 变量是否已定义  效率 => 方式1 > 方式2 > 方式3
# https://unhexium.net/zsh/how-to-check-variables-in-zsh

# 方式1 ZSH Version >= 5.3
[[ -v VAR ]] && echo "已定义"

# 方式2
(( ${+VAR} )) && echo "已定义"
if (( ${+commands[apt]} )); then
  echo apt command is available
fi

# 方式3
typeset -p VAR >/dev/null 2>&1

# P9K 检测变量是否定义函数
function is-defined () {
  typeset -p "$1" > /dev/null 2>&1
}

function is-defined () {
  # t -> report variable type, empty for unset variables
  # P -> make $1 as variable name, which is double expansion
  [[ ! -z "${(tP)1}" ]]
  # report $1 variable type, if not empty, then $1 is defined
}

if is-defined COLOR_${RETVAL}; then
  echo is defined COLOR_${RETVAL}
fi
