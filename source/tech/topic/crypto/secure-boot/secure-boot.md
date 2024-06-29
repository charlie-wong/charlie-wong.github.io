# Secure Boot

- https://www.rodsbooks.com/efi-bootloaders/index.html
- https://www.rodsbooks.com/efi-bootloaders/secureboot.html
- https://wiki.archlinux.org/title/Boot_loader
- https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface

- https://github.com/rhboot/shim
- https://wiki.debian.org/SecureBoot
- https://wiki.ubuntu.com/UEFI/SecureBoot

- https://docs.kernel.org/admin-guide/module-signing.html
- https://www.kernel.org/doc/html/latest/kbuild/kbuild.html

```bash
# 安全启动工具
apt show efitools
apt show sbsigntool

# 查看内核密钥(公钥/证书)
cat /proc/keys
# systemd-boot
sudo bootctl # 显示启动参数
# 关于 Secure Boot 的启动日志
sudo dmesg | grep -i secure

mokutil --sb-state                    # 显示 UEFI 安全启动状态
mokutil --list-enrolled               # 显示已导入 BIOS 中的 MOK
mokutil --test-key path/to/mok.der    # 检测证书是否已经导入 UEFI/BIOS

sudo mokutil --import path/to/mok.der # 导入 MOK 证书
# 输入 one-time 密钥(删除此证书时亦需要此密码)
sudo mokutil --list-new               # 查看即将导入的 MOK
# 重启后输入 one-time 密码确认(导入)证书

mokutil --export                      # 导出 MokListRT 密钥到当前目录
sudo mokutil --delete ./MOK-0002.der  # 删除 MOK, 0002.der 是 export 的文件
sudo mokutil --list-delete            # 查看即将删除的 MOK
# 重启后输入 one-time 密码确认(删除)证书

# NOTE
# 2024/04/09 安全启动的 MokListRT 仅支持导入 RSA/2048 算法
# 建议: 创建 MOK 签名证书的私钥时不设密码(方便后续自动更新

# 自动签名更新后的内核模块, 设置签名使用的证书及私钥
cat /etc/dkms/framework.conf # dkms 配置文件
mok_signing_key="/var/lib/shim-signed/mok/MOK.priv" # 默认值(私钥)
mok_certificate="/var/lib/shim-signed/mok/MOK.der"  # 默认值(证书)
sign_tool="/etc/dkms/sign_helper.sh" # 默认签名工具

# 自动生成的 MOK 签名密钥
ls /var/lib/shim-signed/mok/ # Ubuntu 自动生成的 MOK 默认位置
openssl x509 -in /var/lib/shim-signed/mok/MOK.der -noout -text

# Linux 内核及模块(文件位置可能随发行版而变化)
KERNEL_VERSION="$(uname -r)"
KERNEL_SHORT_VERSION="$(uname -r | cut -d . -f 1-2)"
KERNEL_KBUILD_DIR=/usr/lib/linux-kbuild-${KERNEL_SHORT_VERSION}
cat /etc/dkms/sign_helper.sh
# $1 表示内核版本号 $2 表示等待签名的内核模块文件
# 内核签名工具 scripts/sign-file  签名哈希算法 sha256, sha512, ...
# 私钥 /path/to/MOK.priv  证书(DER二进制格式) /path/to/MOK.der
# /lib/modules/"$1"/build/scripts/sign-file sha512 /path/to/MOK.priv /path/to/MOK.der "$2"

KERNEL_MODULES_DIR=/lib/modules/${KERNEL_VERSION}/misc         # Oracle
KERNEL_MODULES_DIR=/lib/modules/${KERNEL_VERSION}/updates/dkms # Debian 系列

# 查看内核镜像签名状态
sudo sbverify --list /boot/vmlinuz-$(uname -r)
# image signature issuers:
#  - /C=GB/ST=Isle of Man/L=Douglas/O=Canonical Ltd./CN=Canonical Ltd. Master Certificate Authority
# image signature certificates:
#  - subject: /C=GB/ST=Isle of Man/O=Canonical Ltd./OU=Secure Boot/CN=Canonical Ltd. Secure Boot Signing (2022 v1)
#     issuer: /C=GB/ST=Isle of Man/L=Douglas/O=Canonical Ltd./CN=Canonical Ltd. Master Certificate Authority

# 用指定(私钥 & 证书)签名(内核镜像)
sudo sbsign --key /path/to/MOK.priv --cert /path/to/MOK.der \
  "/boot/vmlinuz-${KERNEL_VERSION}"  --output "/boot/vmlinuz-${KERNEL_VERSION}.tmp"
sudo mv "/boot/vmlinuz-${KERNEL_VERSION}.tmp" "/boot/vmlinuz-${KERNEL_VERSION}"

# 用指定(私钥 & 证书)签名(内核模块)
export KERNEL_MOD_SIGN_PASSWORD=123 # 私钥密码
sudo --preserve-env=KERNEL_MOD_SIGN_PASSWORD \
  "${KERNEL_KBUILD_DIR}"/scripts/sign-file sha256 \
  /path/to/MOK.priv /path/to/MOK.der vboxdrv.ko # 签名 VirtualBox 模块

# 更新 /boot/ 目录下的内核启动文件
# 工具配置文件 /etc/initramfs-tools/update-initramfs.conf
# -u              表示更新已存在的相关文件
# -k all          更新 /boot/ 下所有的内核
# -k $(uname -r)  仅更新当前正在运行的内核
sudo update-initramfs -k all -u

modinfo vboxdrv # 查看内核模块信息
```

# Secure Boot Well-known Publick Keys

- 签名信息验证 `$ sbverify --cert keys/refind.crt refind/refind_x64.efi`
- rEFInd 公钥收集 https://sourceforge.net/p/refind/code/ci/master/tree/keys

- [well-known-keys/debian-uefi-ca.der](https://salsa.debian.org/efi-team/shim/-/blob/master/debian/debian-uefi-ca.der)
  Debian UEFI CA cert is the root of trust, with extra public
  [binaries signing keys](https://salsa.debian.org/ftp-team/code-signing/-/tree/master/etc)

- [well-known-keys/canonical-uefi-ca.der](https://salsa.debian.org/efi-team/shim/-/blob/master/debian/canonical-uefi-ca.der)
  Canonical public key used to sign Ubuntu boot loader and kernel, enrolled as MOK

- `well-known-keys/microsoft-kekca-public.cer` -- Microsoft's key exchange key (KEK), which
  is present on most UEFI systems with Secure Boot. The purpose of
  Microsoft's KEK is to enable Microsoft tools to update Secure Boot
  variables. There is no reason to add it to your MOK list.

- `well-known-keys/microsoft-pca-public.cer` -- A Microsoft public key, matched to the one
  used to sign Microsoft's own boot loader. You might include this key in
  your MOK list if you replace the keys that came with your computer with
  your own key but still want to boot Windows. There's no reason to add it
  to your MOK list if your computer came this key pre-installed and you did
  not replace the default keys.

- `well-known-keys/microsoft-uefica-public.cer` -- A Microsoft public key, matched to the one
  Microsoft uses to sign third-party applications and drivers. If you
  remove your default keys, adding this one to your MOK list will enable
  you to launch third-party boot loaders and other tools signed by
  Microsoft. There's no reason to add it to your MOK list if your computer
  came this key pre-installed and you did not replace the default keys.
