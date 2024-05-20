# Ubuntu Desktop Workarounds

- **Issue** `journalctl -b | grep 'exit code 1'`
  * The workaround works for Ubuntu 22.04 update at 2024-04-26
  * https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1966203
  * 相关文件: `/lib/udev/rules.d/66-snapd-autoimport.rules`
  * 解决方式: `sudo ln -s /dev/null /etc/udev/rules.d/66-snapd-autoimport.rules`

- **Issue** sddm-helper: gkr-pam: unable to locate daemon control file
  * The workaround works for Ubuntu 22.04 update at 2024-04-26
  * 解决方式: https://gitlab.gnome.org/GNOME/gnome-keyring/-/issues/2

- **Issue** `journalctl -b | grep 'systemd-backlight@backlight:nvidia'`
  * The workaround works for Ubuntu 22.04 update at 2024-04-26
  * 解决方式: https://forums.developer.nvidia.com/t/unable-to-break-cycle-starting-with-systemd-backlight-backlight-nvidia-0-service-start

- **Issue** Nvidia RmInitAdapter failed since kernel > 6.4
  * The workaround works for Ubuntu 24.04 update at 2024-05-20
  * 解决方式: `nvidia-driver-550` works fine with kernel > 6.1.x
  * https://forums.developer.nvidia.com/t/rminitadapter-failed-since-kernel-6-4/284717
