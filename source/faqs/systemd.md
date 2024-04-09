# systemd

- 关于 [udev](https://www.man7.org/linux/man-pages/man7/udev.7.html) 动态设备管理
  * 参考链接 https://unix.stackexchange.com/questions/333697
  * `/lib/udev/rules.d/*.rules` 软件包默认规则文件, 不建议直接修改
  * `/etc/udev/rules.d/*.rules` 用户定制的规则文件, 推荐修改或创建
  * 注意: `/etc` 下的 __x.rules__ 覆盖 `/lib` 下的同名文件 __x.rules__
  * 注意: 若 `/etc` 下的 __x.rules__ 是指向 `/dev/null` 的 symlink, 则表示禁用 `/lib` 下的 __x.rules__

```bash
# systemd 系统服务分析/调试
systemd-analyze time    # 显示内核空间服务耗时
systemd-analyze blame   # 显示服务初始化耗时

# 显示 foo.service 的依赖的服务内容
systemctl list-dependencies foo.service
systemctl list-dependencies --all foo.service
systemctl list-dependencies --reverse foo.service

# 修改/覆盖 foo.service 服务(Drop-In 配置)
sudo systemctl edit foo.service
# 创建 => /etc/systemd/system/foo.service.d/override.conf

# 修改后重新加载服务
systemctl daemon-reload

# 撤销 foo.service 服务(Drop-In 配置)
sudo systemctl revert 服务名
# 删除 => /etc/systemd/system/foo.service.d
```
