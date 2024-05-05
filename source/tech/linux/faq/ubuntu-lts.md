# Ubuntu 24.04 LTS Essential

- 修改 APT 国内源(加速更新速度)
  * `sudo apt update && sudo apt upgrade`
  * 软件包自动升级 `apt show unattended-upgrades`

- 安装 [XanMod](https://xanmod.org) 的 [LTS](https://www.kernel.org) 版内核
  * `apt depends linux-generic` 和 `apt search ^linux-generic`
  * `sudo apt install linux-generic` 安装 Ubuntu GA 版本的内核镜像
  * `sudo apt remove linux-image-6.8.0-31-generic` 删除指定版本内核

  * `apt search "linux-image-6\\.1\\..*-x64v3-xanmod"`
  * `sudo apt install linux-image-6.1.77-x64v3-xanmod1 linux-headers-6.1.77-x64v3-xanmod1`

  * **BUG** 24.04 with kernel 6.8 无法正常关机/重启(和 snap 相关)
    - https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2059738

- 安装 [Nvidia](https://www.nvidia.com/en-us/drivers/unix) 显卡驱动
  * `apt search ^nvidia-dkms-` 和 `apt search ^nvidia-driver-`
     - 首先安装 nvidia 内核模块和内核动态模块系统
       * `linux-modules-nvidia-*` 和 `nvidia-dkms-*`
     - 然后安装 nvidia 显卡驱动 `nvidia-driver-*`

- 清理 [Snap](https://snapcraft.io) + 安装 [Flatpak](https://docs.flatpak.org/en/latest)
  * https://itsfoss.com/remove-snap
  * https://www.debugpoint.com/remove-snap-ubuntu
  * https://www.baeldung.com/linux/snap-remove-disable
  * https://launchpad.net/~mozillateam/+archive/ubuntu/ppa `Firefox` 和 `Thunderbird`

  * https://github.com/canonical/firmware-updater
  * https://fwupd.github.io/libfwupdplugin/index.html

  ```bash
  snap list # 查看已安装的 snap 软件包
  snap info gtk-common-themes # 查看软件包信息

  dpkg -l | grep ^rc # 显示已删除但保留配置的软件包
  dpkg -l | grep "^rc" | awk '{print $2}' | sudo xargs dpkg --purge # 清理残留

  # 按下列顺序依次卸载软件包
  sudo snap remove --purge firefox;     sudo apt purge firefox
  sudo snap remove --purge thunderbird; sudo apt purge thunderbird
  sudo snap remove --purge firmware-updater
  sudo snap remove --purge gnome-42-2204
  sudo snap remove --purge gtk-common-themes

  sudo snap remove --purge bare
  sudo snap remove --purge core22
  sudo snap remove --purge snapd

  systemctl | grep snap # 查看已启动 snap 服务
  sudo systemctl stop    Snap服务 # 关闭 snap 服务
  sudo systemctl disable Snap服务 # 禁用 snap 服务

  snap list # 确认已经清空应用
  locate snapd.service
  sudo systemctl stop    snapd
  sudo systemctl disable snapd # 删除 /etc/systemd/system/multi-user.target.wants/snapd.service
  sudo systemctl mask    snapd # 删除 /usr/lib/systemd/system/snapd.service → /dev/null

  systemctl list-dependencies  graphical.target | grep snap # 桌面
  systemctl list-dependencies multi-user.target | grep snap # 终端

  ###################
  reboot # 关机重启 #
  ###################

  # => 清理剩余残留软件包
  dpkg --list | grep snap
  apt list --installed | grep snap
  sudo apt purge snapd
  sudo apt purge plasma-discover-backend-snap
  apt search plasma-discover-backend
  apt depends --installed plasma-discover-backend-snap

  apt show plasma-discover # 建议依赖 plasma-discover-backend-flatpak
  sudo apt install --install-suggests plasma-discover

  for i in $(apt list --installed 2> /dev/null | grep snap | cut -d/ -f1); do \
    printf "=> \e[31m$i\e[0m\n"; apt depends --installed $i; \
    apt rdepends --installed $i; \
  done

  cat /snap/README; locate .snap
  for i in $(locate .snap); do \
    if [[ -f $i ]]; then ls -hl $i; else printf "\e[31mNO\e[0m $i\n"; fi \
  done

  # => 查看系统日志发现问题解决问题
  ps aux | grep snap # 查找系统进程
  sudo journalctl -fx # 持续监控系统日志
  journalctl -b -p err..alert # 错误/警告
  journalctl -b | grep snap # 查看启动日志
  systemctl status # 查看 systemd 服务状态
  systemctl --failed # 显示启动失败的服务
  systemctl list-units --failed # 显示失败服务

  # https://apparmor.net
  # https://gitlab.com/apparmor/apparmor
  # https://gitlab.com/apparmor/apparmor/-/issues/265   内核版本导致(兼容性问题)
  ls /etc/apparmor* # 查看配置文件
  apt policy apparmor # 确认软件版本
  systemctl status apparmor.service # 服务状态
  grep -nr 'bin/man' /etc/apparmor.d/*

  # => 删除 snap 残留文件
  rmdir ~/snap # 删除空目录
  ls -ldh /{,var/,var/lib/}s*

  sudo apt autoremove
  sudo apt autoclean
  ```

- 安装常用开发管理软件
  ```bash
  sudo apt-mark auto   PKG  # 标记 PKG 包为<自动>安装
  apt-mark showauto         # 显示<自动>安装的软件包
  sudo apt-mark manual PKG  # 标记 PKG 包为<手动>安装
  apt-mark showmanual       # 显示<手动>安装的软件包

  sudo apt-mark hold   PKG  # 标记 PKG 包(阻止其版本升级和删除)
  sudo apt-mark unhold PKG  # 取消对 PKG 软件包的 Hold 标记
  apt-mark showhold         # 显示 Hold 标记状态的软件包列表

  sudo apt install apt-file; sudo apt-file update
  sudo apt install apt-show-versions

  sudo apt install gdisk
  sudo apt install bcompare
  sudo apt install 7zip 7zip-rar
  sudo apt install microsoft-edge-stable

  # https://github.com/linrunner/TLP
  apt show tlp # 笔记本电源优化管理
  dpkg -l | grep fonts- # 显示已安装字体
  ```
