# 英伟达显卡(NVIDIA GeForce RTX 3060 Laptop GPU GA106M)

- https://www.techpowerup.com/vgabios
- https://wiki.archlinux.org/title/GPGPU
- https://wiki.archlinux.org/title/NVIDIA

```bash
xrandr # 查看屏幕可用分辨率
xrandr | grep '*' # 查看屏幕当前分辨率
xdpyinfo | grep 'dimensions:' # 查看屏幕当前分辨率

# 查看显卡硬件及当前驱动信息
lspci -nn | grep VGA # 显示系统所有显卡的简要信息
lspci -k  | grep VGA -A3 # 显示系统所有显卡的简要信息
lspci -vv | grep GA106M -A15 # 显示 GA106M 显卡详细信息
lspci -vvv -s 01:00.0 # 查看 BUS 接口 01:00.0 上的显卡信息

# 显示 GA106M 显卡详细信息(Capabilities ...)
sudo lshw -numeric -C display
sudo lspci -vv | grep GA106M -A86

# 显卡工作模式
prime-select query # 查看显卡当前工作模式
sudo prime-select on-demand  # 按需选择
  cat /lib/modprobe.d/nvidia-runtimepm.conf
  # options nvidia "NVreg_DynamicPowerManagement=0x02"
sudo prime-select intel  # 选择 Intel  显卡
sudo prime-select nvidia # 选择 Nvidia 显卡
sudo nvidia-settings     # 显卡图形设置面板

# PCI:*(1@0:0:0) 10de:2560:17aa:3ae8 rev 161 ...
cat /var/log/Xorg.0.log | grep "PCI:"
# kernel-5.15.0 => IRQ: 191, VBIOS: 94.06.34.00.42
# kernel-6.4.15 => IRQ: 165, VBIOS: 94.06.34.00.2f
cat "/proc/driver/nvidia/gpus/0000:01:00.0/information"

# 查看 NVIDIA 显卡型号及 GPU-UUID
nvidia-debugdump --list
nvidia-xconfig --query-gpu-info

nvidia-smi            # 查看显卡驱动状态
modinfo nvidia        # nvidia.ko 模块信息
lsmod | grep nouveau  # xorg 开源显卡驱动
lsmod | grep nvidia   # 显示已加载显卡模块

dkms status           # 显示动态内核模块列表
modprobe nvidia       # [添加或删除]内核模块

# 查看 NVIDIA 显卡驱动信息
modinfo nvidia | grep license   # NVIDIA 闭源, 否则开源 open 内核
cat /proc/driver/nvidia/version # 驱动版本及编译时间以及 GCC 版本
```

## 安装 NVIDIA 显卡驱动

- 英伟达驱动下载 https://www.nvidia.com/Download/index.aspx
- Linux 版桌面驱动 https://www.nvidia.com/en-us/drivers/unix
- 英伟达 LTS 版驱动 https://docs.nvidia.com/datacenter/tesla/index.html

- NvidiaCodeNames https://nouveau.freedesktop.org/CodeNames.html
- `-open` 内核驱动 https://download.nvidia.com/XFree86/Linux-x86_64
- 英伟达开源内核模块 https://github.com/NVIDIA/open-gpu-kernel-modules

- 英伟达显卡论坛 https://forums.developer.nvidia.com/c/gpu-graphics/linux/148
- https://forums.developer.nvidia.com/t/current-graphics-driver-releases/28500

- https://ubuntu.com/server/docs/nvidia-drivers-installation
- https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa
- https://download.nvidia.com/XFree86/Linux-x86_64/550.67/README/kernel_open.html

```bash
# 显示设备驱动列表
ubuntu-drivers list
ubuntu-drivers devices

# 显示已经安装的 nvidia 软件包
apt list --installed '*nvidia*'

# 查看 NVIDIA 驱动软件包信息
apt policy nvidia-driver-550                # NVIDIA 显卡驱动
apt policy nvidia-dkms-550                  # 内核模块(DKMS 签名)
apt policy linux-modules-nvidia-550-generic # 内核模块(Ubuntu 签名)

# 内核源码及专利驱动内核模块源码
ls -l /usr/src

# 显卡内核模块参数设置
grep nvidia /etc/modprobe.d/* /lib/modprobe.d/*

# 安全启动 + 英伟达显卡
# Step 1 - Enabled Secure Boot in UEFI/BIOS
# Step 2 - Sign Nvidia GPU Driver by reconfigure driver package
cat /etc/default/linux-modules-nvidia

######################################
# 安装 Ubuntu 签名的 NVIDIA 内核模块 #
######################################
sudo ubuntu-drivers install nvidia:550 # => nvidia-driver-550
ls -l /lib/modules/$(uname -r)/kernel/nvidia-550

# MOK => Machine Owner Key
ls -l /var/lib/shim-signed/mok/
# 新装内核触发 MOK 签名 NVIDIA 内核模块
ls -l /etc/kernel/header_postinst.d/

###################################
# 安装 MOK 签名的 NVIDIA 内核模块 #
###################################
sudo apt install nvidia-driver-550 nvidia-dkms-550
ls -l /var/lib/dkms/nvidia
ls -l /lib/modules/$(uname -r)/updates/dkms
```

