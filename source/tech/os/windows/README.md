# Windows FAQs

- 快速搜索文件工具 Everything
  * https://www.voidtools.com/zh-cn/downloads

- Windows 11 自带管理员工具列表
  * `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools`

- Windows 无效文件名字符(保留字符)
  * https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file
  * 小于`<` 大于`>` 冒号`:` 双引号`"` 正斜杠`/` 反斜杠`\` 管道`|` 问号`?` 星号`*`

- Windows 操作系统预定义环境变量
  * https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables

- 关于 Windows 用户安装的字体
  * Win11 系统桌面 _[此电脑]->[属性]->[个性化]->[字体]_
  * 字体安装位置 `C:\Users\charlie\AppData\Local\Microsoft\Windows\Fonts\`

- 任务栏中 PIN 应用的快捷方式的保存位置
  * `C:\Users\charlie\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\`

- 刷新系统图标缓存的方式 _删除_ 下列文件后重启电脑
  * `C:\Users\charlie\AppData\Local\IconCache.db`
  * `C:\Users\charlie\AppData\Local\Microsoft\Windows\Explorer\iconcache_*.db`

- 关于 Windows 搜索服务
  * 全部禁用: 打开 `services.msc` 然后搜素设置 _Windows Search_ 选项内容
  * https://learn.microsoft.com/zh-cn/windows/win32/search/-search-3x-wds-overview
  * 仅关闭 Windows 11 Home 版的 _[开始]->[搜素应用、设置和文档]_ 网页搜索功能
    - https://woshub.com/disable-web-search-windows-start-menu
    - 创建项 `HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer\`
    - 新建值 名称 `DisableSearchBoxSuggestions`, 类型 _DWORD(32位)_, 数值 `1`

- _TODO_ 关于由 `svchost.exe` 导致的移动硬盘无法弹出的问题
  * 打开 `资源监视器`, 选择 _CPU_ 标签, _关联的句柄_ 输入盘符查看谁在占用磁盘

- 多语言用户界面 MUI 技术
  * https://learn.microsoft.com/zh-cn/windows/win32/intl/overview-of-mui
  * https://learn.microsoft.com/zh-cn/windows/win32/intl/mui-resource-management

- 关于 `C:\Windows\WinSxS` 目录(Windows Side-by-Side)
  * 保存 Windows 系统更新及补丁备份
  * 解决动态库 DLL 版本导致的问题(DLL Version Hell), 例如
    - 应用程序 A 依赖 x.dll 动态库的 1.0 版本
    - 新装应用 B 依赖 x.dll 动态库的 2.0 版本(1.0 版和 2.0 版不兼容)
    - 此时若简单升级 x.dll 动态库则会影响 A 程序的正常工作
  * NTFS 文件系统支持的三种链接类型: _硬链接_、_交汇点_ 和 _符号链接_
    - https://learn.microsoft.com/zh-cn/windows/win32/fileio/hard-links-and-junctions
    - 查看系统文件的硬链接(管理员执行)
      * `fsutil hardlink list "C:\Windows\System32\audiosrv.dll"`
  * 查看 `C:\Windows\WinSxS` 目录占用的实际磁盘空间
    - 管理员执行 `Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore`

- 关于 NTFS 文件系统
  * 特殊目录: 系统卷信息(`System Volume Information`)
  * 特殊目录: 回收站(`$RECYCLE.BIN`) https://www.itechtics.com/delete-empty-recycle-bin

  * NTFS 文件系统的 _UNS日志_(_Update Sequence Number Journal_)
    - 鼠标右击磁盘分区 _[属性]->[除了文件属性外, 还允许索引此驱动器上文件的内容]_

  * 查看 NTFS 文件系统的 block 大小
    - 管理员身份执行 `fsutil fsinfo ntfsinfo C:` 查看 _C_ 盘属性
