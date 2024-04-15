# Disk

- https://wiki.archlinux.org/title/Fstab
- https://wiki.archlinux.org/title/Parted
- https://wiki.archlinux.org/title/GPT_fdisk
- https://www.rodsbooks.com/gdisk/index.html

- https://wiki.debian.org/udev
- https://wiki.archlinux.org/title/Udev
- https://www.reactivated.net/writing_udev_rules.html
- https://wiki.archlinux.org/title/Persistent_block_device_naming

- http://storaged.org
- https://github.com/storaged-project/udisks
- https://wiki.archlinux.org/title/Udisks
- https://www.freedesktop.org/wiki/Software/udisks
- https://wiki.archlinux.org/title/Solid_state_drive
- https://wiki.archlinux.org/title/Solid_state_drive/NVMe

- `~/.config/kded_device_automounterrc`
  * `[System Settings] -> [Removable Storage] -> [Removable Devices]`
  * `/dev/disk/by-uuid/*` 替换 `/org/freedesktop/UDisks2/block_devices/*`

```shell
# => 内核支持(加载)的文件系统
modinfo ntfs
modinfo ntfs3
modinfo exfat

# => 查询硬盘信息
sudo blkid

sudo parted --list
cat /proc/partitions
sudo fdisk -l /dev/nvme0n1
sudo gdisk -l /dev/nvme0n1

lsblk --help
lsblk -f # lsblk -t
lsblk -o NAME,FSTYPE,LABEL,FSSIZE,FSUSE%,FSUSED,PARTLABEL,MOUNTPOINT  /dev/nvme0n1
lsblk -o NAME,FSTYPE,FSSIZE,FSUSE%,LABEL,UUID,PARTLABEL,PARTUUID      /dev/nvme0n1

udisksctl status
udisksctl info -b /dev/nvme0n1p3
udevadm info --name=/dev/nvme0n1p3
journalctl -b | grep "udisks daemon version"

# => 磁盘 I/O 监控
# http://guichaz.free.fr/iotop
sudo apt install iotop

# 内存及 SWAP 状态
free
cat /proc/swaps

# 避免频繁使用 SWAP 空间
# https://help.ubuntu.com/community/SwapFaq
# https://github.com/systemd/zram-generator

# swappiness 控制 RAM 数据转移到 SWAP 的倾向性(百分比)
# 0   -> 尽量避免将 RAM 数据转移到 SWAP 分区/文件
# 100 -> 尽量    将 RAM 数据转移到 SWAP 分区/文件
# 减小 swappiness 将提高系统性能(RAM 数据读取更快)
cat /proc/sys/vm/swappiness   # Ubuntu 默认值 60
sudo sysctl vm.swappiness=10  # 临时修改, 仅本次有效
# 永久性修改 => 添加 vm.swappiness=10
sudo nano /etc/sysctl.conf
```

## 磁盘布局: UEFI + 双硬盘 + 16GiB RAM + Arch & Ubuntu & Windows 11

- https://uapi-group.org/specifications/specs/boot_loader_specification

- 0 号硬盘 => Windows 11
  * 512 MiB   的 ESP   分区
  *  32 MiB   的 MSR   分区
  * 128 GiB   的 OS    分区, Windows 11 系统占用约 25%, 即 32 GiB
  * 128 GiB   的 APP   分区
  * ...
  *  10 GiB   的 swap  分区, Arch/Ubuntu 共享
  * SSD 磁盘的三级(用户级) OP 空间, 缩小可用 LBA 空间(新磁盘低级格式化 NS 调整)

- 1 号硬盘 => Arch & Ubuntu
  * 512 MiB   的 ESP    分区, 挂载点 `/efi`
  * 64 GiB    的 Arch   分区, 挂载点 `/`, KDE 桌面 Arch    占用约 25%, 即 16 GiB
  * 64 GiB    的 Ubuntu 分区, 挂载点 `/`, KDE 桌面 UbuntuK 占用约 25%, 即 16 GiB
  * 64 GiB    的 Home   分区, 挂载点 `/home`, 共享 `home/charlie` & `home/charles`
  * .. GiB    的 Wong   分区, 挂载点 `/me`, Ubuntu & Arch 共享热数据/代码工作空间
  * .. GiB    的 NTFS 格式的共享冷数据分区
  * SSD 磁盘的三级(用户级) OP 空间, 缩小可用 LBA 空间(新磁盘低级格式化 NS 调整)

## NVMe 固态磁盘

- https://www.kingston.com.cn/cn/blog/pc-performance/overprovisioning
- https://www.kingston.com.cn/cn/blog/pc-performance/difference-between-slc-mlc-tlc-3d-nand
- https://nvmexpress.org/open-source-nvme-management-utility-nvme-command-line-interface-nvme-cli
- https://semiconductor.samsung.com/cn/consumer-storage/support/faqs/internalssd-product-information

- 固态磁盘基本概念
  * WL(Wear leveling) 磨损平衡
  * __S.M.A.R.T.__ 全称 __Self-Monitoring Analysis & Reporting Technology__
  * 计算单位
    ```bash
    # KiB, MiB, GiB, TiB, PiB, EiB    1GB = 10^9 = 1,000,000,000 B
    # Kilo,Mega,Giga,Tera,Peta,Exa    1GiB= 2^30 = 1,073,741,824 B

    # 1 GB 约等于 0.93 GiB    128 GB 约等于 119.2
    # 16 GB 约等于 14.9 GiB    256 GB 约等于 238.4
    # 32 GB 约等于 29.8 GiB    512 GB 约等于 476.8
    # 64 GB 约等于 59.6 GiB   1024 GB 约等于 953.6
    ```
  * 固态硬盘 NAND Flash 闪存类型
    ```bash
    # 擦写次数寿命 SLC > MLC > TLC > QLC
    # SLC/单层式存储/1bit, MLC/多层式存储/2bit
    # TLC/三层式存储/3bit, QLC/四层式存储/4bit
    ```
  * 固态硬盘预留空间(OP)
    ```bash
    # OP 百分比 = (实际容量 - 用户容量)/用户容量
    # 存储颗粒矩阵二进制, 标称容量十进制, 差额等于一级 OP 大小约 7.37%
    ```

```bash
# NVMe SSD 固态磁盘管理
# https://github.com/linux-nvme/nvme-cli
sudo apt install nvme-cli
# 显示系统 NVMe 固态磁盘
sudo nvme list
# 检查 NVMe 控制器及支持的功能
sudo nvme id-ctrl --human-readable /dev/nvme0

sudo apt install smartmontools
# 检查 NVMe 健康状态 S.M.A.R.T. 信息
sudo nvme smart-log /dev/nvme0

# 显示 S.M.A.R.T. 错误日志信息
sudo smartctl -l error /dev/nvme0
# 等同于 '-H -i -c -A -l error'
sudo smartctl --all /dev/nvme0
# -H Prints the health status of the device
# -i 显示设备 model & serial 码及固件版本等
# -c Prints only the generic SMART capabilities
# -A Prints only the vendor specific SMART Attributes
sudo smartctl -i /dev/nvme0

# 检查 firmware 日志
sudo nvme fw-log    /dev/nvme0
# 显示 NVMe 错误日志
sudo nvme error-log /dev/nvme0
```
