# NUL \0    HT \t    FF  \f    \nnn   八进制
# BEL \a    VT \v    CR  \r    \xHH 十六进制
# BS  \b    LF \n    DEL \d

# https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap07.html
#    upper    alpha    xdigit   blank    cntrl    graph    ascii
#    lower    alnum    digit    space    punct    print    word
# => POSIX 标准
#    alpha -> upper + lower  digit  => 0 1 2 3 4 5 6 7 8 9    upper => 大写字母
#    alnum -> alpha + digit  xdigit => 阿拉伯数字/大小写字母  lower => 小写字母
# => 非 POSIX 标准
#    ascii => ASCII 字符
#    word  => 字母/数字/下划线

# ------------------------------------------------------------------------------
cut; tr; # cut 字符串分隔, tr 字符串替换/删除
wc -l 文件名; sed -n '$=' 文件名; grep -c '^' 文件名 # 计数文件行数
# cmd -> tee -> stdout
#         |
#        文件
tee --help; mktemp --help
# ------------------------------------------------------------------------------
# 创建子 shell 并在其中执行命令
# => 创建临时目录 /tmp/tmp.XXX，目录切换
# => 下载系统可升级的软件包到 /tmp/tmp.XXX 目录
# => 解析并显示每个 deb 软件包中的 changelog 或 news 文件
(cd $(mktemp -d) && apt download $(apt list --upgradable | cut -f1 -d"/") && apt-listchanges *.deb)
# ------------------------------------------------------------------------------
function imsg() {}  # 常规信息
function wmsg() {}  # 警告信息
function emsg() {}  # 错误信息
date +'%Y-%m-%dT%H:%M:%S%z' # ISO 8061 时间格式
# ------------------------------------------------------------------------------
# 找到软链接指向的文件
function find-hardlink() {
  local hard="$1"
  while [[ -h ${hard} ]]; do # 非软链接，则退出
    local _lnk_=$(ls -ld ${hard} | awk '{print $NF}')
    local _src_=$(ls -ld ${hard} | awk '{print $(NF-2)}')
    [[ ${_lnk_} =~ ^/ ]] && hard=${_lnk_} || hard=$(dirname ${_src_})/${_lnk_}
  done
  echo ${hard}
}
# ------------------------------------------------------------------------------
# 0   stdin     标准输入    /dev/stdin
# 1   stdout    标准输出    /dev/stdout
# 2   stderr    标准错误    /dev/stderr
# => https://zsh.sourceforge.io/Doc/Release/Redirection.html
# => https://www.gnu.org/software/bash/manual/html_node/Redirections.html

>  file  # 覆盖式重定向到文件 file, file 不存在则创建, 默认 stdout
1> file  # 覆盖式重定向到文件 file, file 不存在则创建, 明确 stdout
>> file  # 追加式重定向到文件 file, file 不存在则创建, 默认 stdout
1>> file # 追加式重定向到文件 file, file 不存在则创建, 明确 stdout

2> file  # 覆盖式重定向到文件 file, file 不存在则创建, 明确 stderr
2>> file # 追加式重定向到文件 file, file 不存在则创建, 明确 stderr

# 将 cmd 命令的 stdout 和 stderr 同时重定向到 cmd.log
cmd  > cmd.log 2>&1 # all shell works well
cmd 1> cmd.log 2>&1 # all shell works well
cmd >&   cmd.log # bash/zsh works well
cmd &>   cmd.log # bash/zsh works well, preferred
cmd 1>&2 cmd.log # bash/zsh works well
cmd cmd.log  >&2 # bash/zsh works well
cmd cmd.log 1>&2 # bash/zsh works well

# 将 cmd 命令的 stdout 和 stderr 同时追加重定向到 cmd.log
cmd &>> cmd.log     # only way works for bash
cmd >>& cmd.log     # also works for zsh
cmd >> cmd.log 2>&1

