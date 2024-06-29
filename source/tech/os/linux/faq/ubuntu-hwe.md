# Ubuntu LTS 内核

- https://wiki.ubuntu.com/Releases
- https://ubuntu.com/kernel/lifecycle
- https://ubuntu.com/about/release-cycle

```bash
uname -r        # 查看内核版本
lsb_release -a  # 查看 OS 版本

# HWE 功能使 22.04 后续发行版内核在 22.04 中可用
hwe-support-status # HWE(Hardware Enablement) 状态
```

## Ubuntu LTS 24.04 和内核相关的 Bugs

- __BUG__ kernel 6.8.x 无法正常关机/重启
  * 删除 snap 后, 安装 6.8.10-x64v3-xanmod1 关机/重启工作正常
  * https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2059738

- __BUG__ Kernel 6.6.x __iwlwifi__ AX211 Microcode SW error
  * 内核版本 > 6.7 已修复 __iwlwifi__ 崩溃重启问题
  * https://bugzilla.kernel.org/show_bug.cgi?id=217980

## 安装 LTS/Stable 内核

- https://xanmod.org
- https://www.kernel.org

- https://wiki.archlinux.org/title/Microcode
  *  Arch  包名 `intel-ucode` 和 `amd-ucode`
  * Ubuntu 包名 `intel-microcode` 和 `amd64-microcode`

- `linux-firmware` 内核驱动固件(商业/非开源设备驱动固件)
  * https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

```bash
apt --dry-run autoremove  # 模拟执行
apt search ^linux-generic # 搜索内核包
apt depends linux-generic # 内核包依赖

##################
# 标记为手动安装 #
##################
apt-mark --help
# https://github.com/intel/thermal_daemon
sudo apt-mark manual thermald           # 温度监控后台服务
# https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files
sudo apt-mark manual intel-microcode    # Intel CPU 微码(设计缺陷修复)
# 内核调试工具包
sudo apt-mark manual bpftrace    # https://github.com/bpftrace
sudo apt-mark manual bpfcc-tools # https://github.com/iovisor/bcc

######################################
# 安装当前 Ubuntu 发行版默认 GA 内核 #
######################################
sudo apt install linux-generic

# 搜索 XanMod 内核 v6.1.x 版本软件包
apt search "linux-image-6\\.1\\..*-x64v3-xanmod"

#######################################
# 通过 XanMod 元包安装内核(升级/更新) #
#######################################
sudo apt install linux-xanmod-x64v3 # stable 版
sudo apt install linux-xanmod-lts-x64v3 # LTS 版

# 安装版本固定的 XanMod 内核
sudo apt install linux-image-6.1.77-x64v3-xanmod1
sudo apt install linux-headers-6.1.77-x64v3-xanmod1
```

## 清理/删除无用内核

```bash
ls -l /boot/
ls -l /usr/src/
ls -l /lib/modules/

# 显示已安装内核软件包
apt list --installed 'linux-*'
apt list --installed '*-hwe-*'
apt list --installed 'linux-generic-*'

dpkg --list | grep linux-
dpkg --list | grep -Ei 'linux-generic|linux-image|linux-headers|linux-modules'

dpkg -l | grep '^rc' # 显示卸载软件包后仍残留的配置文件
dpkg -l | grep '^rc' | awk '{print $2}' | sudo xargs dpkg --purge

# 删除内核元包
apt policy linux-generic-hwe-24.04
apt depends linux-generic-hwe-24.04
sudo apt remove linux-generic-hwe-24.04

# 删除指定版本内核
sudo apt remove linux-image-6.8.0-31-generic
sudo apt remove linux-headers-6.8.0-31-generic

# 删除 Ubuntu HWE 内核相关包禁用 Ubuntu HWE 功能
sudo apt remove linux-{image,headers}-generic-hwe-'*'
```
