# Kernel Related Hooks

- 内核镜像<安装>**前** 触发 `/etc/kernel/preinst.d/*`
- 内核镜像<安装>**后** 触发 `/etc/kernel/postinst.d/*`
- 内核镜像<安装>**时** 触发 `/etc/kernel/install.d/*`
- 内核镜像<卸载>**前** 触发 `/etc/kernel/prerm.d/*`
- 内核镜像<卸载>**后** 触发 `/etc/kernel/postrm.d/*`

- 内核头文件<安装>**后** 触发 `/etc/kernel/header_postinst.d/*`

- https://manpages.debian.org/buster/initramfs-tools-core/initramfs-tools.7.en.html
  * 查看软件包包含的文件 `apt-file list initramfs-tools`
  * 命令手册 `man initramfs-tools` 和 `man update-initramfs`

  * Hook配置文件 `/usr/share/initramfs-tools/conf-hooks.d/`
  * Hook脚本位置1 `/etc/initramfs-tools/hooks/`
  * Hook脚本位置2 `/usr/share/initramfs-tools/hooks/`

  * Boot脚本位置1 `/etc/initramfs-tools/scripts/`
  * Boot脚本位置2 `/usr/share/initramfs-tools/scripts/`
