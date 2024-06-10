# Home Dot Files

## Zsh and Bash

`~/.zcompdump` is for ZSH completion cache, search `ZSH_COMPDUMP` in OhMyZsh.

## GTK Theme

- https://wiki.gnome.org/Attic/GnomeArt/Tutorials/GtkThemes

`~/.gtkrc-2.0` file overrides settings of whatever gtk theme.

## Desktop(X-Window System) Logs

`~/.xsession-errors` is where the X-Window system logs all errors that occur
within the Linux graphical environment. Therefore any graphical application
running on your computer can cause that error messages are written to it,
that is why it can grow wildly until reaching very big sizes.

There is a control mechanism in the `/etc/X11/Xsession` file that causes
the file to be emptied each time the graphical environment starts up if
it exceeds a certain size.

## Xauthority
- https://xorg.freedesktop.org/wiki/
- https://man.archlinux.org/man/xauth.1

`~/.Xauthority` can be found in each user home. It is used to store credentials
in cookies, used by `xauth`, for secure authentication communication between
XClient and XServer.

- `XAUTHORITY` is the file path of  `~/.Xauthority`
- `DISPLAY` is the **display number** stored in the `~/.Xauthority`

- `xauth` 加载 ~/.Xauthority 文件, `man xauth` 查看帮助手册
- **list** 显示其内容, **quit** 放弃修改退出, **remove ...** 删除指定 cookie
