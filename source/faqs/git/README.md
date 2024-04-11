# Git

-  **origin**, **mirror** 等都是广泛使用的**<远程名>**
- `.git/refs/remotes/远程名/HEAD` 表示远程仓库的**<默认分支>**
- `.git/HEAD` 保存当前分支名或当前 commit 的 SHA-1 哈希值
-  执行 `git fetch/pull` 命令产生 `.git/FETCH_HEAD` 同步远程更新记录
- `.git/ORIG_HEAD` 保存执行 `git reset ...` 命令前的 `.git/HEAD` 的值

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
