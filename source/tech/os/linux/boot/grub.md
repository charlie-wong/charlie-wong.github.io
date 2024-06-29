# Grub

- https://www.gnu.org/software/grub
- https://www.gnu.org/software/grub/manual/grub/grub.html

- [Linux Kernel Command-line Parameters](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)

  * https://wiki.archlinux.org/title/Kernel_parameters
  * `quiet`   kernel start-up parameter, disable most log messages
  * `splash`  causes boot screen to be shown, it's NOT kernel option

  * FAQ https://unix.stackexchange.com/questions/676118
    If the kernel does not recognize a boot option, it does not cause an error,
    the unknown parameter will have no effect to kernel, other than being listed
    in `/proc/cmdline` file. Whereafter initramfs-scripts or userspace-programs
    can look/check/use the parameters to modify their behavior respectively.

```bash
# 检查当前版本
dpkg -l | grep grub

# 命令 update-grub 或 grub-mkconfig 配置文件
cat /etc/default/grub

# 自定义 Grub 配置文件
ls /etc/grub.d/
```
