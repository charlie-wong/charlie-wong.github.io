# NOTE Bash/Zsh 解析位置参数
# => help getopts
# - 语法: getopts OptStr opt
# - 控制变量: OPTIND OPTARG OPTERR
# - 每个选项只能是单个字母字符, 区分大小写
#   首字符冒号则 静默模式, 否则 非 静默模式
# - OPTERR=0 (不显示错误消息)
#   OPTERR=1 (默认,显示错误消息)
# - OptStr 选项定义, 其语法格式
#   x: 表示 x 选项需要参数, 解析后其所需参数位于 OPTARG 变量
# NOTE OPTERR=1   Bash 默认值,  OPTERR=''  ZSH默认值

function demo() {
  local title="$1" silent=$2 emsg=$3; shift 3
  echo "$title TC=[$#] -> [$*]"

  echo "OPTERR 默认值 [${OPTERR}] 当前值 [${emsg}]"
  # NOTE 初始化全局控制变量, Bash 保留上一次调用 getopts 时 OPTIND 的值
  # 若不重置索引值, 则会造成奇怪的解析结果, 比如跳过对某些参数的解析
  local OPTIND=1  OPTARG  OPTERR=${emsg}  opt
  # OPTERR=0 [隐藏]错误消息  OPTERR=1 [显示]错误消息

  if [[ ${silent} -eq 1 ]]; then
    local OPTS=":a:bcd:" # 首字符冒号 静默模式
  else
    local OPTS="a:bcd:"  # [非]静默模式
  fi

  while getopts "${OPTS}" opt; do # 按字符依次处理,
    # opt     函数位置参数(无效参数则赋值 ?)
    # OPTARG  当前位置参数所需参数(带 : 的参数)
    # OPTIND  下一个待处理的位置参数索引
    echo "=> opt=[${opt}] OPTARG=[${OPTARG}] OPTIND=[${OPTIND}]->[${!OPTIND}]"
    case "${opt}" in
    'a') echo "ok -> a=[${OPTARG}]" ;;
    'b') echo "ok -> b" ;;
    'c') echo "ok -> c" ;;
    'd') echo "ok -> d=[${OPTARG}]" ;;
    '?') echo "xx -> ? invalid option [${OPTARG}]?=[]" ;; # 非 静默模式
    ':') echo "xx -> : [${OPTARG}] required argments"  ;; #    静默模式
      *) echo "xx -> * invalid option [${OPTARG}]"     ;; #    静默模式
    esac
  done

  echo "解析完成后 TC=[$#] -> [$*]"
  echo "未解析索引 OPTIND=[$OPTIND]"

  local it cnt=0
  # Bash 数组起始索引从 0 开始, ZSH 从 1 开始
  for it in $@; do
    (( cnt++ ))
    (( cnt >= OPTIND )) && echo "剩余参数 [${cnt}]=[$it]"
  done
}

silent=1; stitle="静默"
emsg=0; etitle='[隐藏]错误'

[[ $# -eq 1 ]] && { silent=0; stitle="[非]静默"; }
[[ $# -eq 2 ]] && { emsg=1; etitle='[显示]错误'; }
[[ $# -eq 3 ]] && {
  silent=0; stitle="[非]静默"
  emsg=1; etitle='[显示]错误'
}

# demo -ba 456 等同于 demo -b -a 456
demo "${stitle} ${etitle} 正常"        ${silent} ${emsg} -a a123 -d d456 -c more opts aaa
echo '==================================================================='
demo "${stitle} ${etitle} 后置不解析"  ${silent} ${emsg} -a a123 -d d456 more opts bb1 -c
echo '==================================================================='
demo "${stitle} ${etitle} 冒号 -d XX"  ${silent} ${emsg} -a a123 -d
echo '==================================================================='
demo "${stitle} ${etitle} -x 无效参数" ${silent} ${emsg} -a a123 -x -c more opts