# Bash 4.0 中引入特性 https://tiswww.case.edu/php/chet/bash/NEWS
cmd1 2>&1 | cmd2 # |& 等价于 2>&1 |
# https://www.gnu.org/software/bash/manual/bash.html#Pipelines
cmd1 | cmd2      # 将 cmd1 的 stdout          重定向到 cmd2 的 stdin
cmd1 |& cmd2     # 将 cmd1 的 stdout & stderr 重定向到 cmd2 的 stdin

# STDOUT 输出到 stdout, STDERR 输出到 stderr, grep 仅看到 STDOUT 并屏蔽, 结果仅显示 stderr 内容
{ echo "STDOUT"; echo "STDERR" 1>&2; } | grep -v STD      # 结果 STDERR
# STDOUT 输出到 stdout, STDERR 输出到 stderr, grep 全部屏蔽, 结果显示为空
{ echo "STDOUT"; echo "STDERR" 1>&2; } 2>&1 | grep -v STD # 结果为空

# 将 cmd 命令的 stdin 重定向为 file 文件
cmd < file
# ------------------------------------------------------------------------------
# NOTE Bash 数组数字索引从 0 开始, ZSH 数组数字索引从 1 开始
# shell 仅支持一维数组，不支持多维数组
# 定义 数组名=(元素1 元素2 元素1 ... 元素N)
# 定义 数组名=([下标1]=值1 [下标2]=值2 ... [下标N]=值N)
# 赋值 数组名[下标]=值
# 引用 ${数组名[下标]}
a=(1 2 3 4 5 6)
b=("hello" "shell")
for ((i=0; i<10; i++)); do
  echo "a[$i]=${a[$i]}"
done
URLS=()               # 定义空数组
echo ${a[*]}          # 显示数组全部内容
echo ${a[@]}          # 显示数组全部内容
echo "${#a[*]}"       # 显示数组长度, 元素个数
c=(${a[*]} ${b[*]})   # 合并数组
unset a[5]            # 删除数组指定下标元素
unset a               # 删除整个数组
# ------------------------------------------------------------------------------
echo "脚本当前行号: $LINENO" # 起始值 1
# FUNCNAME 数组变量，调用链上的函数名列表(堆栈形式)
# FUNCNAME[0] 表示当前正在执行的 shell 函数
# FUNCNAME[1] 表示调用当前正在执行的函数的函数
# funcstack 是 ZSH 的函数调用栈, FUNCNAME 是 Bash 的函数调用栈
# NOTE 对于 zsh, $0 在函数内表示当前函数名
function funA() {
  echo "当前函数名 $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"; funB
}
function funB() {
  echo "当前函数名 $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"; funC
}
function funC() {
  echo "当前函数名 $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"
}
echo "函数外, \$FUNCNAME => (${FUNCNAME[@]})"; funA
# ------------------------------------------------------------------------------
# 脚本文件的绝对路径(软链接指向的实际位置)
THIS_FN="${0##*/}"
THIS_DIR="$(realpath ${0%/*})"
THIS_DIR="$(dirname "$(readlink -f "$0")")"
# 当前行号 LINENO, Bash/ZSH 均可用
echo "[LN=$LINENO] => 位置=[$THIS_DIR], 名称=[$THIS_FN]"
# ------------------------------------------------------------------------------
THIS_DIR="$(realpath ${0%/*})"
if [ "$THIS_DIR" != "$PWD" ]; then
  echo 1>&2 "ERROR: 当前工作目录 $THIS_DIR 和 $0 文件非同路径"; exit 1;
fi
# ------------------------------------------------------------------------------
printf "%.0f\n" 3.333  等同于  printf "%.*f\n" 0 3.333  显示  3
printf "%.1f\n" 3.333  等同于  printf "%.*f\n" 1 3.333  显示  3.3
printf "%.1f\n" 3.555  等同于  printf "%.*f\n" 1 3.555  显示  3.6
# ------------------------------------------------------------------------------
 RED='\e[31m'; GREEN='\e[32m'; YELLOW='\e[33m';
