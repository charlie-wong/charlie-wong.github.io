# Network & Wifi

- https://wiki.archlinux.org/title/Network_configuration/Wireless
- https://help.ubuntu.com/community/WifiDocs/WirelessCardsSupported
- https://help.ubuntu.com/community/WifiDocs/WirelessTroubleShootingGuide/Drivers

```bash
# 查看本机网卡/IP信息
ip addr

# 查询本机公网 IP 地址
curl http://ip.sb
curl https://cip.cc
curl https://ipinfo.io        # GitHub 项目
curl https://ifconfig.io      # GitHub 项目
curl https://ident.me
curl https://ifconfig.me
curl https://myip.ipip.net
curl https://httpbin.org/ip
```

# DNS

```bash
# 系统 DNS 配置文件
cat /etc/resolv.conf

# 查看当前系统 DNS 服务器信息
resolvectl status

# DNS 查询域名地址
dig      github.com
nslookup github.com
```
