# Error Fix for Ubuntu 22.04

- `journalctl -b |grep 'exit code 1'`
  * https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1966203
  * 相关文件: `/lib/udev/rules.d/66-snapd-autoimport.rules`
  * 解决方式: `sudo ln -s /dev/null /etc/udev/rules.d/66-snapd-autoimport.rules`

- sddm-helper: gkr-pam: unable to locate daemon control file
  * https://gitlab.gnome.org/GNOME/gnome-keyring/-/issues/28
