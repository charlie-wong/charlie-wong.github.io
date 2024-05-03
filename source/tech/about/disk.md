# Disk

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

```bash
# => 内核支持(加载)的文件系统
modinfo ntfs; modinfo ntfs3; modinfo exfat

# => 查询硬盘信息
sudo blkid; sudo parted --list; cat /proc/partitions

sudo fdisk -l /dev/nvme0n1; udisksctl status
sudo gdisk -l /dev/nvme0n1; udisksctl info -b /dev/nvme0n1p3

udevadm info --name=/dev/nvme0n1p3
journalctl -b | grep "udisks daemon version"

lsblk --help; lsblk -f; lsblk -t; df -h; findmnt;
lsblk -o NAME,FSTYPE,LABEL,FSSIZE,FSUSE%,FSUSED,PARTLABEL,MOUNTPOINT  /dev/nvme0n1
lsblk -o NAME,FSTYPE,FSSIZE,FSUSE%,LABEL,UUID,PARTLABEL,PARTUUID      /dev/nvme0n1

# => 磁盘 I/O 监控
# http://guichaz.free.fr/iotop
sudo apt install iotop
```

## 关于 Linux 的 SWAP 虚拟内存交换

- https://wiki.archlinux.org/title/Fstab
- https://help.ubuntu.com/community/SwapFaq
- https://github.com/systemd/zram-generator

  ```bash
  # 内存及 SWAP 状态
  free; cat /proc/swaps

  # swappiness 控制 RAM 转移到 SWAP 的倾向性(百分比)
  #     0   -> 尽量避免将 RAM 数据转移到 SWAP
  #     100 -> 尽量    将 RAM 数据转移到 SWAP
  # 减小 swappiness 将提高系统性能(RAM 数据读取更快)
  cat /proc/sys/vm/swappiness   # Ubuntu 默认值 60
  sudo sysctl vm.swappiness=10  # 临时修改, 仅本次有效

  # 永久性修改 => 添加 vm.swappiness=10
  sudo nano /etc/sysctl.conf
  ```

## 磁盘布局: UEFI + 双硬盘 + 16GiB RAM + Arch & Ubuntu & Windows 11

- https://www.rodsbooks.com/gdisk/advice.html
- https://uapi-group.org/specifications/specs/boot_loader_specification
- https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-7/dd744301(v=ws.10)

- **Win 11 23H2 22631.2506** 安装好后系统分区占用 `12 GiB`
- 查询 TPM2.0 安全芯片信息 `Win+R` 运行输入 `tpm.msc` 命令

