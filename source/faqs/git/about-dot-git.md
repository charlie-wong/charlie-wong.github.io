# About `.git`

- https://github.blog/2022-09-13-scaling-gits-garbage-collection
- https://github.blog/2022-08-29-gits-database-internals-i-packed-object-store

```text
.git/config             仓库级配置文件
.git/description        仓库简要描述/简介(gitweb)

.git/HEAD               保存当前分支名或提交的 SHA-1 哈希值
.git/ORIG_HEAD          保存 .git/HEAD 的值(git reset 命令更新)
.git/FETCH_HEAD         同步远程仓库记录(git fetch/pull 命令产生)
.git/COMMIT_EDITMSG     临时文件(保存 git commit 提交日志信息)

.git/refs/heads/trunk   本地的 trunk 分支
.git/refs/tags/v1.0.0   标签列表(每个文件保存相应哈希值)

.git/refs/remotes/远程仓库名/分支名
.git/refs/remotes/origin/HEAD         远程仓库(origin)的默认分支
.git/refs/remotes/origin/trunk        远程仓库(origin)的 trunk 分支

.git/info/exclude
.git/info/refs

.git/logs/HEAD                        保存 .git/HEAD 的变更历史
.git/logs/refs/heads/trunk            保存 trunk 分支的 HEAD 变更历史
.git/logs/refs/remotes/origin/HEAD

.git/hooks/                 保存 git 回调脚本
.git/branches/

.git/packed-refs            压缩 .git/refs/heads/* 和 .git/refs/tags/* 产生
.git/index                  修改已提交文件然后 git add 则更新此文件
.git/objects/哈希值/*       执行 git add new-file 命令添加新文件时产生

.git/objects/info/packs
.git/objects/info/commit-graph

.git/objects/pack/pack-哈希A.rev
.git/objects/pack/pack-哈希A.idx    哈希A.pack 内每个对象的偏移值
.git/objects/pack/pack-哈希A.pack   归档后的 reachable 对象压缩包

.git/objects/pack/pack-哈希X.rev
.git/objects/pack/pack-哈希X.idx    哈希X.pack 内每个对象的偏移值
.git/objects/pack/pack-哈希X.pack   归档的 unreachable 对象压缩包
.git/objects/pack/pack-哈希X.mtimes 每个 unreachable 对象的 mtime
```