BLUE='\e[34m'; PURPLE='\e[35m';  CYAN='\e[36m'; RESET='\e[0m';
# BLACK RED GREEN YELLOW BLUE PURPLE CYAN WHITE RESET
# ------------------------------------------------------------------------------
function  S() { echo -n ", "; }
function  N() { [[ -n "$*" ]] && echo -n "$*"; true; }
# 字体颜色
function  R() { [[ -n "$*" ]] && echo -ne "\e[31m$*\e[0m"; true; }
function  G() { [[ -n "$*" ]] && echo -ne "\e[32m$*\e[0m"; true; }
function  Y() { [[ -n "$*" ]] && echo -ne "\e[33m$*\e[0m"; true; }
function  B() { [[ -n "$*" ]] && echo -ne "\e[34m$*\e[0m"; true; }
function  P() { [[ -n "$*" ]] && echo -ne "\e[35m$*\e[0m"; true; }
function  C() { [[ -n "$*" ]] && echo -ne "\e[36m$*\e[0m"; true; }
# 背景颜色
function XR() { [[ -n "$*" ]] && echo -ne "\e[41m$*\e[0m"; true; }
function XG() { [[ -n "$*" ]] && echo -ne "\e[42m$*\e[0m"; true; }
function XY() { [[ -n "$*" ]] && echo -ne "\e[43m$*\e[0m"; true; }
function XB() { [[ -n "$*" ]] && echo -ne "\e[44m$*\e[0m"; true; }
function XP() { [[ -n "$*" ]] && echo -ne "\e[45m$*\e[0m"; true; }
function XC() { [[ -n "$*" ]] && echo -ne "\e[46m$*\e[0m"; true; }
# ------------------------------------------------------------------------------
# Bash/ZSH 均能正常工作
a=89; # 判断字符串是否是数字的 7 + 1 中方式
if grep '^[[:digit:]]*$' <<< "$a" > /dev/null; then  echo "[1]: $a is number"; fi
if [ "$a" -gt 0 ] 2> /dev/null; then                 echo "[2]: $a is number"; fi
case "$a" in
  [0-9][0-9])                                        echo "[3]: $a is number" ;;
       *) ;;
esac
                                                  echo -n "[4]: $a is "
