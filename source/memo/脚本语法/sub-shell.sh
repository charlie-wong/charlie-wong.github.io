# 创建 subshell 并在其中执行命令
# => $(cmd) 和 `cmd` 形式自动删除最后的换行符(中间的换行符保留)
echo    `echo "[${SHLVL}]B[${BASH_SUBSHELL}]Z[${ZSH_SUBSHELL}]"; echo ok;`
echo "$( echo "[${SHLVL}]B[${BASH_SUBSHELL}]Z[${ZSH_SUBSHELL}]"; echo ok; )"
$(cat file) can be replaced by $(< file), and $(< path/to/file ) is faster
( echo "[${SHLVL}]B[${BASH_SUBSHELL}]Z[${ZSH_SUBSHELL}]"; echo ok1; )

# https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping

{ 命令序列; }  # execute in current shell context, no subshell created
               # NOTE semicolon or newline required, cmds can NOT empty
# 分组命令, 在当前会话环境中执行, 非 sub-shell
{ cmd1; cmd2; ... }

# The exit status of both constructs is the last cmd exit status
( 命令序列 ) 或 { cmd1; cmd2; ... }
