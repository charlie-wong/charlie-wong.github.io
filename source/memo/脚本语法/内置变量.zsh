# NOTE 二者等价
# - autoload -Uz hello
# - hello() { builtin autoload -XUz path/to/hello; }
#
# - The name used to invoke the current shell
# - The function name if it is used in shell function
# - `zsh ~/file` 或 `source ~/file` 时, 函数外则文件名
$0
# - If zsh was invoked to run a script, it is the script name
# - Otherwise, it is the name used to invoke the current shell
ZSH_ARGZERO
# Prompt 扩展
# - The name of script if it is used outside of function
# - The name of function if it is used in shell function
# - If none of above, it is equivalent to the parameter $0
%N
# - The name of the file containing the code currently being executed.
%x
print -P "[%N][%x]"
echo "[${(%):-%N}][${(%):-%x}]"
+--------------------+------------------+---------------------+--------------+--------------+
|   autoload hello   |   zsh to/hello   |   source to/hello   |   cmd-line   |    变量名    |
+--------------------+------------------+---------------------+--------------+--------------+
| 函数内&外均 hello  | 外:文件, 内:函数 |  外:文件,  内:函数  | 内:函, 外:sh | $0           |
+--------------------+------------------+---------------------+--------------+--------------+
|    invoke-shell    | 函内&外均 文件名 |    invoke-shell     | invoke-shell | $ZSH_ARGZERO |
+--------------------+------------------+---------------------+--------------+--------------+
| 函数内&外均 hello  | 外:文件, 内:函数 |  外:文件,  内:函数  | 内:函, 外:sh | %N           |
+--------------------+------------------+---------------------+--------------+--------------+
| 函数内&外均 文件名 | 函内&外均 文件名 |  函内&外均  文件名  | 内:空, 外:sh | %x           |
+--------------------+------------------+---------------------+--------------+--------------+
