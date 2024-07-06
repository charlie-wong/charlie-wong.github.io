# Zsh Completion Newbies Guide
# -> https://stackoverflow.com/questions/9000698
# -> https://zv.github.io/a-review-of-zsh-completion-utilities
# -> https://tylerthrailkill.com/2019-01-13/writing-zsh-completion-scripts/
# -> https://www.dolthub.com/blog/2021-11-15-zsh-completions-with-subcommands/
# -> https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org

# https://unix.stackexchange.com/questions/581632
_arguments '-b[desc]:my-msg:(x y)' # Where is 'my-msg'

# TODO `_arguments` 预定义变量
# => words  curcontext  CURRENT  PREFIX
# => state  state_descr  context  line  opt_args
echo "01->${(t)words}[${words[@]}]"
echo "02->${(t)curcontext}[${curcontext}]"
echo "03->${(t)CURRENT}[${CURRENT}]"
echo "03->${(t)PREFIX}[${PREFIX}]"
echo
echo "10=>${(t)line}[${line[@]}]"
echo "11=>${(t)state}[${state[@]}]"
echo "12=>${(t)state_descr}[${state_descr[@]}]"
echo "13=>${(t)context}[${context[@]}]"