echo $a| awk '{ print($0~/^[-]?([0-9])+[.]?([0-9])+$/) ? "number" : "string" }'
if [ -n "$(echo $a | sed -n "/^[0-9]\+$/p")" ]; then echo "[5]: $a is number"; fi
expr $a "+" 10 &> /dev/null
if [ $? -eq 0 ]; then                                echo "[6]: $a is number"; fi
#
# 仅 zsh 能用, 写法含义是个未解之谜
# if [[ "$a" = <-> ]]; then                          echo "[7]: $a is number"; fi
#
# 仅 Bash 能用, zsh 执行会卡住, 原因未知
# echo "$a" | [ -n "`sed -n '/^[0-9][0-9]$/p'`" ] && echo "[8]: $a is number"
# ------------------------------------------------------------------------------
if [[ -n "${BASH_SOURCE}" && "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo 1>&2 "禁止 source 脚本 $0" # 被其它脚本 source
fi

if [[ -n "${BASH_SOURCE}" && "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "脚本只能被 source 加载, 禁止直接执行"
  echo "source ${BASH_SOURCE[0]}"
fi

# BASH_SOURCE 数组, 保存 source 的调用层次(堆栈形式)
cat > /tmp/try-C.sh <<EOF
#!/usr/bin/env bash
source /tmp/try-B.sh
echo "C.sh: \\\$0 = \${0}, BASH_SOURCE = \${BASH_SOURCE[@]}"
/tmp/try-A.sh
EOF
cat > /tmp/try-B.sh <<EOF
#!/usr/bin/env bash
source /tmp/try-A.sh
echo "B.sh: \\\$0 = \${0}, BASH_SOURCE = \${BASH_SOURCE[@]}"
EOF
cat > /tmp/try-A.sh <<EOF
#!/usr/bin/env bash
echo "A.sh: \\\$0 = \${0}, BASH_SOURCE = \${BASH_SOURCE[@]}"
EOF
chmod u+x /tmp/try-*
/tmp/try-C.sh
rm -f /tmp/try-*
# 结果
# A.sh: $0 = /tmp/try-C.sh, BASH_SOURCE = /tmp/try-A.sh /tmp/try-B.sh /tmp/try-C.sh
# B.sh: $0 = /tmp/try-C.sh, BASH_SOURCE = /tmp/try-B.sh /tmp/try-C.sh
# C.sh: $0 = /tmp/try-C.sh, BASH_SOURCE = /tmp/try-C.sh
# A.sh: $0 = /tmp/try-A.sh, BASH_SOURCE = /tmp/try-A.sh

################################################################################
# $0  代表执行的脚本文件名      $$  脚本运行的当前进程号
# $！ 后台最后运行进程的 ID     $?  最后命令退出状态: 0表示没有错误
# $#  脚本/函数参数个数         $1 ... $N 脚本/函数第 1 ... N 个参数
$*  # 脚本/函数参数列表, 不包括 $0, 单字符串(参数列表作为一个整体)
$@  # 脚本/函数参数列表, 不包括 $0, 多字符串(每个参数是独立字符串)

echo '遍历 $@ 无引号'; for i in  $@;  do echo $i; done # 多个
echo '遍历 $@ 双引号'; for i in "$@"; do echo $i; done # 多个
echo '遍历 $* 无引号'; for i in  $*;  do echo $i; done # 多个
echo '遍历 $* 双引号'; for i in "$*"; do echo $i; done # 单个

# 特殊含义的字符
"..." # 双引号, 取消部分元字符的特殊含义
'...' # 单引号, 取消一切元字符的特殊含义, 只保留其字面含义
echo '单引号 @ 是: $@'; echo '单引号 * 是: $*'
echo "双引号 @ 是: $@"; echo "双引号 * 是: $*"
echo " @ 没有引号: "$@; echo " * 没有引号: "$*

# -----------------------------------------------------------------
# 通配符(Wildcard): ?匹配单个字符, *匹配任意字符, [...]仅匹配括号中字符

# -----------------------------------------------------------------
# ; 命令分隔符   ! 逻辑非       & 终端后台进程
# | 管道操作符   < 输入重定向   > 输出重定向

let "var+=1" # 算数运算
true  # 内嵌命令, 退出状态 0
false # 内嵌命令, 退出状态 1
:     # 空命令, 返回 ture, 可做无限循环条件

shift -p # 右移位置参数, 即删除最后一个
shift # 左移位置参数, 即删除第一个, 其余依次左移

test; logout; exit; exit 0; return; return 0;
################################################################################
# 显示当前 Shell 的[环境变量]
env                     # 等同于 printenv
declare -x | grep VAR   # 显示当前 Shell 的环境变量
export -p | grep PATH   # 显示当前 Shell 的环境变量
export VAR=VAL          # 设置当前 Shell 的环境变量(子进程可用)
printenv                # 显示所有环境变量的值(仅显示 export 的变量)
printenv PATH           # 显示指定环境变量的值(仅显示 export 的变量)

# 显示当前 Shell 的[变量]
declare                 # Bash/ZSH 均可用, 在 ZSH 中等于 typeset
declare -p | grep VAR   # 包括环境变量, 普通变量
set | grep VAR          # 包括环境变量, 普通变量, 函数定义(仅Bash)
typeset | grep VAR      # 类似 set, 同时显示变量类型, 仅 ZSH 可用

awk 'BEGIN { for(i=1; i<=10; i++) print i; }'
# 一行显示
env | awk -F '=' '{ print $1 }' | tr '\n' ' '
################################################################################
# 语义代码块 { ... }, 使多个语句在逻辑上形成整体, 用于只能有一个语句的地方
if is-true; then                    is-true && {
  echo "do-something-1"               echo "do-something-1"
  ...                     等同于      ...
  echo "do-something-2"               echo "do-something-2"
fi                                  }
################################################################################
# Here Document, 一种特殊的重定向方式
# => delimiter, 可以是任意字符串, 如 EOF
command << EOF
all the stuff will
send to command, include new-line LF
EOF

# Bash Manual, 3.6.7 Here Strings
# Here 文档的变体, 老旧格式
grep '11' <<< "Here 11 String"
xyz="Here 22 String"
grep '22' <<< $xyz
################################################################################
NUM=10; NUM=$(($NUM + 10)); echo "加法 10 + 10 = $NUM"
NUM=20; NUM=$(($NUM - 10)); echo "减法 20 - 10 = $NUM"
NUM=30; NUM=$(($NUM * 10)); echo "乘法 30 * 10 = $NUM"
NUM=40; NUM=$(($NUM / 10)); echo "整除 40 / 10 = $NUM"
NUM=50; NUM=$(($NUM % 11)); echo "求余 50 % 11 = $NUM"
NUM=2;  NUM=$(($NUM ** 3)); echo "指数  2 ^ 3  = $NUM"

# double parentheses (( ... )) 表达式求值和数学运算
(( 1 )) && echo "(( 1 )) => true"
(( 0 )) || echo "(( 0 )) => false"

((out = 5 + 3));    ((out = 8 - 4));
((out = 3 * 4));    ((out = 8 / 2));    ((out = 8 % 3))
((out = 5 * (3 + 2) - (10 / 2)))

# NOTE 注意 for 后面的空格, (( )) 是 shell 关键字
for ((i = 10; i >= 1; i--)); do echo $i; done
i=0; while ((i <= 10)); do ((i++)); echo $i; done
# ------------------------------------------------------------------------------
# https://phoenixnap.com/kb/bash-let
let "表达式1" "表达式2" ...
NUM++;  --NUM; NUM--; ++NUM;
NUM<<;  NUM1 & NUM2; # << 位右移, & 位与
NUM>>;        ^NUM2; # >> 位左移, ^ 位异或
 NUM~;  NUM1 | NUM2; # ~  位翻转, | 位或
# ! 逻辑非, && 逻辑与, || 逻辑或
!NUM; NUM1 && NUM2; NUM1 || NUM2;
echo > xyz <<EOF
>, <, >=, <=, ==, !=
EXPR1 ? EXPR2 : EXPR3
=, *=, /=, %=, +=, -=, <<=, >>=, &=, ^=, |=  逻辑赋值
EOF
# ------------------------------------------------------------------------------
# 数学运算, bash 不支持简单的数学运算，通常要通过其它命令来实现
#    加法          减法          乘法           除法          取余
expr $a + $b; expr $a - $b; expr $a \* $b; expr $b / $a; expr $b % $a
echo $[1+2]                   # 计算并显示
var=$(echo "(1.1+2.1)" | bc)  # 调用 bc 计算器
let "var=a+b"                 # 计算并将结果赋值给变量
val=`expr $a + $b`            # 计算并将结果赋值给变量
val=$(expr $a + $b)           # 计算并将结果赋值给变量
((val=a+b))                   # 常在 if/for/while 条件判断中需要计算时使用
################################################################################
# SHELL 函数只能返回数字
# - 无明显 return 语句, 返回最后命令的退出状态
# - return NUM, 指定函数返回值, 有效返回值区间 [0, 255]
# - 使用 return 语句(未写返回数值), 则返回 true, 即 return 语句退出状态

function info() { # function 关键字可以省略
  local xyz="what" # 函数局部变量，仅函数内可以访问
  ... # 函数返回值只能是整数: [0, 255]
  return 0; # 返回 0 表示成功，非 0 表示失败
}

if $(is-true x); then echo "ok - x"; fi
[[ $(is-true 1) -eq 0 ]] && echo "ok - 1"

function func() { # 间接引用
  local abc="ok-ok"; local xyz="abc";
  echo " zsh语法 xyz=$xyz, \$\$xyz=${(P)xyz}"
  echo "bash语法 xyz=$xyz, \$\$xyz=${!xyz}"
}
################################################################################
# ZSH/Bash 函数可覆盖, 别名可覆盖, 别名覆盖同名函数
xyz="xyz 变量"
alias xyz='xyz 别名...1'
function xyz() { echo "xyz() 函数1"; }
function xyz() { echo "xyz() 函数2"; }
alias xyz='xyz 别名...1'
xyz; #  执行最后一个别名定义的命令

# ZSH: ${+NAME} 如果 NAME 是已经定义的变量则结果等于1, 否则等于 0
xyz1() { echo 'ok'; }; xyz2=''; unset xyz3;
echo "函数 xyz1=$+xyz1, 变量: xyz2=$+xyz2, unset xyz3=$+xyz3"
# ZSH 执行结果 =>> 函数 xyz1=0, 变量: xyz2=1, xyz3=0

# ZSH: commands 内置变量, 外部命令哈希表, KEY 是命令名, 值是命令路径
# commands[cmake] 表示一个 zsh 的变量
(( $+commands[cmake] )) && echo "cmake: $commands[cmake]"
(( $+commands[xyzab] )) || echo "xyzab: 未找到可执行文件"
################################################################################
# https://opensource.com/article/20/6/bash-trap
# The trap keyword catches signals that may happen during execution.

# 显示信号列表
bash # 启动 bash
trap -l; trap --help

# 捕捉信号的添加/删除, 语法: trap 选项 命令 sin1 sig2 sig3 ... sigN
trap 'print $LINENO' DEBUG
trap -- '' DEBUG # 删除信号捕捉
trap 'echo "You have press Ctrl-c"' SIGINT # 信号捕获 Ctrl + C
trap -- '' SIGINT # 删除信号捕捉
function exitHandler() { echo "Goodbye!"; }
trap 'exitHandler' EXIT # exit 命令回调

# https://phoenixnap.com/kb/bash-trap-command
trap -l # Bash only, show signal list
# NOTE Signals 32 and 33 are not supported in Linux, and
# the `trap -l` command does not display them in the output
# NOTE The SIG prefix in signal names is optional.
# For example, SIGTERM signal can also be written as TERM
#
# NOTE most commonly used signals with the trap command are:
# 挂起 SIGHUP  (1) - Clean tidy-up   取消 SIGABRT  (6) - Cancel
# 中断 SIGINT  (2) - Interrupt       警告 SIGALRM (14) - Alarm clock
# 退出 SIGQUIT (3) - Quit            终止 SIGTERM (15) - Terminate
#
# SIGINT (1) => Occurs when press Ctrl + C
# EXIT   (0) => Occurs when the shell process itself exits

# 调用示例
# 写入文件 => trap-debug.sh
trap 'echo "[$LINENO] => a=${a}, b=${b}, c=${c}"' DEBUG
a=1; b=2; c=3;
echo "a b c = $a $b $c "
echo "位置参数个数 $#"
echo "位置参数列表 $@"
# => $ bash trap-debug.sh

# 调用示例
# 写入文件 => trap-sigint.sh
xTmpFile="/tmp/my_tmp_file_$$"
trap 'rm -f $xTmpFile' SIGINT # 当有 SIGINT 信号时执行 rm 语句
echo "Creating file $xTmpFile"
date > $xTmpFile
echo "Press Ctrl+C to interrupt ..."
while [ -f $xTmpFile ]; do
  echo "Exists => $xTmpFile"
  sleep 5 # 5 秒
done
echo "重置 SIGINT 信号默认动作"
sleep 5
clear
trap SIGINT
# SIGINT 信号默认对应的操作是终止当前进程
echo "Creating file $xTmpFile"
date > $xTmpFile
echo "Press Ctrl+C to interrupt ..."
while [ -f $xTmpFile ]; do
  echo "Exists => $xTmpFile"
  sleep 5 # 5 秒
done
# => $ bash trap-sigint.sh
################################################################################
# https://tldp.org/LDP/abs/html/x9644.html#JOBIDTABLE
# 脚本中判断其是否在后台执行
# $$ 表示当前进程的 PID
# ps -p $$ -o state= # 显示进程状态: 单字符
# ps -p $$ -o stat=  # 显示进程状态: 多字符
case $(ps -p $$ -o stat=) in
  *+*) echo "Running in Foreground" ;;
  *)   echo "Running in Background" ;;
esac

# $ ./cmd   表示 cmd 命令在前台执行
# $ ./cmd & 表示 cmd 命令在后台执行
# Ctrl + C 将当前 Shell 进程终止, 不可恢复
# Ctrl + Z 将当前 Shell 进程暂停并放入后台, 可恢复

# 将指定任务放到前台(fg)或后台(bg)
# $ fg/bg       # 匹配当前任务
# $ fg/bg %--   # 匹配上一个任务
# $ fg/bg %N    # N 是 jobs 命令显示的任务号
# $ fg/bg %abc  # 匹配以 abc 开头的命令(任务)
# $ fg/bg %xyz? # 匹配包含 abc 字符串的命令(任务)
# $ jobs # 仅显示当前 Shell 的任务信息: running, suspended/stopped

# Keep Linux Process Running After Exit Shell
# $ disown  -h  %1
# $ nohup tar -czf iso.tar.gz Templates/* &

# 测试代码: 写入文件 ~/a代码测试, $ ~/a代码测试 或 $ ~/a代码测试 &
CNT=1; MAX=20
while true; do
  CNT=$(($CNT + 1))
  if [ $CNT -eq $MAX ]; then
    break
  fi
  # 检查当前脚本运行状态: 前台/后台
  case $(ps -p $$ -o stat=) in
    *+*) echo "Running in Foreground, $CNT/$MAX" ;;
    *)   echo "Running in Background, $CNT/$MAX" ;;
  esac
  sleep 1s # 延迟等待 1 s
