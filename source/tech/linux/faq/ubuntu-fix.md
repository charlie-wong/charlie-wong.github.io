# Ubuntu Desktop Workarounds

- **Issue** `journalctl -b | grep 'exit code 1'`
  * https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1966203
  * 相关文件: `/lib/udev/rules.d/66-snapd-autoimport.rules`
  * __NOTE__ The workaround works for Ubuntu 22.04 update at 2024-04-26
  * 解决方式: `sudo ln -s /dev/null /etc/udev/rules.d/66-snapd-autoimport.rules`

- **Issue** sddm-helper: gkr-pam: unable to locate daemon control file
  * https://github.com/canonical/lightdm/issues/70
  * https://bugzilla.redhat.com/show_bug.cgi?id=1796544
  * https://gitlab.gnome.org/GNOME/gnome-keyring/-/issues/28

- **Issue** `journalctl -b | grep 'systemd-backlight@backlight:nvidia'`
  * __NOTE__ The workaround works for Ubuntu 22.04 update at 2024-04-26
  * 解决方式: https://forums.developer.nvidia.com/t/unable-to-break-cycle-starting-with-systemd-backlight-backlight-nvidia-0-service-start

- **Issue** Nvidia RmInitAdapter failed since kernel > 6.4
  * https://forums.developer.nvidia.com/t/rminitadapter-failed-since-kernel-6-4/284717
  * __NOTE__ The workaround works for Ubuntu 24.04 update at 2024-05-20
  * 解决方式: `nvidia-driver-550` works fine with kernel > 6.1.x

- **Issue** 启动时 `gpu-manager.service` 耗时接近 2 分钟
  * https://github.com/canonical/ubuntu-drivers-common/tree/master/share/hybrid
  * `ls -lh /var/log/gpu-*`
  * `apt show ubuntu-drivers-common`
  * `apt-file search /usr/bin/gpu-manager`
  * `systemd-analyze` and `systemd-analyze blame | head`
  * __NOTE__ The workaround works for Ubuntu 24.04 update at 2024-05-22
  * 解决方式(1) 内核参数 __nogpumanager__ 禁用 `/usr/bin/gpu-manager` 命令
  * 备注: 阅读源码, 干了什么, 卡在哪里?

- **Issue** 启动日志 `Bluetooth: hci0: Malformed MSFT vendor event: 0x02`
  * 内核 https://elixir.bootlin.com/linux/v6.6.31/source/net/bluetooth/msft.c
  * 调用链 `msft_vendor_evt() -> msft_monitor_device_evt() -> msft_skb_pull()`
  * 备注: 目前为止此错误消息无害(不影响蓝牙正常功能)

- **Issue** 蓝牙 `profiles/sap/server.c:sap_server_register() Sap driver initialization failed.`
  * 分析 https://github.com/bluez/bluez/issues/441
  * 分析 https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=803265
  * 源码 https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/profiles/sap/server.c
  * 源码 https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/profiles/sap/sap-dummy.c
  * __NOTE__ The workaround works for Ubuntu 24.04 update at 2024-05-22
  * 解决方式: 添加 `--noplugin=sap` 参数禁用 SAP 蓝牙插件
    - `systemctl cat bluetooth` 定位 systemd unit 蓝牙文件
    - `ExecStart=/usr/libexec/bluetooth/bluetoothd --noplugin=sap`
    - 重新加载 `sudo systemctl daemon-reload`
    - 重启服务 `sudo systemctl restart bluetooth`
    - 服务状态 `systemctl status bluetooth`
    - 查看日志 `journalctl -b | grep bluetooth`

- **Issue** `iwlwifi WRT: Invalid buffer destination`
- **Issue** `ACPI BIOS Error (bug): Could not resolve symbol [\_TZ.ETMD], AE_NOT_FOUND (20230628/psargs-330)`
- **Issue** `ACPI Error: Aborting method \_SB.IETM._OSC due to previous error (AE_NOT_FOUND) (20230628/psparse-529)`
  * https://bugzilla.kernel.org/show_bug.cgi?id=218269
