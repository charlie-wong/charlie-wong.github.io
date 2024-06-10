# Bash -> 3.5.6 Process Substitution
# Zsh -> 7 Redirection
# Zsh -> 14.2 Process Substitution
# https://zsh.sourceforge.io/Intro/intro_7.html
# https://zsh.sourceforge.io/Doc/Release/Redirection.html

# 语法  <( cmd1 ) make cmd1 output pipe out as if it were file
# 语法  >( cmd2 ) pipe something into for cmd2
# Works on system that support Named PIPE(FIFOs) `man mkfifo`

# 进程替换(process substitution)的 Shell 语法(Bash/Zsh/Ksh)
# => https://unix.stackexchange.com/questions/155806
# 语法 <( cmd1 ) 形式将 cmd1 命令的输出转换为 fake-file
# 示例 diff <(cat /etc/passwd) <(cut -f2 /etc/passwd)
