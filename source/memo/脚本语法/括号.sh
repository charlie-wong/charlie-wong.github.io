# Bash 3.5.5 Arithmetic Expansion
# 执行算数计算, 返回最后表达式的值作为最终结果
echo "$(( 1 + 2, 5 + 3 ))" # 多个表达式逗号分隔

# Bash 6.5 Shell Arithmetic
# 数学计算, 多表达式逗号分隔, 最后表达式作为返回结果
# - 最后表达式的值等于 0 整个表达式 false
# - 最后表达式的值非   0 整个表达式 true
(( 1 - 1 ))        && echo ok # no ok
(( 1 - 1, 2 - 1 )) && echo ok # show ok
(( 数学表达式 ))  (( expr1, expr2 ))

(( 5**2 )) # 表示 5 的 2 次方
(( v1*v2, v1/v2, v1%v2 )) # 乘法, 除法, 取余
(( expr1 && expr2, expr1 || expr2 )) # 逻辑与或
(( v1>=v2, v1>v2, v1<=v2, v1<v2, v1==v2, v1!=v2 ))
(( v1&v2, v1^v2 )) # bitwise AND, OR
(( v1>>2, v1<<3 )) # bitwise right/left shift
(( expr1 ? exprT : exprF )) # 三元条件判断
(( v<<=1, v>>=2, v&=3, v^=4, v|=5 ))    # 各种赋值
(( v=1, v+=2, v-=1, v*=2, v/=3, v%=5 )) # 各种赋值
((  id++, ++id,  v1+v2,  -v1,  !逻辑非,
    id--, --id,  v1-v2,  +v2,  ~位非,
))

# http://mywiki.wooledge.org/BashFAQ/031
# https://superuser.com/questions/1533900
# What is the difference between test, [ and [[
! expression      # true if expression is false
# NOTE if it is sufficient to determine the return value of the
# entire conditional expression, then do not evaluate expression2
expression1 && expression2 # true if both are true
expression1 || expression2 # true if either is true


# 6.4 Bash Conditional Expressions
[[ 判断条件 ]]    # 扩展语法
 [ 判断条件 ]     # 向前兼容, equivalent to `test`

# NOTE Bash/Zsh 等均支持 [[ ]] 语法形式
#      建议统一使用 [[ ]] 语法形式进行比较操作
# NOTE [[ ]] 语法中 = 和 == 的含义相同(历史兼容原因)

# 单个 [] 等同与 test 命令, 不能做空值比较
[ "x$ASD" == xValue ] # 添加 x 防止空值比较
# [[ ]] 扩展语法, 支持 C 类比较操作符号, >  <  >=  <=  !=  ==  &&  ||
# https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic
[[ $ASD == Value ]]

# 字符串为空    字符串非空
[ -z "$Var" ]   [ -n "$Var" ]
# 字符串不等    字符串相等
[ $a != $b ]    [ $a == $b ]    [ "x$a" == "x$b" ]
# 逻辑与              逻辑或                逻辑非
[ EXPR1 -a EXPR2 ]    [ EXPR1 -o EXPR2 ]    [ ! EXPR ]
[[ EXPR1 && EXPR2 ]]  [[ EXPR1 || EXPR2 ]]  [[ ! EXPR ]]

# [ 等同于命令 test, [ 是 shell 关键字, 符合 POSIX 标准
[ $a -eq $b ]   [ $a -ne $b ]   [ $a -gt $b ]
[ $a -lt $b ]   [ $a -ge $b ]   [ $a -le $b ]

v="A*";  [ $v == A* ] && echo Y || echo N   # 字符匹配 => Y
v="Aab"; [ $v == A* ] && echo Y || echo N   # 字符匹配 => N
v="Aab"; [[ $v  = A* ]] && echo Y || echo N # 模式匹配 => Y
v="Aab"; [[ $v == A* ]] && echo Y || echo N # 模式匹配 => Y
v="hello world"; [[ $v =~ "world" ]] && echo Y || echo N # 正则匹配 => Y

# 使用 () 进行分组
 [ 1 == 1 -a (2 == 2 -o 3 == 4) ]  && echo Y || echo N # 脚本运行时支持 => Y
[[ 1 == 1 && (2 == 2 || 3 == 4) ]] && echo Y || echo N # 脚本/手动均支持 => Y
