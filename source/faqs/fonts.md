# 字体设置

- 预览 https://typeof.net/Iosevka
- 镜像 https://mirrors.tuna.tsinghua.edu.cn/github-release/be5invis
- https://github.com/be5invis/Iosevka/blob/main/doc/PACKAGE-LIST.md
- https://github.com/be5invis/Sarasa-Gothic/blob/main/README.zh_CN.md

```bash
# Sarasa-v1.0.5 Release 2024-01-27
# Unhinted 表示无内嵌微调修饰的字体版本
# Mono & Term 等宽字体(基于 Iosevka 字型设计) + 连字特性(Ligation)

# 字体文件解压缩到 ~/.local/share/fonts 目录即可
7z l SarasaTermSC-TTF-1.0.5.7z # 显示压缩包文件列表
7z e SarasaMonoSC-TTF-1.0.5.7z SarasaMonoSC-Regular.ttf

# Sarasa      更纱黑体家族名称
# 字体风格
#   Term      紧凑等宽字型    Gothic    标准字型
#   Fixed     固定宽度字型    Mono      等宽字型
#   UI        专为界面设计
# 字形语言
#   SC 简体中文(大陆)   CL 古典字形
#   HC 繁体中文(香港)   K 韩语
#   TC 繁体中文(台湾)   J 日语

# 数字和字母笔画末端有无字体修饰线 Slab(有) & Sans(无)
# 字重(字体粗细)
#   Extralight  特细        Extralightitalic  特细斜体
#   Light       较细        Lightitalic       较细斜体
#   Regular     标准字重    Italic            标准斜体
#   Semibold    半粗        Semibolditalic    半粗斜体
#   Bold        粗体        Bold Italic       加粗斜体

fc-list :lang=zh -f '%{file}\n' # 仅显示文件名称
fc-cache -v ~/.local/share/fonts/ # -v 显示执行详情信息
fc-list :lang=zh # 显示系统可用中文字体, :lang="TwoLetterLanguageCode"
fc-match -s monospace:charset=1F4A9 # 等宽字体中搜索 Uniccode 指定字符
fc-query -f '%{fontversion} | %{family} | %{familylang} | %{style}\n' path/to/x.ttf
```

- `半角` 占一个字节: 半个字符的位置, 西文字母和标点符号
- `全角` 占两个字节: 一个字符的位置, 中文字符和标点符号
- `连字特性` 表示将 =>, !=, -> 等两个连续符号显示为类手写形式

- 中文字符系统: Em(全身)和En(半身)
- 西文字母系统: zenkaku/fullwidth(全角/全宽)和hankaku/halfwidth(半角/半宽)

## 关于 `fonts.conf` 配置文件

- `man fonts.conf`
- `man 5 fonts-conf`

- https://wiki.archlinux.org/title/Fonts
- https://wiki.archlinux.org/title/Font_configuration
- https://www.freedesktop.org/wiki/Software/fontconfig

- 字体配置标准文档(本地) `/usr/share/doc/fontconfig/fontconfig-user.html`
- https://www.freedesktop.org/software/fontconfig/fontconfig-user.html

| 配置文件 | 字体数据 |
| -------- | -------- |
| ~/.fonts.conf                      | ~/.fonts/              |
| ~/.fonts.conf.d/                   | ~/.local/share/fonts/  |
| ~/.config/fontconfig/conf.d/       | /usr/share/fonts/      |
| ~/.config/fontconfig/fonts.conf    |                        |
| /etc/fonts/conf.d/                 | ~/.cache/fontconfig/   |
| /etc/fonts/fonts.conf              | /var/cache/fontconfig/ |
| /etc/fonts/fonts.dtd               |                        |
