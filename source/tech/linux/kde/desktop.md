# KDE 桌面图标

桌面图标位置 `/usr/share/plasma/desktoptheme/`

## 开始菜单中的搜索服务

- Use `Alt` + `Space` keyboard shortcut to active KRunner
- `$HOME/.local/share/kservices5/searchproviders/`
- 系统默认提供的 .desktop 文件 `/usr/share/kservices5/searchproviders/`
- https://invent.kde.org/frameworks/kio/-/tree/master/src/urifilters/ikws/searchproviders

```bash
# $HOME/.local/share/kservices5/searchproviders/7digital.desktop
[Desktop Entry]
Hidden=true # 隐藏 `System Settings` -> `Search` -> `Web Search Keywords`
Type=Service
# $HOME/.local/share/kservices5/searchproviders/acronym.desktop
[Desktop Entry]
Type=Service
Name=Acronym Database
Query=https://www.abbreviations.com/\\{@}
Keys=abbr # 修改默认启动关键字
# ...
```
