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