done
################################################################################
if COND; then echo ok; fi
if COND; then echo ok1; else echo ok2; fi
if COND; then echo ok1; elif COND; then echo ok2; else  echo ok3; fi

if ! cmd >& /dev/null; then echo cmd-error-show-this; fi
if   cmd >& /dev/null; then echo cmd-ok-show-this;    fi
################################################################################
case "$VAR" in
  "what") # VAR 检测是否匹配 what
    ;; # 表示 break，跳出整个 case … esac 语句
  "x1"|"x2") # 匹配 x1 或 x2
  ...
  *) # 上述均没有匹配，则匹配此项
    ;;
esac

PS3="选择命令提示符号"
select VAR in Seq1 Seq2 ...; do
  # 显示出带编号的菜单，用户出入不同编号
  # 就可以选择不同的菜单，并执行不同的功能
  ...
done

select VAR in "Linux" "Mac" "Win"; do
  ... VAR ...
  break; # 结束推出选择
done
echo "You have selected $VAR"
################################################################################
# for (( ; ; )); do # 无限循环
for ((i=1;i<=10;i++)); do
  echo $(expr $i \* 3 + 1);
  # break
  # continue
done

#for Var in item1 item2 ... itemN; do
for i in $(seq 1 10); do echo $(expr $i \* 3 + 1); done
for i in {1..10}; do echo $(expr $i \* 3 + 1); done
for i in $*; do echo "input chart $i"; done
for i in `ls`; do echo "file name: $i"; done
for file in $(ls); do echo "file name: $file"; done
for file in /proc/*; do echo "file name: $file"; done
for i in f1 f2 f3; do echo "=> $i"; done

list="rootfs usr data data2"
for i in $list; do echo "=> $i"; done

while COND; do echo ok; break; continue; done
idx=0 && while (($idx<100)); do echo ok; let "idx++"; done
# 无限循环
while :; do echo ok; done
while true; do echo ok; done

until COND; do echo ok; break; continue; done
################################################################################
