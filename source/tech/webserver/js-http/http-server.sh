#!/usr/bin/env bash

# 启动本地命令 sh ./http-server.sh
# http-server.sh 所在目录需要有 index.html 文件，这样浏览器才能打开页面

# 使用 Python 的 http 模块, 启动 HTTP 服务，以当前目录作为根目录
python3 -m http.server 5555 # Ctrl + C 退出
