history     # 显示当前会话执行的历史命令列表
history -10 # 显示当前会话执行的历史命令列表, 最多显示最后的 10 个命令

# 3 个特殊命令历史字符, $HISTCHARS 中定义
# 井号 # The command character.
# 叹号 ! The history character.
# 尖号 ^ The modification character.
# 这三个字符命令行使用字面含义时需要转义
echo hello!!   # !! 会自动扩展成最后执行的命令
echo "hello!!" # !! 会自动扩展成最后执行的命令


# NOTE 事件指示器 -> 历史命令扩展
# 14.1.2 Event Designators
!n      # history 左侧显示的历史编号, 替换成第 n 号命令
!-n     # 替换成当前会话历史命令列表中的倒数第 n 号命令
!!      # 替换成前一个执行的命令(逆序编号 -1)
!#      # 替换成当前正在输入的命令
!Hstr   # 替换成首个以 Hstr 开头的历史命令

!{模式}
!?Mstr  # 替换成包含 Mstr 字符串的历史命令
!?Mstr? # 最后问号作用是表示模式 Mstr 结束


# NOTE 单词指示器 -> 历史命令的参数
# 14.1.3 Word Designators
:0 :1 ••• :n  # 诊断符 -> 命令名:0   首个参数:1    第2个参数:2    第n个参数:n
:x-y          # 诊断符 -> 选择参数区域, 第 x 和 第 y 个参数之间的所有参数, x 默认值 0
x-*           # 诊断符 -> 等同于 x-$, 即选择 第 x 到最后参数之间的所有参数
x-            # 诊断符 -> 类似于 x-*, 不包括最后参数
^             # 诊断符 -> 等同于 :1  首个参数
$             # 诊断符 -> 等同于 :n  最后参数
*             # 诊断符 -> 匹配的全部参数或空(没有任何匹配)
%             # 诊断符 -> 历史中首次和 ?Mstr 搜索匹配的部分

# 使用  ^  $  *  -  %  时冒号可忽略
echo okx1 okx2 okx3 okxyz okokher
printf "%s\n" ok2 ok3 ok4 ok5 ok6
!?okh?%       # 替换成命令历史中首次和 ver 匹配的单词
!?okh?:%      # 替换成命令历史中首次和 ver 匹配的单词
echo !!:0     # 替换成前一个命令, 不包含任何参数   => 显示 echo printf
echo !!:3     # 替换成前一个命令的第 2 个参数      => 显示 echo ok3
echo !!:3-4   # 替换成前一个命令的第 3 ~ 4 个参数  => 显示 echo ok3 ok4
