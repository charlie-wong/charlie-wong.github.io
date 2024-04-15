# Wayland & Xorg

- https://wiki.archlinux.org/title/Xorg
- https://wiki.archlinux.org/title/Wayland

- https://wiki.archlinux.org/title/HiDPI
- https://winaero.com/find-change-screen-dpi-linux

- https://gitlab.freedesktop.org/xorg/xserver/-/issues/1241

```shell
# Linux 图形系统
echo ${XDG_SESSION_TYPE}
# 结果 x11        正在使用 Xorg
# 结果 wayland    正在使用 Wayland

# Check Your Current Xorg Version
dpkg -l | grep xserver-xorg-core

# Verify Physical Monitor Dimensions Detected by X Server
xdpyinfo | grep -B 2 resolution

# Calculate Right DPI Value
xrandr | grep -w connected
```
