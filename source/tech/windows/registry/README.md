# 注册表

> [!NOTE]
> 系统版本 `Windows 11 23H2 Home Edition`

- Windows Registry Knowledge Base https://winreg-kb.readthedocs.io/en/latest
- https://learn.microsoft.com/zh-cn/troubleshoot/windows-server/performance/windows-registry-advanced-users

- Windows 注册表基本结构
  * `HKEY_LOCAL_MACHINE`      硬件系统基本配置(所有用户)
  * `HKEY_CURRENT_CONFIG`     系统启动时的硬件配置
  * `HKEY_CURRENT_USER`       当前登录用户的配置
  * `HKEY_CLASSES_ROOT`       应用程序启动配置
    - https://learn.microsoft.com/en-us/windows/win32/sysinfo/hkey-classes-root-key
  * `HKEY_USERS`              所有用户的配置
    - `HKEY_USERS\.DEFAULT`   新建用户的配置模板
    - `HKEY_USERS\`           SID 标识的账户/组配置
      * `S-1-5-18`    微软预定义本地系统安全服务账户
      * `S-1-5-19`    微软预定义 NT Authority 账户
      * `S-1-5-20`    微软预定义 Network Service 账户
      * `S-1-5-21-`   当前用户
      * SID(Security Identifier) 安全标识符
      * https://strontic.github.io/xcyclopedia/index-com-objects
      * https://learn.microsoft.com/en-us/windows/win32/secauthz/well-known-sids
      * https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers
      * https://www.codeproject.com/Articles/1265/COM-IDs-Registry-keys-in-a-nutshell
      * https://www.elevenforum.com/t/list-of-windows-11-clsid-key-guid-shortcuts.1075
      * https://www.tenforums.com/tutorials/3123-clsid-key-guid-shortcuts-list-windows-10-a.html

## 注册表工具软件

- 注册表清理 Wise Registry Cleaner
  * https://www.wisecleaner.com/wise-registry-cleaner.html
  * `C:\Users\用户名\AppData\Roaming\Wise Registry Cleaner`

- 注册表搜索 RegScanner
  * https://www.nirsoft.net/utils/regscanner.html

## 手动清理/设置

- 清理_[鼠标右键某文件]->[打开方式]_中已经失效的选项
  * `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\`
  * `扩展名\OpenWithList\*`            打开 _扩展名_ 文件可用的应用程序
  * `扩展名\OpenWithList\MRUList`      应用程序在弹出的上下文菜单中的显示顺序
  * `扩展名\OpenWithList\UserChoice`   用户设置双击打开默认文件(删除恢复默认)

- 清理已卸载应用在注册表中的残留信息
  * `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UFH\SHC\`
  * `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts\`
  * `HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store\`

- 查看注册表记录的(任务栏相关)应用程序统计数据
  * `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\`
  * https://www.crowdstrike.com/blog/how-to-employ-featureusage-for-windows-10-taskbar-forensics
    - `KeyCreationTime` 64-bits 数据, 表示当前用户首次登录时间
    - `AppBadgeUpdated\`   _统计数据(任务栏)_ 表示 运行中应用的通知次数(例如未读邮件数通知)
    - `AppLaunch\`         _统计数据(任务栏)_ 表示 从 PIN 到任务栏的应用图标启动应用的次数
    - `AppSwitched\`       _统计数据(任务栏)_ 表示 已启动应用的 Focus 切换次数
    - `ShowJumpView\`      _统计数据(任务栏)_ 表示 鼠标右击已启动应用任务栏图标的次数

- 系统预读取文件(加速应用启动速度)
  * 删除 `C:\Windows\Prefetch\` 目录内容然后重启(其内容根据需要会自动重建)

- 系统内存管理 `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\`
  * `Session Manager\Memory Management\`
  * `Session Manager\Memory Management\PrefetchParameters\EnablePrefetcher`
    - 表示是否启用 `C:\Windows\Prefetch` 系统预读取文件功能
    - 0 禁用
    - 1 仅启用应用程序预读取
    - 2 仅启用启动引导预读取
    - 3 启用应用程序和引导预读取

- Windows 开始菜单布局
  * `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\`

- 修改 `.bat` 文件默认编辑器
  * `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bat\`
  * `HKEY_CLASSES_ROOT\batfile\shell\edit\command\`
