# apt

```bash
sudo apt autorclean
sudo apt autoremove

apt depends  nvidia-dkms-535
apt rdepends nvidia-dkms-535

# 搜索系统已经安装的软件包
apt list --installed *xx*

# Consider suggested packages as dependency
sudo apt install --install-suggests XXX
# Do not consider recommended packages as dependency
sudo apt install --no-install-recommends XXX

# ii – indicates packages that are currently installed
# iU – package has been unpacked and will be used next reboot
# rc – package already removed, but configuration still present
dpkg -l | grep '^rc' | awk '{print $2}'
dpkg -l | grep '^rc' | awk '{print $2}' | sudo xargs dpkg --purge
```

## 查看包依赖关系

- https://linuxsimply.com/linux-basics/package-management/dependencies/apt-dependency-tree

- 工具 `apt-cache`
  * `apt-cache showpkg <PKG>`
  * 正向依赖关系 `apt  depends --recurse --installed <PKG>`
  * 逆向依赖关系 `apt rdepends --recurse --installed <PKG>`

- 工具 `apt show debtree`
  * `sudo apt install debtree`
  * `debtree <PKG>`

- 工具 `apt show apt-rdepends`
  * https://www.sfllaw.ca/programs/
  * https://salsa.debian.org/debian/apt-rdepends

- 生产包依赖关系 PNG 图片
  * `sudo apt install graphviz`
  * `debtree <PKG> | dot > <PKG.dot>`
  * `dot -Tpng -o <PKG.png> <PKG.dot>`
