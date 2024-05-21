# Linux Kernel FAQs

- https://www.etallen.com/cpuid.html
- https://wiki.archlinux.org/title/Microcode
- https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files

  * `apt show amd64-microcode`
  * `apt show intel-microcode`
  * `cat /proc/cpuinfo` or `lscpu`
  * `journalctl -k | grep microcode`
  * `sudo apt install intel-microcode iucode-tool`
  * `lsinitramfs /boot/initrd.img-$(uname -r) | grep microcode`

- https://wiki.archlinux.org/title/Kernel_parameters
- https://docs.kernel.org/admin-guide/kernel-parameters.html

```bash
# 当前内核启动参数
cat  /proc/cmdline

sudo nano /etc/default/grub
# vendor - use vendor driver, e.g. thinkpad_acpi
# video  - use the ACPI video.ko driver
# native - use the device's native backlight mode
GRUB_CMDLINE_LINUX_DEFAULT="... acpi_backlight=vendor"

# 修改 grub 设置后执行
sudo update-grub
```

# Kernel Log

```bash
# 本次内核启动日志
sudo cat /var/log/boot.log

# 搜索当前内核日志
sudo dmesg | grep NVRM
sudo dmesg | grep 0000:01:00.0
sudo dmesg | grep -A 10 -B 10 ERROR

# 显示本次启动时内核产生的错误警告信息
journalctl -p err..alert -b
# 清空内核日志
sudo journalctl --rotate --vacuum-time=1s
```

# Devices

```bash
lspci -k  # PCI 设备
lsusb -nn # PCI 设备 ID
lsusb -v  # USB 接口设备

sudo lshw | grep -A15 -i network

# bitmap logo built into kernel and shown on boot when framebuffer available
# - enabled by compiling with CONFIG_LOGO
# - resides in source tree `drivers/video/logo/`
cat /boot/config-$(uname -r) | grep CONFIG_LOGO
```
