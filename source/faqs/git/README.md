# Git

- 重命名远程 master 分支后本地同步

  ```bash
  # The default branch has been renamed master is now named trunk. If you
  # have local clone, you can update it by running the following commands.
  git branch -m master trunk
  git fetch origin
  git branch -u origin/trunk trunk
  git remote set-head origin -a
  ```

- About `git clone --bare` VS `git clone --mirror`

  ```bash
  git clone --mirror  仓库URL路径  仓库名

  # 等效于如下命令组合(支持断点续传功能)

  git init --bare 仓库名 && cd 仓库名
  git config remote.origin.mirror   true
  git config remote.origin.fetch    '+refs/*:refs/*'
  git config remote.origin.url      '仓库URL路径'
  # 获取远程仓库数据(二选一即可)
  git remote update origin # --prune
  git fetch origin # --prune --prune-tags
  ```

- Deleting old branches & tags from local repo which are not present in remote

  * https://git-scm.com/docs/git-fetch#_pruning
  * https://codingjump.com/posts/git-tips/delete-local-old-branches

  ```bash
  # prune old branches which do not exist in remote repository
  git remote prune origin # --dry-run
  git branch -r -d 分支名

  git push --delete origin v1.0.0 # 仅删除远程标签(本地标签未删除)
  git fetch --prune --prune-tags origin # 同步远程分支/标签(清理本地)

  git config fetch.prune               true
  git config fetch.pruneTags           true
  git config remote.远程名.prune       true
  git config remote.远程名.pruneTags   true
  ```

- 压缩/打包/清理 `.git` 目录 unreachable 元对象

  ```bash
  # .git/objects/pack/pack-哈希值.{rev,idx,pack,mtimes}  不可达对象 Unreachable Objects
  # .git/objects/pack/pack-哈希值.{rev,idx,pack}         可到达对象 Reachable   Objects

  # 压缩(可到达对象), 删除所有(不可达对象)
  git gc --prune=now --cruft # 命令二选一即可
  git repack -d --cruft --cruft-expiration=now

  # 压缩(可到达对象), 保留所有(不可达对象)
  git gc --prune=never --cruft # 命令二选一即可
  git repack -d --cruft --cruft-expiration=never

  # 压缩打包(不可达对象)和(可到达对象), 删除超过 1 天的(不可达对象)
  git gc --prune=1.day.ago --cruft # 命令二选一即可
  git repack -d --cruft --cruft-expiration=1.day.ago
  ```
