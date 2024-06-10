# sed  awk  grep  ack           cat  tac  nl  fd  duf
# head  tail  sort  cut  tr     cksum  md5sum  sha256sum
# more  less  column  scripts   strings  tee

# setopt    显示 ZSH 已启用的选项列表
# unsetopt  显示 ZSH 未启用的选项列表
# autoload  显示 ZSH 自动加载函数列表

# 显示 MIME 类型信息
file -bi path/to/file

# 临时绕过 shell 别名的方式
\ls           # 方式一
command ls    # 方式二
'ls'; "ls"    # 方式三
unalias ls    # 方式四

# 删除字符串行尾空格
echo -n 'xx'; eval echo -n '  {aa}   '; echo 'yy'

# 显示文件行数
wc -l 文件名; sed -n '$=' 文件名; grep -c '^' 文件名

# IFS: Internal Field Separator
# IFS 默认值: ' \t\n', 即 Space(20), Tab(09), Newline(0A)
# https://www.baeldung.com/linux/ifs-shell-variable
printf "===[%q]===\n" "$IFS"
echo -n "$IFS" | hexyl
echo -n "$IFS" | cat -et # 显示结果 ^I 表示 Tab, $ 表示 Newline

# 历史遗留/兼容性语法
[[ "${VAR}" ]]              等同于 [[ -n "${VAR}" ]]
[[ "${STR1}" = "${STR2}" ]] 等同于 [[ "${STR1}" == "${STR2}" ]]

# 递归式参数解引用
VAR1='var1-value'; VAR2=VAR1
echo "V1=[${VAR1}] V2=[${VAR2}] VX=[${(P)VAR2}]" # zsh
echo "V1=[${VAR1}] V2=[${VAR2}] VX=[${!VAR2}]"   # bash

# 检查 shell 变量类型
declare -p VAR #  https://unix.stackexchange.com/questions/246026
echo ${(t)VAR} # Zsh 语法, 显示结果更加详细, `declare -p` 亦可工作

printenv SHELL             # 查看用户默认 shell
grep $(whoami) /etc/passwd # 查看用户默认 shell
# 显示系统已装 shell, 仅显示排序后的名字
cat /etc/shells | sed -e '{1d}' -e 's/bin//g' -e 's/usr//g' -e 's#/##g' | sort -u
# 默认 shell 设置为 /usr/bin/zsh, 用户默认 shell 信息位置 /etc/passwd
# -> 注意: 修改默认后需要 logout 再 login 后才能生效
# -> 方式一 sudo chsh -s /usr/bin/zsh $(whoami)
# -> 方式二 sudo usermod -s /usr/bin/zsh $(whoami)

local IFNAME="$(ip neigh | cut -d' ' -f3 | sort -u)"
if ! ip a | grep "$IFNAME" | grep inet >& /dev/null; then
  IFNAME="获取网卡名称失败"
fi
# 网卡状态信息
nmcli device status         # 系统各网卡状态
nmcli device show "$IFNAME" # 已连接网卡状态

# find 命令
# ( 和 ) 符号需要转义(加反斜线), 防止 shell 解释
# 逻辑与: -a -and Space   逻辑或: -o -or 逻辑非 -not
# EXP1, EXP2    EXP1求值但丢弃, 用 EXP2 求值结果判断
# -print        显示匹配文件名
# -type d -name Name  搜索目录
# -type f -name Name  搜索文件
# -path build -prune  搜索时排除 build 目录

# Shell 进制转换 NOTE 字母必须大写
echo "ibase=10;obase=16;12"  | bc # 10进制 -> 16进制
echo "ibase=16;obase=A; C"   | bc # 10进制 -> 16进制
echo "ibase=10;obase=2;11"   | bc # 10进制 ->  2进制
echo "ibase=2 ;obase=A;1011" | bc #  2进制 -> 10进制
echo "ibase=10;obase=8;12"   | bc # 10进制 ->  8进制
echo "ibase=8 ;obase=A;14"   | bc #  8进制 -> 10进制
echo $((2#1011)) # 二进制 -> 十进制
echo $((8#13))   # 八进制 -> 十进制
echo $((16#B))   # 16进制 -> 十进制

# Shell 任务暂停/恢复
jobs # 显示当前 Shell 后台任务信息
# 将指定任务放到前台 fg 或后台 bg
fg; bg       # 匹配当前任务
fg; bg %--   # 匹配上一个任务
fg; bg %N    # N 是 jobs 命令显示的任务号
fg; bg %abc  # 匹配以 abc 开头的命令(任务)
fg; bg %xyz? # 匹配包含 abc 字符串的命令(任务)

# 显示当前分支关联的远程分支       # 重命名 Github 默认分支
git branch -vv                     git branch -m main trunk
git status -b --porcelain          git fetch origin
git status -b --porcelain=v1       git branch -u origin/trunk trunk
git status -b --porcelain=v2       git remote set-head origin -a

git rev-parse --show-toplevel      显示仓库根路径
git rev-list --count 分支名        查看指定分支有多少个提交记录
