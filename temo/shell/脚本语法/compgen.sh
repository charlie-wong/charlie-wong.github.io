# Bash 可编程补全系统
# 8.6 Programmable Completion
# https://www.gnu.org/software/bash/manual/bash.html
# https://tylerthrailkill.com/2019-01-19/writing-bash-completion-script-with-subcommands
# https://www.gnu.org/software/gnuastro/manual/html_node/Bash-TAB-completion-tutorial.html

# NOTE Ubuntu 统默认安装 bash-completion
# -> sudo apt install bash-completion

compgen -a # -A alias     => 显示 Bash 的 alias 列表
compgen -b # -A builtin   => 显示 Bash 的 builtin 列表
compgen -A function #     => 显示 Bash 当前所有可用函数名列表
compgen -c # -A command   => 显示所有可用命令列表(包括函数/别名/可执行文件)
compgen -d # -A directory => 显示当前工作目录下的文件夹名列表
compgen -e # -A export    => 显示所有 export 的变量名
compgen -f # -A file      => 显示当前工作目录的文件及文件夹名列表
compgen -g # -A group     => 显示系统所有 group 名列表
compgen -j # -A job       => 显示当前 shell 的 job 列表
compgen -k # -A keyword   => 显示 Bash 的 keywords 列表
compgen -s # -A service   => 显示系统 service 名列表
compgen -u # -A user      => 显示系统所有用户名列表(包括系统自动创建的虚拟用户)
compgen -v # -A variable  => 显示当前 shell 所有变量名列表

complete -P 'prefix'    # => 所有补全结果添加 prefix 前缀字符串
complete -S 'suffix'    # => 所有补全结果添加 suffix 后缀字符串
complete -W "WordList"  # => 由 IFS 分隔的关键字列表
complete -G 'globpat'   # => 依据 globpat 进行文件名扩展, 生成补全列表
complete -C '命令'      # => 在 subshell 中执行[命令]
