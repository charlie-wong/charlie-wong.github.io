# 3.4 Shell Parameters    3.5 Shell Expansions
# https://www.gnu.org/software/bash/manual/bash.html
#
# POSIX Shell & Utilities -> 2.6.2 Parameter Expansion
# https://pubs.opengroup.org/onlinepubs/9699919799/
#
# https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_03.html

${#VAR} # Get length in chars of expanded value of VAR


# NOTE POSIX 语法  :-  :=  :+  :?
# [省略冒号]则仅测试是否 unset
# [冒号形式]测试是否 unset 和其值是否等于 null
# ${VAR+is-set} 和 ${VAR:+is-set-not-null}
# ${!RefVar+has}            (RefVar 指向的)变量已定义, 其值可以是 null
# ${!RefVar:+has-not-null}  (RefVar 指向的)变量已定义且其值不为 null
#
# NOTE WORD can have shell parameter expansion, like $HOME, also can be omitted
#                  VAR Set(NotNull)     VAR Set(Null)       VAR Unset
${VAR:-[WORD]}     substitute VAR       substitute WORD     substitute WORD
${VAR-[WORD]}      substitute VAR       substitute Null     substitute WORD
${VAR:=[WORD]}     substitute VAR       assign     WORD     assign     WORD
${VAR=[WORD]}      substitute VAR       substitute Null     assign     WORD
${VAR:?[WORD]}     substitute VAR       WORD -> stderr      WORD -> stderr
${VAR?[WORD]}      substitute VAR       substitute Null     WORD -> stderr
${VAR:+[WORD]}     substitute WORD      substitute Null     substitute Null
${VAR+[WORD]}      substitute WORD      substitute WORD     substitute Null


${VAR@操作符}
${@@操作符} OR ${*@操作符} # 每个位置参数依次处理
# U 小写->大写(全部)  u 小写->大写(首个)  L 小写<-大写(全部)
VAR='a b'; echo "[${VAR@K}]"              # 结果 ['a b']
# E => 应用 $'' 机制
VAR='AA\tBB'; echo "[${VAR@E}]"           # 等同于 echo -e "[${VAR}]"
# P => 按照 PS1 方式解析
VAR='\u@\h'; echo "[${VAR@P}]"            # 结果 [用户名@主机名]
# a => 获取 VAR 变量属性字符串
# A => 获取 VAR 变量最后赋值语句(不包括 -g 和 -I 信息)
declare -ixgt VAR=5; echo "[${VAR@a}]"  # 结果 [itx]
declare -ixgt VAR=5; echo "[${VAR@A}]"  # 结果 [declare -itx VAR='X']
# Q => 结果引号包裹, K => 用于数组是产生 K/V 对
V1='xx zz'; V2=( a 'b c' d ); declare -A V3=( [k1]=v1 ['k2 xx']='v2 yy' [k3]=v3 )
echo "[${V1@Q}][${V2@Q}][${V3@Q}]   [${V2[@]@Q}][${V3[@]@Q}]"
echo "[${V1@K}][${V2@K}][${V3@K}]   [${V2[@]@K}][${V3[@]@K}]"
# TODO k 各种语法错误


# bash 字符串从 0 开始计数   zsh 字符串从 1 开始计数
# bash ${STR:0:1} 第1个字符  zsh ${STR[1]} 第1个字符
${STR:off}     # bash 从 off 位置到字符串结尾
${STR:off:len} # bash 从 off 位置到 len 位置之间的字符


# 生成以 prefix 开头的变量名列表
function xtry() {
  local prefixV1='V1'; prefixV2='V2'; prefixV3='V3'; IFS='_'
  echo One0; for it in  ${!prefix*} ; do echo "$it"; done # 二者等效
  echo Two0; for it in  ${!prefix@} ; do echo "$it"; done # 二者等效
  echo One1; for it in "${!prefix*}"; do echo "$it"; done # 单字符串, IFS 首字符分隔
  echo Two1; for it in "${!prefix@}"; do echo "$it"; done # 多字符串
}; xtry;


# 生成数组数字索引序列(Bash 语法)
function xtry() {
  local a=(a b) n=() v=abc
  # - 数组有元素, 生成的数字索引序列开始值 Bash=0
  # - 空数组, 即数组无任何元素, 结果为空
  # - 非数组, 结果为空若变量 unset, 否则结果 0
  # - 位于双引号内时 => @ 得到多字符串, * 得到单字符串
  echo "a0=索引?[${!a[*]}] n0=空?[${!n[*]}] v0=0?[${!v[*]}] x0=空?[${!x[*]}] "
  echo "a1=索引?[${!a[@]}] n1=空?[${!n[@]}] v0=0?[${!v[@]}] x0=空?[${!x[@]}] "
}; xtry;


# VAR 的值删除 => ${VAR#WORD}
# 每个位置参数 => ${*#WORD} 或 ${@#WORD}
# 每个数组元素 => ${ARRAY[*]#WORD} 或 ${ARRAY[@]#WORD}
function xtry() {
  local array=( one two three four open xtrack)
  echo "删除 #t    [${array[*]#t}]"    # 仅删除[开头]和 WORD 模式匹配的部分
  echo "删除 #t*   [${array[*]#t*}]"   # -> 删除最短匹配部分 #
  echo "删除 ##t   [${array[*]##t}]"   # -> 删除最长匹配部分 ##
  echo "删除 ##t*  [${array[*]##t*}]"
  echo "删除 #op   [${array[*]#op}]"
  echo "删除 #op*  [${array[*]#op*}]"  # 仅删除[结尾]和 WORD 模式匹配的部分
  echo "删除 ##op  [${array[*]##op}]"  # -> 删除最短匹配部分 %
  echo "删除 ##op* [${array[*]##op*}]" # -> 删除最长匹配部分 %%
}; xtry;


# NewVal 省略时, 则表示删除匹配的值
${VAR/WORD/NewVal}  # NewVal 替换 WORD, 仅替换首次匹配
${VAR//WORD/NewVal} # NewVal 替换 WORD, 替换所有匹配项
${VAR/#WORD/NewVal} # 仅 VAR 开头匹配 WORD 时进行替换
${VAR/%WORD/NewVal} # 仅 VAR 结尾匹配 WORD 时进行替换


# 大小写转换
# 同样适用于 * @ 位置参数和数组 ARR[@] 和 ARR[*]
# [单字符模式]省略时, 默认值为 ?, 表示匹配每个字符
VAR='aBaC'; echo "开头(小->大) ${VAR} => ${VAR^a}"  # 仅开头匹配的 小写 -> 大写
VAR='aBaC'; echo "每个(小->大) ${VAR} => ${VAR^^a}" #   每个匹配的 小写 -> 大写
VAR='AbAc'; echo "开头(大->小) ${VAR} => ${VAR,A}"  # 仅开头匹配的 大写 -> 小写
VAR='AbAc'; echo "每个(大->小) ${VAR} => ${VAR,,A}" #   每个匹配的 大写 -> 小写
