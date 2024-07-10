shopt -s dot_glob       # Bash 启用 dot_glob 选项
setopt dot_glob         # ZSH  启用 dot_glob 选项
setopt extended_glob    # ZSH  启用 extended_glob 选项

# NOTE `ls` 命令未使用 -cftuvSUX 或 --sort 参数时, 默认按字母表排序

# Guide to Zsh Expansion with Examples
# https://wiki.zshell.dev/community/zsh_guide/roadmap/expansion
# https://thevaluable.dev/zsh-expansion-guide-example/


# NOTE Bash/Zsh 通用语法
# =>Glob Operators 通配符
# ? 仅匹配任意单字符  * 匹配任意字符串(包括空)
#   递归通配符 ** 递归式匹配子目录
#
# Zsh -> 14.8.6 Recursive Globbing
# NOTE Zsh 默认递归处理所有深度的子目录, Bash 默认仅匹配第一层子目录,
# NOTE 启用 `shopt -s globstar` Bash 选项使之匹配处理所有深度的子目录
ls ./**/*foo* # 列出当前目录及其子目录中所有文件名包含 foo 的文件
#
# [候选字符]    仅匹配其中一个字符      [:字符集:]    POSIX 字符集名称
# [0-9A-Za-z]   指定候选字符范围        [^:字符集:]   匹配[非]集合内字符
# NOTE ! 亦可以表示逻辑非, 但输入时需要转义, ! 是命令历史操作前缀字符
ls [a]*     # 显示所有以 a 开头的文件  ls [ax]*   以 a 或 x 开头的文件
ls [^a]*    # 显示所有非 a 开头的文件  ls [^ax]*  非 a 且 非 x 开头的文件


# =>Zsh 分组通配符 -> 14.8.1 Glob Operators
# ( PAT )         # 匹配小括号内的 PAT
# ( PAT1 | PAT2 ) # 匹配 PAT1 或 PAT2
ls (fo|ba)*       # 显示以 fo 或 ba 开头的文件


