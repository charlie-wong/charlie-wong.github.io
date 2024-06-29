# FAQs

- CMake + ninja 支持彩色编译信息显示
  * https://gitlab.kitware.com/cmake/cmake/-/issues/15502
  * `CMAKE_COLOR_MAKEFILE` default **ON** for `Unix Makefiles`

- `grep --exclude-from=FILE ...`
  * https://stackoverflow.com/questions/41702134
  * 不是排除 FILE, 而是排除 FILE 文件中每行指定的文件

- C 家族编译链接及库
  ```bash
  # 编译选项设置
  CFLAGS=
  CXXFLAGS=

  # 指定目标平台
  gcc -m32 geek.c -o geek
  gcc -m64 geek.c -o geek
  export ARCHFLAGS="-arch x86_64"
  export ARCHFLAGS="-arch $(uname -m)"

  # 静态库搜索路径 LIBRARY_PATH
  gcc -shared -fPIC -o libfoo.so foo.c
  gcc -o main main.c -I/path/to/foo -L/path/to/foo -lfoo
  LIBRARY_PATH=/path/to/foo gcc -o main main.c -I/path/to/foo -lfoo

  # 动态库搜索路径 LD_LIBRARY_PATH
  # -> 修改 /etc/ld.so.conf 文件，然后 `ldconfig` 更新使之生效
  # -> '-Wl,-rpath=LibPath'  表示将 LibPath 信息写入二进制文件
  man ldconfig; ldconfig -p

  # Colored GCC warnings and errors
  # https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Message-Formatting-Options.html
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
  ```
