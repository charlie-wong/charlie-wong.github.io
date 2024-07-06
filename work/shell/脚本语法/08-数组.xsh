declare -a ARR=( AA BB CC DD )
echo "[${ARR}][${ARR[@]}]" #  ZSH: 二者同时显示数组内容
echo "[${ARR}][${ARR[@]}]" # Bash: 显示 [AA] 和 [AA BB CC]
# 删除数组项
# Bash -> [3][AA CC DD]
# Zsh  -> [4][ BB CC DD]
unset 'ARR[1]'; echo "[${#ARR[@]}][${ARR[@]}]"
# Zsh 删除数组空项(实际是显示时过滤删除掉空项)
# https://unix.stackexchange.com/questions/590029
unset 'ARR[1]'; echo "[${#ARR[@]:#}][${(@)ARR[@]:#}]"


${(k)ARRAY} # 显示关联数组的 key 列表
${(v)ARRAY} # 显示关联数组的 value 列表
# Zsh 预定义特殊 association 数组变量, 其值是以空格分隔的列表
# `echo ${(k)` 然后按下 Tab 键查看预定义的特殊变量列表
${(k)aliases}    ${(k)builtins}    ${(k)commands}
# -> functions, parameters, status
# -> history, histchars, historywords
# -> terminfo, usergroups
# -> signals, key, keymaps, modules, options
# -> prompt, PROMPT, PROMPT2, PROMPT3, PROMPT4, PS1, PS2, PS3, PS4


# NOTE Associative Arrays in Shell Scripts
# https://unix.stackexchange.com/questions/111397
declare -A XARR=( [k1]=v1 [k2]=v2 [k3]=v3 )
# ZSH 语法
echo "${(k)XARR}" # 显示  key  值
echo "${(v)XARR}" # 显示 value 值
for k v ("${(@kv)XARR}")     echo "${k} -> ${v}"
for k v ("${(@kv)XARR}"); do echo "${k} -> ${v}"; done
for k in ${(k)XARR}; do echo "${k} -> ${XARR[${k}]}"; done
# Bash 语法
echo "${!XARR[@]}" 或 "${!XARR[*]}" # 显示  key  值
echo  "${XARR[@]}" 或  "${XARR[*]}" # 显示 value 值
for k in "${!XARR[@]}"; do echo "${k} -> ${XARR[${k}]}"; done
