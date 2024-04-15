# `.git` 元数据目录结构及内容

- https://github.blog/2022-09-13-scaling-gits-garbage-collection
- https://github.blog/2022-08-29-gits-database-internals-i-packed-object-store

- https://git-scm.com/docs/gitignore
- https://git-scm.com/docs/repository-version
- https://git-scm.com/docs/gitrepository-layout

- https://git-scm.com/docs/pack-format
- https://github.blog/2023-06-01-highlights-from-git-2-41
- https://github.blog/2022-08-30-gits-database-internals-ii-commit-history-queries

- 关于 `.git/branches/` 目录 https://stackoverflow.com/questions/10398225
- 关于 `.git/description` 文件 https://iq.opengenus.org/git-description-file
- 关于 `.git/` 目录 https://iq.opengenus.org/exploring-git-folder-of-tensorflow

```text
.git/config             仓库级配置文件
.git/description        仓库简要描述/简介(gitweb)
.git/shallow            clone/fetch 时 --depth 参数

.git/HEAD               保存当前活动分支名或提交记录的哈希值
.git/ORIG_HEAD          保存 .git/HEAD 的值(git reset 命令更新)
.git/FETCH_HEAD         同步远程仓库记录(git fetch/pull 命令产生)
.git/COMMIT_EDITMSG     临时文件(保存最近 git commit 提交日志信息)

.git/refs/heads/trunk   本地的 trunk 分支
.git/refs/tags/v1.0.0   标签列表(每个文件保存相应哈希值)

.git/refs/remotes/远程名/分支名
.git/refs/remotes/origin/HEAD         远程仓库(origin)的默认分支
.git/refs/remotes/origin/trunk        远程仓库(origin)的 trunk 分支

.git/info/refs       执行 git update-server-info 或 git gc 等命令时生成(更新)
.git/info/grafts
.git/info/exclude    仓库级全局忽略模式, 参见配置选项 core.excludesFile

.git/logs/HEAD                  保存 .git/HEAD 的变更历史
.git/logs/refs/tags/*           保存 Tag 标签历史记录
.git/logs/refs/heads/*          保存(本地)分支变更记录
.git/logs/refs/remotes/*        保存(远程)分支变更记录

.git/modules/           保存 submodule 仓库
.git/hooks/             保存 git 回调脚本
.git/branches/          新版 git 基本不再使用

.git/packed-refs        git gc 命令压缩 .git/refs/* 产生(提高 IO 性能)
.git/index              修改已提交文件然后 git add 则更新此文件(二进制格式)

=> (哈希前缀(两字符) + 剩余值哈希) 构成 Objects 的完整哈希值(SHA1 或 SHA256)
=> 命令查看对象(内容)命令   git cat-file -p 哈希值
=> 命令查看对象(类型)命令   git cat-file -t 哈希值
   commit 类型表示提交记录, tree 类型描述提交记录树, blob 类型表示修改记录
   每个提交记录由 commit(对象) -> tree -> { tree & blob } 形成链式引用结构
   提交历史构成 commit(对象) -> commit(对象) -> ... commit(仓库初始提交记录)
   HEAD, refs/*, tags/* -> commit(对象) 提交记录命名引用(方便访问/管理/识别)
.git/objects/哈希前缀/剩余值哈希    执行 git add new-file 命令添加新文件时产生

.git/objects/info/alternates        共享其它仓库元数据
.git/objects/info/packs
.git/objects/info/commit-graph      提交历史快速索引的结构化数据

.git/objects/pack/pack-哈希A.rev    等同于 *.pack 内对象的存储序(内容 idx 内偏移量)
.git/objects/pack/pack-哈希A.idx    按 *.pack 内对象的哈希排序(内容 *.pack 内对象偏移量)
.git/objects/pack/pack-哈希A.pack   归档后的 reachable 对象压缩包

.git/objects/pack/pack-哈希X.rev
.git/objects/pack/pack-哈希X.idx
.git/objects/pack/pack-哈希X.pack   归档的 unreachable 对象压缩包
.git/objects/pack/pack-哈希X.mtimes 每个 unreachable 对象的 mtime
```

# `git clone ...` 获取远程仓库的内容

```text
.git/objects/pack/*   历史记录对象
.git/refs/remotes/*   各种命名引用

依据仓库设置初始化本地克隆仓库内容
.git/HEAD
.git/index
.git/config
.git/refs/tags/*
.git/refs/heads/*

其它的文件则复制本地模板或按需创建
```
