# journalctl

```bash
sudo dmesg -l err,warn

# 日志文件 /var/log/journal
# 配置文件 /etc/systemd/journald.conf

journalctl -b            # 当前启动日志
journalctl -b -1         # previous boot logs
journalctl --list­-boots  # 显示所有启动日志列表

journalctl _PID=1
jour­nalctl _UID=100

journalctl --no-pager ...
journalctl --since "20 min ago"
journalctl --sinc­e="2­021­-01-30 18:17:16"

# list logs for a specific systemd-unit
journalctl -u avahi-daemon # about DNS, apt package

# Log Priority
# 0=emerg    1=alert   2=crit  3=err
# 4=warn­ing  5=notice  6=info  7=debug
journalctl -p alert..err    # FROM..TO

# Shows disk usage of all(archived and active) journal files.
journalctl --disk-usage

# Clean up archived logs to get their disk space below 100 MB
sudo journalctl --vacu­um-­siz­e=100M # 单位 K, M, G, T
# Clean up archived logs so that it contains no data older than
# 有效单位 => s, m, h, days, months, weeks, years
sudo journalctl --vacuum-time=7d
sudo journalctl --vacu­um-­tim­e=2­weeks
# no more than specified number of separate journal files remain
sudo journalctl --vacuum-files=5
# 完全清空日志文件
sudo journalctl --rotate --vacuum-time=1s
```
