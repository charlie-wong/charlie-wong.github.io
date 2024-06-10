# https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters

$*    # 从 $1 开始的位置参数, 等同于 "$1" "$2" "$3" ...
"$*"  # 从 $1 开始的位置参数, 等同于 "$1c$2c…", c 表示 IFS 变量值的首字符
      # - 若 IFS 的值为空, 则 c 为空
      # - 若 IFS 未设置(unset), 则 c 表示单个空格

$@    # 从 $1 开始的位置参数, 等同于 "$1" "$2" "$3" ...
"$@"  # 从 $1 开始的位置参数, 等同于 "$1" "$2" "$3" ...

$-    # 当前 shell 的启动参数
$0    # shell 启动时设置, shell 可执行文件名或脚本文件名
$$    # 当前 shell 进程的 PID, 当位于 subshell 时, 表示 invoking-shell 的 PID

$#    # 表示位置参数的个数
$?    # 表示最后执行的命令的退出状态码
$!    # 表示最后放入后台的 job 的进程 PID
