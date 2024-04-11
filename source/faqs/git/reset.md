# git reset

```bash
# HEAD(当前提交)    HEAD^(后退1次)    HEAD^^(后退2次)    HEAD^^^(后退3次)
# HEAD~ 或 HEAD~0   HEAD~1(后退1次)   HEAD~2(后退2次)    HEAD~3(后退3次)
```

- `.git/logs/HEAD` 文件记录 HEAD 变更状态, 文件内容格式
  * 每行的第 1 列表示父级 commit-id
  * 每行的第 2 列表示当前 commit-id
  * 文件第 1 行表示旧提交记录, 即文件末尾行表示当前状态

- `git reset --soft HEAD^`
  * work-tree **未追踪**(尚未提交到历史提交记录中的文件)文件**保持不变**
  * work-tree **已追踪**(已经提交到历史提交记录中的文件)文件的`修改`**保持不变**
  * 将 `历史提交` **合并**到当前 `index` 区域
  * 若当前 `index` 和 `历史提交` 同时修改某文件则当前 `index` 内容保持不变

- `git reset --mixed HEAD^` 或 `git reset HEAD^`
  * work-tree **未追踪**(尚未提交到历史提交记录中的文件)文件保持不变
  * work-tree **已追踪**(已经提交到历史提交记录中的文件)文件的修改保持不变
  * 清空当前 `index` 区域内容
  * 将 `历史提交` **合并**到 work-tree

- `git reset --hard HEAD^`
  * 清空当前 `index` 区域内容
  * work-tree **未追踪**(尚未提交到历史提交记录中的文件)文件**保持不变**
  * work-tree **已追踪**(已经提交到历史提交记录中的文件)文件的`修改`**清空**
  * work-tree 中文件的同步到 `HEAD^` 的状态
  * 注意: 在 `index` 中被标记为 **new file** 的文件此时会从 work-tree 中删除
