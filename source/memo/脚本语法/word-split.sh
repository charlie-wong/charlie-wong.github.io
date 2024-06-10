# ${ARR[@]} 和 ${ARR[*]} 的区别
# https://unix.stackexchange.com/questions/689596
#declare -a arr=( "this is" "an array for" "word split test" )
arr=( "this is" "an array Z for" "word split test" )
IFS=$'Z' # NOTE for 用 IFS 首字符进行字符分隔
echo "LOOP 1 => \${A[*]}";     for x in  ${arr[*]} ; do echo "item: ${x}"; done; echo
echo "LOOP 2 => \${A[@]}";     for x in  ${arr[@]} ; do echo "item: ${x}"; done; echo
echo "LOOP 3 => \"\${A[*]}\""; for x in "${arr[*]}"; do echo "item: ${x}"; done; echo
echo "LOOP 4 => \"\${A[@]}\""; for x in "${arr[@]}"; do echo "item: ${x}"; done; echo
# "${A[@]}" 结果保留数组元素信息, 每个数组元素形成一个字符串
# "${A[*]}" 结果是数组内容的单个字符串, 分隔符号是 IFS 的首个字符
IFS=$'XY'; echo "IFS=XY => \"\${A[*]}\" -> [${arr[*]}]"
IFS=$'XY'; echo "IFS=XY => \"\${A[@]}\" -> [${arr[@]}]"
echo

# NOTE 关于 IFS 分隔 Zsh 和 Bash 的确保
# https://unix.stackexchange.com/questions/26661
# Zsh 关于默认字符分隔的控制选项 SH_WORD_SPLIT
unsetopt | grep -i word # 默认配置下没有启用
# ${=VAR} 进行字符分隔  ${==VAR} 关闭字符分隔
