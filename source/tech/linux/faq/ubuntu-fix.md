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

- **Issue** 启动时 `gpu-manager.service` 耗时 1 分钟
  * `ls -lh /var/log/gpu-*`
  * `apt show ubuntu-drivers-common`
  * `apt-file search /usr/bin/gpu-manager`
  * `systemd-analyze` and `systemd-analyze blame | head`
  * https://github.com/canonical/ubuntu-drivers-common/tree/master/share/hybrid
  * 解决方式1: 内核参数 __nogpumanager__ 禁用 `/usr/bin/gpu-manager` 命令
  * TODO: 实现源码, 它都干了什么, 卡在哪里?

- **Issue** 启动日志 `Bluetooth: hci0: Malformed MSFT vendor event: 0x02`
  * 内核 https://elixir.bootlin.com/linux/v6.6.31/source/net/bluetooth/msft.c
  * 调用链 `msft_vendor_evt() -> msft_monitor_device_evt() -> msft_skb_pull()`
  * 备注: 目前为止此错误消息无害(不影响蓝牙正常功能)
