# 虚拟终端

- Ubuntu 默认环境变量
  * https://help.ubuntu.com/community/EnvironmentVariables
  * Shell 命令历史记录(未加载任何用户配置文件)
    - zsh 默认不保存命令历史记录, bash 默认将命令历史保存到 `~/.bash_history`

- Shell 简介
  * Bash, Zsh 侧重交互式应用, 而 dash 则主要关注非交互脚本性能
    - https://www.baeldung.com/linux/dash-vs-bash-performance
  * https://wiki.debian.org/Shell     https://wiki.archlinux.org/title/Dash
  * https://wiki.debian.org/Bash      https://wiki.archlinux.org/title/Bash
  * https://wiki.debian.org/Zsh       https://wiki.archlinux.org/title/Zsh

- Bash
  * Maintainer
    - https://tiswww.case.edu/php/chet/bash/bash.html
    - https://tiswww.case.edu/php/chet/bash/CHANGES
    - https://tiswww.case.edu/php/chet/bash/bashtop.html
    - https://tiswww.case.edu/php/chet/bash/bash-intro.html
  * Bash 自动补全
    - https://github.com/scop/bash-completion
    - https://repology.org/project/bash-completion/versions
  * Bash 默认配置文件 `.bashrc` 系统备份位置 /etc/skel/
    - https://bazaar.launchpad.net/~ubuntu-branches/ubuntu/trusty/bash/trusty/view/head:/debian/skel.bashrc

- Zsh
  * https://grml.org/zsh/
  * http://www.bash2zsh.com/zsh_refcard/refcard.pdf
  * https://thevaluable.dev/zsh-completion-guide-examples
  * 启动配置文件及作用
    - `$ZDOTDIR/.zshenv`    should only contain user’s environment variables
    - `$ZDOTDIR/.zprofile`  can be used to execute commands just after logging in
    - `$ZDOTDIR/.zshrc`     should be used for configuration and executing commands
    - `$ZDOTDIR/.zlogin`    same purpose than .zprofile, but read just after .zshrc
    - `$ZDOTDIR/.zlogout`   can be used to execute commands when a shell exit

- Linux Terminal Emulators
  * https://www.tecmint.com/linux-terminal-emulators
  * https://wiki.archlinux.org/title/Category:Terminal_emulators
  * Tabby      https://tabby.sh
  * Konsole    https://konsole.kde.org
  * Contour    https://contour-terminal.org
  * Kitty      https://sw.kovidgoyal.net/kitty
  * Xterm      https://invisible-island.net/xterm

- Terminal 文档
  * 终端和命令行相关资源      https://terminalsare.sexy/
  * ASCII 终端 ANSI 标准总结  http://www.inwap.com/pdp10/ansicode.txt
  * Xterm 控制序列            http://invisible-island.net/xterm/ctlseqs/ctlseqs.html
  * ASCII 和 Unicode 控制字符 https://www.aivosto.com/articles/control-characters.html
  * http://www.ecma-international.org/publications/standards/Ecma-048.htm
  * http://vt100.net/docs/vt100-ug    Digital VT100 User Guide
  * http://vt100.net/docs/vt220-rm    Digital VT220 Programmer Reference Manual

- Open Group Specifications: Shell and Utilities
  * https://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html
  * https://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html
  * 脚本检查工具 https://archlinux.org/packages/extra/x86_64/shellcheck
  * POSIX Compliant Shell Common Configuration
    - https://wiki.archlinux.org/title/Command-line_shell
    - Bash 最接近 POSIX 标准
    - POSIX 兼容性: Bash > Dash > Zsh > Fish ...