- 512B/sector, 2048-sector(1MiB) 对齐, 即分区 LBA 对齐最小单位
- 固态低级格式化调整 NS(命名空间), 末尾保留三级(用户级) OP 空间

  ```bash
# /dev/disk/by-uuid, label, partlabel, partuuid
# 4KiB =>    8-扇区 =    8 * 512 =    4 * 1024 Byte
# 1MiB => 2048-扇区 = 2048 * 512 = 1024 * 1024 Byte

cat /proc/swaps; cat /proc/sys/vm/swappiness; sudo sysctl vm.swappiness=10

sudo mkdir /me; sudo chown ${USER}:${USER} /me; chmod 0766 /me
sudo mkdir /me; sudo chown ${USER} /me; sudo chgrp ${USER} /me; chmod 0766 /me

# 名词解释
#   MBR => Master Boot Record     MSR   => Microsoft Reserved Partition
#   GPT => GUID Partition Table   WinRE => Windows Recovery Environment
#   ESP => EFI System Partition   UEFI  => Unified Extensible Firmware Interface
# GPT 磁盘分区已注册 GUID 的含义
#   MSR 类型分区 GUID => E3C9E316-0B5C-4DB8-817D-F92DF00215AE
#   微软动态磁盘 GUID => 5808C8AA-7E8F-42E0-85D2-E1E90434CFB3

# => 0 号固态硬盘 Arch & Ubuntu
#                   大小      分区名(Label)   PartLabel    挂载点
# nvme0n1p1/vfat   768 MiB    LESP            IsESP        /boot/efi
#                  255 MiB    未分配保留空间
# nvme0n1p2/ext4    64 GiB    Arch            IsArch       /        Arch + KDE 初始约 20GiB
#                    8 GiB    未分配保留空间
# nvme0n1p3/ext4    64 GiB    Ubuntu          IsUbuntu     /        KUbuntu 初始系统约 20GiB
#                    8 GiB    未分配保留空间
# nvme0n1p4/ext4   256 GiB    Wong            xWong        /me      热数据/工作空间
#                   32 GiB    未分配保留空间
# nvme0n1p5/NTFS   420 GiB    Charles         xCharles     用户冷数据存储中心
#                   78 GiB    用户级 OP 空间               需固态磁盘驱动的支持
# => 1 号固态硬盘 Windows 11
#                    大小     分区名(Label)   PartLabel    备注
# nvme1n1p1/vfat  768 MiB     WESP            WinESP
# nvme1n1p2/MSR   255 MiB                     WinMSR       微软保留空间
# nvme1n1p3/NTFS  128 GiB     OS              WinOS        Win 11 约占 25% (38GiB)
#                  16 GiB     未分配保留空间
# nvme1n1p4/NTFS  128 GiB     APP             WinApp       应用安装
#                  32 GiB     未分配保留空间
# nvme1n1p5/NTFS  ... GiB     Work            xWork        热数据/工作空间
# nvme1n1p6/swap   16 GiB     Swap            IsSwap       非同磁盘减少 IO 竞争
#                 ... GiB     用户级 OP 空间               需固态磁盘驱动的支持

cat /proc/mounts;        cat /etc/mtab
sudo blkid;              sudo gdisk -l /dev/nvme0n1
sudo parted --list;      sudo parted   /dev/nvme0n1p3 print

# 显示/设置 ext2/ext3/ext4 文件系统分区的 Label
sudo e2label /dev/nvme0n1p3           # 显示 Label
sudo e2label /dev/nvme0n1p3 Ubuntu    # 设置 Label
sudo tune2fs –L Ubuntu /dev/nvme0n1p3 # 设置 Label
# 显示/设置 NTFS 文件系统分区的 Label
sudo ntfslabel /dev/nvme1n1p6         # 显示 Label
sudo ntfslabel /dev/nvme1n1p6 WINRE   # 设置 Label
# 显示/设置 swap 文件系统分区的 Label
sudo swaplabel /dev/nvme0n1p2         # 显示 Label
sudo swaplabel /dev/nvme0n1p2 -L Swap # 设置 Label
  ```

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

    #  1 GB 约等于 0.93 GiB    128 GB 约等于 119.2
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

## 查看文件系统信息

NTFS/FAT32 格式化时的**分配单元大小**表示 block-size

块(簇)大小是文件保存时实际占用的最小存储单位, 例如若在块(簇)大小为 8KiB 的文件系统中保存实际
大小为 9KiB 的文件时, 则文件会被分割为两份: 8KiB 和 1KiB, 即此文件保存时占用两个块, 第 2
个 8KiB 的块实际存储有效数据 1KiB, 浪费 7KiB

- 查看 NTFS 格式磁盘的簇大小
  1. 以管理员身份打开 PowerShell
  2. 查看 D 盘命令 `fsutil fsinfo ntfsinfo D:`

- 查看 EXT4 格式磁盘的块大小
  ```bash
  stat /
  stat path/to/test.txt
  debugfs /dev/sda1
  sudo dumpe2fs -h /dev/sda1
  blockdev --getbsz /dev/sda1

  fdisk -l /dev/sda1
  gdisk -l /dev/sda1

  tune2fs -l /dev/sda1
  ```

- GPT 磁盘格式分区表的结构
  * https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout
  * https://uefi.org/specs/UEFI/2.10/05_GUID_Partition_Table_Format.html
  * GPT 格式分区表的结构
    ```bash
    # LBA0   保护性 MBR
    # LBA1   主 GPT 头部
    # LBA2   分区表 1,2,3,4
    # LBA3   分区表 5,6,7,8
    # ...
    # LBA34 分区表 125,126,127,128
    # LBA35 用户数据分区
    # ...

    # 查看磁盘的首个扇区(512Byte)数据, 即 MBR 数据
    dd if=/dev/sda1 bs=512 skip=0 | hexdump -C
    # 查看 GPT 磁盘的分区表头部(512字节)
    dd if=/dev/sda1 bs=512 skip=1 | hexdump -C
    # 查看 GPT 磁盘的前四个分区(512)
    dd if=/dev/sda1 bs=512 skip=2 | hexdump -C
    ```
