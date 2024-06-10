# => 提示符扩展
# => 13 Prompt Expansion
# 脚本名, source 文件名, 当前正在执行的函数名, fallback 值 $0
%N 或 %0N # 显示完整路径值
%1N  # 仅显示末尾文件名, %xN 表示仅显示末尾的 x 项内容
%-1N # 仅显示路径开头的第 1 项, %-xN 从路径左侧开头开始
print -P "[%N]" # 执行 prompt 扩展


# => 变量扩展
# => 14.3 Parameter Expansion
# - 结果 1, 若 VAR 是 set 命令设置的变量名
# - 结果 0, 若 VAR 非 set 命令设置的变量名
${+VAR}

# POSIX 语法扩展
${VAR:/PAT/新值}   # PAT 匹配 VAR 完整字符串, 即完全匹配
${VAR/#%PAT/新值}  #%PAT 表示 PAT 必须同时匹配 VAR 的开头和结尾
${VAR//#%PAT/新值}

${==VAR} # 当前扩展关闭 word-split
${=VAR}  # 当前扩展进行 word-split, IFS 分隔符, SH_WORD_SPLIT 规则

${^ARR}   # 启用 RC_EXPAND_PARAM 选项后进行扩展
${^^ARR}  # 关闭 RC_EXPAND_PARAM 选项后进行扩展
# 禁用 RC_EXPAND_PARAM 后
ARR=(X Y Z); echo foo${ARR}bar      # 结果 fooX Y Zbar
# 启用 RC_EXPAND_PARAM 后
ARR=(X Y Z); echo foo${ARR}bar      # 结果 fooXbar fooYbar fooZbar
# NOTE 双引号内 RC_EXPAND_PARAM 始终处于关闭状态
ARR=(X Y Z); echo "foo${ARR}bar"    # 结果 fooX Y Zbar
ARR=(X Y Z); echo "foo${^ARR}bar"   # 结果 fooX Y Zbar
ARR=(X Y Z); echo "foo${^^ARR}bar"  # 结果 fooX Y Zbar


# => 扩展标志符
# => 14.3.1 Parameter Expansion Flags
${(标志符)VAR}

# (%) 执行命令行提示符扩展, 即扩展 %.. 形式参数
echo "${(%):-%N}" # 当前脚本名(非函数内), 函数内表示函数名

# 匹配子字符串
VAR="fooX12X34X56 barX78X90 end"
echo "${VAR#X*}"      # 无匹配, 显示原始内容
echo "${(S)VAR#X*}"   # 删除 VAR 开头部分和 X* 匹配的 shortest 内容, 仅删除第一个 X
echo "${(S)VAR##X*}"  # 删除 VAR 开头部分和 X* 匹配的 longest 内容, 结果 foo
echo "${VAR%X*}"      # 删除 X90 end
echo "${(S)VAR%X*}"   # 删除 VAR 结尾部分和 X* 匹配的 shortest 内容, 仅删除最后的 X
echo "${(S)VAR%%X*}"  # 删除 VAR 结尾部分和 X* 匹配的 longest 内容, 等同 ${VAR%X*}
echo "${VAR/X*/_}"      # 删除和 X* 匹配的 longest  内容(首次), foo_
echo "${VAR//X*/_}"     # 删除和 X* 匹配的 longest  内容(全部), foo_
echo "${(S)VAR/X*/_}"   # 删除和 X* 匹配的 shortest 内容(首次), 仅首个 X 替换为 _
echo "${(S)VAR//X*/_}"  # 删除和 X* 匹配的 shortest 内容(全部), 全部的 X 替换为 _
# NOTE 上述 * 表示本地扩展匹配启用 EXTENDED_GLOB 选项

(B) # TODO ?
(E) # TODO ?
(N) # TODO ?
(M) # 匹配部分   构成匹配结果 -> Include the matched portion in the result
(R) # 非匹配部分 构成匹配结果 -> Include the unmatched portion in the result.

# 若 PAT 匹配 VAR 字符串的值, 则最终结果为空, 否则结果是 VAR 字符串
${VAR:#PAT}, ${ARRAY:#PAT} # 过滤删除数组 ARRAY 中和 PAT 匹配的元素
${(M)VAR:#PAT}, ${(M)ARRAY:#PAT} # (M) 逆向操作, 即不匹配则过滤删除

# (C)   每个单词首字母大写
# (L)   字母全部转换为小写
# (U)   字母全部转换为大写
foo="hello i like zsh"; echo "${(C)foo}"
# (f)   以 \n 为分隔符进行 word-split
files="$(ls)"
for it in "${files}";    do echo "[$it]"; done # 循环仅有 1 项元素(包含全部内容)
for it in "${(f)files}"; do echo "[$it]"; done # 以 \n 为分隔符, 分隔成多个元素
# (F)   Join words of arrays together using newline as a separator
ARR=(AA BB CC DD)
for it in "${ARR[@]}";    do echo "[$it]"; done # 每个数组元素都是单独的元素
for it in "${(F)ARR[@]}"; do echo "[$it]"; done # 合并元素, \n 分隔符, 总共1项
# (i)   忽略大小写排序
# (a)   按数组数字索引下标排序
# (-)   类似 (n) 但 -x 表示负数(x是数字时)
# (n)   十进制数字排序, 非数字则按字母表排序
# (o)   字母表排序, 区分大小写, 升序
# (o)   字母表排序, 区分大小写, 降序
ARR=(AA BB 04d CC DD 01a 02b 03c aa bb cc dd _ '?')
echo "[${(i)ARR[@]}]"; echo "[${(in)ARR[@]}]" # 二者等同
# (t)   显示变量类型
# (u)   仅显示独一无二的 word
ARR=( one two one foo bar foo bar ); echo "[${(u)ARR[@]}]"
# (k)   仅显示 associative 数组的  key  序列
# (v)   仅显示 associative 数组的 value 序列
