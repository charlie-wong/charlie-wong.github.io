# https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions

# 大括号扩展
echo a{d,c,b}e  # 生成 ade ace abe


# ~ 扩展
~         # 等同于 $HOME
~/abc     # 等同于 $HOME/abc
~foo/bar  # 将 foo 视作用户名, 等同于 /home/foo/bar

~+/foo    # 等同于 $PWD/foo
~-/bar    # 等同于 ${OLDPWD:-}/bar

~N        # N 表示数字, 当前目录栈正向索引(左到右, 0 开始), 等同于 `dirs +N`
~+N       # N 表示数字, 当前目录栈正向索引(左到右, 0 开始), 等同于 `dirs +N`
~-N       # N 表示数字, 当前目录栈逆向索引(右到左, 0 开始), 等同于 `dirs -N`


# 模式匹配
*   # 匹配任意字符串(包括空字符串)
?   # 匹配任意单个字符
[]  # 匹配括号中任意单个字符
# -> [! 或 [^ 表示非, [a-zA-z], [0-9] 表示区域
# -> 若匹配减号, 则将其必须位于第一个或最后一个字符, 即 [-... 或 ...-]
# -> 支持 POSIX 标准集合命名:
#    lower    digit    blank    alpha    alnum    print    graph
#    upper    xdigit   space    ascii    cntrl    punct    word


# NOTE pattern-list is a list of one or more patterns separated by a |
?(pattern-list)   # Matches zero or one  occurrence  of the given patterns
*(pattern-list)   # Matches zero or more occurrences of the given patterns
+(pattern-list)   # Matches one  or more occurrences of the given patterns
@(pattern-list)   # Matches one  of the given patterns
!(pattern-list)   # Matches anything except one of the given patterns