# =>Zsh 通配 Flags -> 14.8.4 Globbing Flags
# - 需要启用 EXTENDED_GLOB 选项
# - 语法形式  (#标志字符)模式字符串
ls (#I)ab* # 大写匹配大写, 小写匹配小写
ls (#i)ab* # 匹配时忽略大小写
ls (#l)Ab* # 小写字符匹配时忽略大小写, 但大写仅匹配大写


# =>Zsh 14.8.7 Glob Qualifiers
^通配限定符 # 逻辑非
.通配限定符 # 仅匹配常规文本文件
@通配限定符 # 仅匹配符号链接文件
-通配限定符 # make qualifiers work on symbolic links, enable by default

# Makes glob pattern evaluate to nothing when no match, no error message
ls .*(N) # sets the NULL_GLOB option for the current pattern

# =>Zsh 通配限定符 -> 目录扩展
ls *(F)   # 仅扩展为非空目录
ls *(^F)  # 扩展为空目录和非目录(常规文件)
ls *(/^F) # 仅扩展为空目录

# =>Zsh 通配限定符 -> 按类型扩展
cat *(.) # 仅扩展生成常规文件列表
ls  *(/) # 仅扩展生成目录列表

# =>Zsh 通配限定符 -> 按文件权限扩展
ls *(*) # 扩展为所有有执行权限的文件(0100 or 0010 or 0001)

ls *(r) # 扩展为 owner 可读文件 (0400)
ls *(w) # 扩展为 owner 可写文件 (0200)
ls *(x) # 扩展为 owner 可执行   (0100)
ls *(U) # Files or dirs owned by current user

ls *(A) # 扩展为 group 可读文件 (0040)
ls *(I) # 扩展为 group 可写文件 (0020)
ls *(E) # 扩展为 group 可执行   (0010)
ls *(G) # Files or dirs owned by current user group

ls *(R) # 扩展为 world 可读文件 (0004)
ls *(W) # 扩展为 world 可写文件 (0002)
ls *(X) # 扩展为 world 可执行   (0001)

# (fUGO) files with access rights matching UGO
# 八进制权限数字表示: 拥有者, 用户组, 其它人
# (f) 等效于 (f=), SPEC 缺失时默认默认值 =
# ?   corresponding bits in the file-modes are not checked
# -X  The bits in the number must not be set in the file-mode
# +X  At least one bit in the number needs to be in the file-mode
ls *(f644)  # rwx,    r--, r--
ls *(f?55)  # 不检查, r-x, r-x
ls *(f-100) # 等效于 *(f-10) 和 *(f-1)
# NOTE 拥有者u, 用户组g, 其它人o, 所有人a, 逗号分隔的列表, 类似 chmod
ls *(f:u+x:)   # { } 和 [ ] 和 < > 的作用是 [界限符], 其它字符亦可用作 [界限符]
ls *(f{u+x})   # 用其它字符作为 [界限符] 时, 左右需要对称相等
ls *(f'<u+x>') # 尖括号不可直接用作 [界限符], 需转义或引号包裹
ls *(f\<u+x\>)
ls *(f[u+x])
ls *(f u+x )   # 空格作为界限符号
ls *(fZu+xZ)   # Z 字母作为界限符
ls *(fXu+xX)   # X 字母作为界限符

# Zsh 通配限定符 -> 按访问日期
# 时间单位 -> M月(30天)  w星期  h小时  m分钟  s秒
# +n 表示至少 n<单位> 之前 访问(accessed)/修改(modification)/改变(inode change)
# -n 表示     n<单位> 之内 访问(accessed)/修改(modification)/改变(inode change)
# a[Mwhms][-|+]n   至少 n<unit> 之内/之前 访问
# m[Mwhms][-|+]n   至少 n<unit> 之内/之前 修改
# c[Mwhms][-|+]n   至少 n<unit> 之内/之前 inode change time
ls *(ah-5) # 显示 5 小时之内访问过的文件
ls *(cd-1) # 显示 1   天之内修改过的文件
ls *(md1)  # 加号可以省略
ls *(md+1) # 显示 1   天之前修改过的文件

# Zsh 通配限定符 -> 按文件大小
# 大小单位 -> P/p 512字节, K/k, M/m, G/g, T/t
# L[pPkKmMgGtT][+|-]n   文件大小向上四舍五入匹配
# -n  文件小于 n<单位> 大小
# +n  文件大于 n<单位> 大小
ls *(Lm-1) # 仅匹配大小为 0 的文件
ls *(Lm1)  # 加号可以省略
ls *(Lm+1) # 匹配 1B ~ 1M 大小的文件

# 启用短路模式(short-circuit mode)
ls -U # 以 directory traversal order 顺序显示当前目录内容
(Yn) # 扩展生成最多 n 个文件名, 若候选者超过 n 个,
# - Implies (oN)不排序 when no (oc) qualifier is used.
# - 则仅显示 directory traversal order 的前 n 项
ls -Ud *(Y1) # 仅显示目录序第 1 项
ls -Ud *(Y3) # 仅显示目录序前 3 项

# Zsh 通配限定符 -> 排序
# o[nNlLamcd] 升序              O[nNlLamcd] 降序
# N - Don't sort anything.      a - Sort by last access, youngest first.
# n - Sort by name, default.    m - Sort by last modification, youngest first.
# L - Sort by size.             c - Sort by last inode change, youngest first.
# l - Sort by number of links.  d - Subdirs contents before parent dir contents.
# oe'shell-coed' 和 o+'shell-code', REPLY 设置成匹配生成的文件名
# specifies filenames which should be included in the return matched list.
# NOTE `ls` 默认将显示内容按字母表顺序排序, 除非显示指定不排序
# `ls` 命令的 -f 参数 do not sort, enable -aU, disable -ls --color
# `ls` 命令的 -U 参数 do not sort, list entries in directory order
ls -hlSr         # 按文件大小排序, 小 -> 大
ls -Ulhd *(oL)   # 按文件大小排序, 小 -> 大
ls -Ulhd *(^oL)  # 按文件大小排序, 大 -> 小
ls -Ulhd *(OL)   # 按文件大小排序, 大 -> 小
ls -Ulhd *(^OL)  # 按文件大小排序, 小 -> 大
for it in *(oL); do ls -lhd $it; done # 按文件大小排序, 小 -> 大
ls -Ulhd *(oL[1,3]) # 仅显示最大的前三个

ls -U # 若显示 A B C D E F 文件列表(目录序)
ls *([2,4])   # 则仅显示 B C D 列表, 即 [左] 起 2 到 4 项
ls *([-4,-2]) # 则仅显示 C D E 列表, 即 [右] 起 2 到 4 项

# *(eX'sh-code'X) 对每个匹配的文件名执行 sh-code, REPLY 变量存储文件名
# 当且仅当 sh-code 返回值(最后命令退出码)为 0 时, 生成列表中才包含当前文件
# X是类似 f 通配限定符的界限符, 通常用 [ ], { }, < > 或 : 作为界限符
# => [界限符] 是冒号, 生成 XX-a1, XX-a2 等形式的文件名列表
for it in *(e:'reply=(${REPLY}{-a1,-a2})':); do echo "${it}"; done
# => [界限符] 是冒号, 过滤生成以 prefix 开头的文件列表
for it in *(e:'[[ ${REPLY} =~ prefix* ]]':); do echo "${it}"; done
# => 生成当前目录下 plain text 文件列表, 排除 foo 文件
for it in *(e:'[[ ${REPLY} != foo ]]':.); do echo "${it}"; done
# *(+命令或函数名) 效果等同于 *(eX'sh-code'X), 唯一区别是不需要 [界限符]
filter() { [[ ${REPLY} -nt ${NTREF} ]] }; NTREF=foo; ls -ld -- *(+filter)