## Q & A

- https://forums.developer.nvidia.com/t/understanding-nvidia-drm-modeset-1-nvidia-linux-driver-modesetting/204068/2

- Q: Ubuntu 22.04 HWE 内核(6.5)引发的驱动(535)问题

  ```bash
  # HWE 内核导致显卡/Wifi等驱动无法正常工作
  # 硬件 - Intel 集成显卡 + Nvidia RTX 3060 独立显卡
  # BIOS - 设置 Dynamic Graphic, 动态切换(混合模式)
  # Nvidia 驱动, 安装 nvidia-driver-535 nvidia-dkms-535

  # 安装 GA 内核, 禁用 HWE 功能
  sudo apt install linux-generic
  ```

- Q: 535 驱动无法正常启动或启动很慢

  ```bash
  # ubuntu-drivers-common 软件包中的 gpu-manager 的 bug 导致
  # https://github.com/canonical/ubuntu-drivers-common/tree/master/share/hybrid

  # 修复方式: 添加参数到 grub 内核参数
  sudo nano /etc/default/grub
  GRUB_CMDLINE_LINUX="nogpumanager"
  sudo update-grub
  reboot
  ```

- Q: `dkms status` 显示 WARNING! Diff between built and installed module!

  ```bash
  sudo dkms remove  --all   nvidia/535.161.07
  sudo dkms install --force nvidia/535.161.07 -k $(uname -r)
  sudo update-initramfs -u  # 更新内核启动镜像文件
  sync # 更新同步数据缓存到磁盘(可有可无)
  reboot
  ```

- Q: Unable to break cycle systemd-backlight@backlight:nvidia_0.service/start

  ```bash
  # https://wiki.archlinux.org/title/Backlight
  journalctl -b | grep -i "drm\|nvidia\|NVRM\|01:00.0"
  systemctl status systemd-backlight@backlight:nvidia_0.service

  # KDE Plasma v5.25 Bugfix -> Backlighthelper
  # https://invent.kde.org/plasma/powerdevil/-/commit/761fc8a4bf4bd70bcd9aca63fc67382c94ecf884

  # 背光驱动内核接口
  # https://www.kernel.org/doc/html/latest/gpu/backlight.html
  # - brightness         R/W, set the requested brightness level
  # - actual_brightness  RO, the brightness level used by hardware
  # - max_brightness     RO, the maximum brightness level supported
  # 关机后背光亮度存储位置
  # The backlight brightness is stored in /var/lib/systemd/backlight/

  cat /sys/class/backlight/nvidia_0/brightness
  cat /sys/class/backlight/intel_backlight/brightness

  echo 298 | sudo tee /sys/class/backlight/intel_backlight/brightness
  sudo bash -c "echo 248 > /sys/class/backlight/intel_backlight/brightness"

  systemctl cat nvidia-persistenced
  systemctl list-dependencies nvidia-persistenced

  systemctl cat systemd-backlight@:intel_backlight
  systemctl cat systemd-backlight@backlight:nvidia_0
  systemctl list-dependencies systemd-backlight@:intel_backlight
  systemctl list-dependencies systemd-backlight@backlight:nvidia_0

  # 1 => 创建 Drop-In Service 屏蔽/修复 Bug
  $ sudo systemctl edit nvidia-persistenced
  # 输入内容如下
  #   [Unit]
  #   DefaultDependencies=no
  # 保存(自动保存)

  # 2 => 修改后查看内容
  $ systemctl cat nvidia-persistenced.service
  # /usr/lib/systemd/system/nvidia-persistenced.service
  [Unit]
  Description=NVIDIA Persistence Daemon
  Wants=syslog.target
  StopWhenUnneeded=true
  Before=systemd-backlight@backlight:nvidia_0.service
  [Service]
  Type=forking
  ExecStart=/usr/bin/nvidia-persistenced --user nvidia-persistenced --no-persistence-mode --verbose
  ExecStopPost=/bin/rm -rf /var/run/nvidia-persistenced

  # /etc/systemd/system/nvidia-persistenced.service.d/override.conf
  [Unit]
  DefaultDependencies=no
  ```
