# [timeshift](https://github.com/linuxmint/timeshift)

```bash
# 系统恢复命令
sudo timeshift --list
sudo timeshift --list-devices
sudo timeshift \
  --restore \
  --skip-grub \
  --target /dev/nvme0n1p4 \
  --snapshot '2024-02-22_08-20-50'
```
