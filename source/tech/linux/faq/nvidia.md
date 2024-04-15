# Nvidia 显卡(NVIDIA GeForce RTX 3060 Laptop GPU GA106M)

- https://www.techpowerup.com/vgabios
- https://wiki.archlinux.org/title/GPGPU
- https://wiki.archlinux.org/title/NVIDIA

- 英伟达文档 https://docs.nvidia.com
- 驱动下载 https://www.nvidia.com/Download/index.aspx
- Unix 驱动 https://www.nvidia.com/en-us/drivers/unix/
- 开源内核模块 https://github.com/NVIDIA/open-gpu-kernel-modules
- NvidiaCodeNames https://nouveau.freedesktop.org/CodeNames.html
- https://docs.nvidia.com/dgx/dgx-os-6-user-guide/introduction.html
- 论坛 & FAQs https://forums.developer.nvidia.com/c/gpu-graphics/linux/148
- https://forums.developer.nvidia.com/t/current-graphics-driver-releases/28500
- `-open` 驱动 https://download.nvidia.com/XFree86/Linux-x86_64/535.86.05/README/

```bash
# 查看屏幕可用分辨率
xrandr
# 查看当前分辨率
xrandr | grep '*'
xdpyinfo | grep 'dimensions:'

# 查看显卡硬件信息
lspci -nn | grep -A 3 -i VGA
lspci -k  | grep -A 3 -i VGA
sudo lshw -numeric -C display

cat "/proc/driver/nvidia/gpus/0000:01:00.0/information"
# IRQ: 189 - kernel-6.5.0
# IRQ: 191 - kernel-5.15.0

cat /var/log/Xorg.0.log | grep "PCI:"
# PCI:*(1@0:0:0) 10de:2560:17aa:3ae8 rev 161 ...

# 设置显卡工作模式
prime-select query           # 显示显卡工作模式
sudo prime-select on-demand  # 按需选择
  cat /lib/modprobe.d/nvidia-runtimepm.conf
  # options nvidia "NVreg_DynamicPowerManagement=0x02"
sudo prime-select intel      # 选择 Intel  显卡
sudo prime-select nvidia     # 选择 Nvidia 显卡
sudo nvidia-settings         # 显卡图形设置面板

# 查看显卡驱动信息
nvidia-smi            # 显示当前驱动状态信息

modinfo nvidia        # nvidia.ko 模块信息
lsmod | grep nvidia   # 显示已经加载显卡模块
lsmod | grep nouveau  # xorg 开源显卡驱动

dkms status           # 显示动态内核模块列表
modprobe nvidia       # [添加或删除]内核模块

# 显示当前显卡驱动版本
cat /proc/driver/nvidia/version
# 显示 NVIDIA 表示闭源, 否则开源 open 内核模块
modinfo nvidia | grep license

# 显示显卡型号及 GPU UUID
nvidia-debugdump --list
nvidia-xconfig --query-gpu-info

# 显卡内核模块参数设置
grep nvidia /etc/modprobe.d/* /lib/modprobe.d/*

# 安全启动 +  英伟达显卡
# Step 1 - Enabled Secure Boot in UEFI/BIOS
# Step 2 - Sign Nvidia GPU Driver by reconfigure driver package
cat /etc/default/linux-modules-nvidia

# 显示设备驱动
ubuntu-drivers list
ubuntu-drivers devices

# 内核源码及专利驱动内核模块源码(部分或头文件)
ls /usr/src

# 显示已经安装的 nvidia 软件包
apt list --installed '*nvidia*'

# 查看软件包信息
apt-cache policy nvidia-driver-535                  # 显卡驱动
apt-cache policy nvidia-dkms-535                    # 内核模块(DKMS 签名)
apt-cache policy linux-modules-nvidia-535-generic   # 内核模块(Ubuntu 签名)

# https://ubuntu.com/server/docs/nvidia-drivers-installation
# https://download.nvidia.com/XFree86/Linux-x86_64/535.161.07/README/kernel_open.html
#
# Ubuntu 签名 Nvidia 内核模块
# -> /lib/modules/内核版本-generic/kernel/nvidia-535/nvidia.ko
sudo ubuntu-drivers install nvidia:535 # => nvidia-driver-535
#
# MOK => Machine Owner Key
#     => /var/lib/shim-signed/mok/
# 创建/导入 MOK, 签名 Nvidia 内核模块
# 新内核触发 => /etc/kernel/header_postinst.d/dkms
# -> /var/lib/dkms/nvidia/535.161.07/内核版本-generic/x86_64/module/
# -> /lib/modules/内核版本-generic/updates/dkms/nvidia.ko
sudo apt install nvidia-driver-535 nvidia-dkms-535
```

# Q & A

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

  # 创建 systemd Drop-In Service 进行 Bug 修复
  sudo systemctl edit nvidia-persistenced # 内容如下
  # [Unit]
  # DefaultDependencies=no
  systemctl cat nvidia-persistenced
  systemctl cat systemd-backlight@:intel_backlight
  systemctl cat systemd-backlight@backlight:nvidia_0
  systemctl list-dependencies nvidia-persistenced
  systemctl list-dependencies systemd-backlight@:intel_backlight
  systemctl list-dependencies systemd-backlight@backlight:nvidia_0
  ```
