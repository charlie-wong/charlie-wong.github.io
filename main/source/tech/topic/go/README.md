# [Go](https://github.com/golang) Language

- https://pkg.go.dev/cmd/go

  ```bash
  # GOOS    目标机器的操作系统, 候选值 linux, windows, darwin
  # GOARCH  目标机器处理器架构, 候选值 amd64, 386, arm, ppc64
  #         交叉编译(本地机器环境变量) GOHOSTOS 和 GOHOSTARCH

  # GOPATH
  # - 显示当前值命令 `go env GOPATH`
  # - 默认值 $HOME/go 或 %USERPROFILE%\go
  # - 冒号/Linux 或 分号/Windows 分割的多路径列表
  # - 列表中每个路径有固定目录结构: bin, src, pkg
  # - `go get` 下载的包保存到列表中第一个路径下的 src 目录
  # - `go install` 哪个路径找到就安装在与之对应的 bin 目录

  # 导入命令 `import` 搜索路径
  # - $GOROOT/src  保存 Go 标准库代码
  # - $GOPATH/src  应用源码及其依赖包

  # GO111MODULE  控制包管理模式 module-aware 或 GOPATH
  # - GO111MODULE=off   采用 GOPATH 模式进行包查找
  # - GO111MODULE=on    采用 module-aware 模式查找
  # - GO111MODULE=auto  默认值(依据当前目录内容决定)
  #   - 当前文件在包含 go.mod 文件的目录下, 则采用 module-aware 模式
  #   - 当前目录在 GOPATH/src 之外且包含 go.mod 文件, 则采用 module-aware 模式
  ```
