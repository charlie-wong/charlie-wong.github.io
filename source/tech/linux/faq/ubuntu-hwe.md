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
  * https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2059738

- __BUG__ Kernel 6.6.x _iwlwifi_ AX211 Microcode SW error
  * https://bugzilla.kernel.org/show_bug.cgi?id=217980

## 安装 LTS/Stable 内核

- https://xanmod.org
- https://www.kernel.org

```bash
# 安装当前 Ubuntu 发行版默认 GA 内核
sudo apt install linux-generic

# CPU/固件包 intel-microcode, amd64-microcode, linux-firmware
apt search ^linux-generic # 搜索内核包
apt depends linux-generic # 内核包依赖

# 搜索 XanMod 内核 v6.1.x 版本软件包
apt search "linux-image-6\\.1\\..*-x64v3-xanmod"

# 通过 XanMod 元包安装内核(升级/更新)
sudo apt install linux-xanmod-x64v3 # stable 版
sudo apt install linux-xanmod-lts-x64v3 # LTS 版

# 安装固定版本的 XanMod 内核
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
