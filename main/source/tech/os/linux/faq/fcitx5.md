# 中文输入法 [Fcitx5](https://github.com/fcitx/)

Fcitx5 基本分三部内容: _主程序_, _语言引擎(IM)_, _图形化配置程序_,
KDE 系统设置界面/设置输入法 => 添加 pinyin 后再次 login 即可生效

```bash
apt depends fcitx5
apt list --installed | grep fcitx5

sudo apt install fcitx5 # 输入法核心程序包
sudo apt install kde-config-fcitx5 # KDE 桌面集成
sudo apt install fcitx5-chinese-addons # 中文模块

# 方式一: KDE 系统输入法设置界面
# 方式二: 启动输入法配置程序命令
im-config

# 中文标点符号映射表
# - 修改后重启 Fcitx5 或再次 login 生效
# - 小键盘区的 + - * / 按键无法触发映射效果
cat /usr/share/fcitx5/punctuation/punc.mb.zh_CN
```
