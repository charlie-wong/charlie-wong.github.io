# Ubuntu LTS Hardware Enablement

- https://wiki.ubuntu.com/Releases
- https://ubuntu.com/kernel/lifecycle
- https://ubuntu.com/about/release-cycle

```bash
# 查看内核版本
uname -r
# 查看 OS 版本
lsb_release -a

# Ubuntu 22.04 LTS Jammy Jellyfish, 默认开启 HWE
# HWE 功能使 22.04 后续发行版的内核在 22.04 中可用
hwe-support-status # HWE 支持状态
apt depends linux-generic-hwe-22.04
apt depends linux-image-generic-hwe-22.04

# 仅保留 LTS 内核版本
# https://www.kernel.org
# => LTS 5.15.151 @ 2024-03-06

# 安装当前发行版 GA 内核
apt depends linux-generic
sudo apt install linux-generic

# 清理无用内核, 删除 HWE 包(禁用 HWE 功能)
# NOTE 反复使用如下命令 => 检查/卸载/清理
ls /boot/
dpkg -l | grep '^rc'
apt list --installed '*-hwe-*'
apt policy linux-generic-hwe-22.04
dpkg --list | grep -Ei 'linux-image|linux-headers|linux-modules'
dpkg -l | grep '^rc' | awk '{print $2}' | sudo xargs dpkg --purge

sudo apt remove linux-generic-hwe-22.04
sudo apt remove linux-{image,headers}-generic-hwe-'*'
```
