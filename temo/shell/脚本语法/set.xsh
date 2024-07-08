echo $- # 显示当前 Shell 选项
set +n # 脚本语法检查(不执行)

# -X 启用 X 选项, +X 关闭 X 选项
# e 若某指令返回值不等于 0，则立即退出      v 显示 shell 脚本命令
# u 使用未定义变量/参数，显示错误立刻退出   x 逐条显示命令及其参数
# 示例快速参考 https://phoenixnap.com/kb/linux-set
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html

# Running `set` command without any options outputs list of all settings,
# which include names and values of all shell variables and functions

# Automatically export any variable or function created using the -a option.
# Exporting variables or functions allows subshells and scripts to use them.

# The default Bash setting is to overwrite existing files. However, using
# the -C option configures Bash not to overwrite an existing file when output
# redirection using >, >&, or <> is redirected to that file.

# The set command can also assign values to positional parameters.
# => set first second third

# Use the set command to split strings based on spaces into separate variables.
# => myvar="This is a test"
# => set -- $myvar
# => echo "$1 $2 $3 $4"
# NOTE double dash (--) is used in Bash/ZSH for commands to signify the end
# of command options, after which only positional arguments are accepted.

function try() {
  echo "[$#][$1][$2][$3][$4][$5]"
  set -- a b c # 重置位置参数
  echo "[$#][$1][$2][$3][$4][$5]"
}; try a1 a2 a3 a4
