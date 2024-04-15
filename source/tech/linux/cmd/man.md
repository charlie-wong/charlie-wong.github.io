# Linux Man Pages

- https://www.baeldung.com/linux/man-pages-manual-install

- About [Linux Man Pages](https://www.man7.org/linux/man-pages/man7/man-pages.7.html) `man man-pages`
  * `/usr/share/man/man1/xxx.1.gz` user commands programs or scripts
  * `/usr/share/man/man2/xxx.2.gz` commands which wrap kernel functions
  * `/usr/share/man/man3/xxx.3.gz` commands which wrap library functions
  * `/usr/share/man/man4/xxx.4.gz` special files to access `/dev` devices
  * `/usr/share/man/man5/xxx.5.gz` human-readable formats and configuration
  * `/usr/share/man/man6/xxx.6.gz` games and funny programs available on system
  * `/usr/share/man/man7/xxx.7.gz` overview, conventions, and miscellaneous
  * `/usr/share/man/man8/xxx.8.gz` administration system management commands

- Extra search path for man pages by `MANPATH` environment variable
  * `manpath` 命令显示当前 Man Pages 搜索路径
  * __Debian__ 系列配置文件 `/etc/manpath.config`
  * 添加额外搜索路径(覆盖式) `export MANPATH=/path/to/folder`
  * 添加额外搜索路径(追加式) `export MANPATH=:/path/to/folder`

- Extra search path for man pages auto set based-on `PATH`
  * 条件1: 路径 __element__ 是 `PATH` 环境变量的值之一
  * 条件2: 配置文件 `/etc/manpath.config` 中未包含 `MANPATH_MAP element ...` 项
  * 则如下路径自动添加到 Man Pages 搜索路径, 注意: `manpath` 命令不显示这些路径
    - `element/man`
    - `element/share/man`
    - `element/../man`
    - `element/../share/man`
