# Markdown 语法示例

1. 空行表示另起一段
2. 星号、加好、减号的效果一致
3. 连续两个空格会变成一个\<br>，\<br>的意思在 HTML中表示换行
4. \反斜线可用来转义
5. 连续三个减号，会显示分割线
6. Markdown的转义字符`\`用于以下在Markdown中有特殊含义的字符<br>
   \[\\]  ----  backslash<br>
   \[`]   ----  backtick<br>
   \[*]   ----  asterisk<br>
   \[_]   ---- underscore<br>
   \[{} ] ----  curly braces<br>
   \[[]]  ----  square brackets<br>
   \[()]  ----  parentheses<br>
   \[#]   ----  hash mark<br>
   \[+]   ----  plus sign<br>
   \[-]   ----   minus sign (hyphen)<br>
   \[.]   ----   dot<br>
   \[!]   ----  exclamation mark<br>


#       标题
#       this is an header leval 1 tag
##      this is an header level 2 tag
###     this is an header level 3 tag
####    this is an header level 4 tag
#####   this is an header level 5 tag
######  this is an header level 6 tag (just only 6 header level in Markdown)


# 字体

*斜体*<br>
_斜体_<br>
**黑体**<br>
__黑体__<br>
~~删除线~~


# 图片和链接

[baidu]: www.baidu.com
[百度][baidu]<br>
[GitHub](github.com)<br>
![图片无法加载显示](https://mms0.baidu.com/it/u=328103552,1591924736&fm=253&f=JPEG "鼠标悬停显示")<br>


# 表情列表
:smile:         :smirk:
:laughing:      :satisfied:


#  引用文字
The below is an example of block quotes.
>       quoted num 1.
>>      quoted num 2.
>>>     quoted num 3.
>>>>    quoted num 4.
>>>>>   quoted num 5.
>>>>>>  quoted num 6.
>>>>>>> quoted num 7.

> * quoted num 8.
>>- quoted num 9.
>>>* quote num 10.
>>>>- quote num 11.


# 列表

* item num 1
* item num 2
  * item num 2-1
  * item num 2-2
    * item num 2-2-1
    * item num 2-2-2
      * item num 2-2-1
      * item num 2-2-2
    * item num 2-2-3
  * item num 2-2-3
* item num 3

- item num 1
- item num 2
  - item num 2-1
  - item num 2-2
    - item num 2-2-1
     item num 2-2-2
      - item num 2-2-1
      - item num 2-2-2
    - item num 2-2-3
  - item num 2-2-3
- item num 3

1. item 1
2. item 2
   * item 2-1
3. item 3
   * item 3-1
     * item 3-1-1

#  任务列表
- [x] taget list, num 1, complete task, @charlie
  - [x] taget list, num 1-1, complete sub task
  - [ ] taget list, num 1-2, incomplete sub task
    - [x] taget list, num 1-2-1, complete sub task
    - [ ] taget list...
      - [x] task list ...
      - [ ] task list ...
        - [x] task list
- [x] taget list, num 2, @username
- [x] taget list, num 1, @charlie-wong
- [x] taget list, num 2, @kneath, => at some person
- [ ] taget list, num 3<br>
- [ ] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported


# 表格

### src good to read
first header | second header | third header
-------------|---------------|-------------
content cell | content cell  | content cell
content cell | content cell  | content cell
content cell | content cell  | content cell

| first header | second header | third header |
| -------------|---------------|------------- |
| content cell | content cell  | content cell |
| content cell | content cell  | content cell |
| content cell | content cell  | content cell |

### src bad to read
fsss heer | second ahohohohheader | third heihihhihader
-------------|---------------|-------------
 cel | cotentfhohfwfa cell  | consfcell
cll | conent cell  | contefaj

### 冒号左侧表示左对齐，冒号右侧表示右对齐
### 冒号两侧表示居中对齐，无冒号表示左对其
| first header | second header | third header | fourth col |
|:------------ |--------------:|------------- |:----------:|
| cell | cell  | cell | cell |
| cell | cell  | cell | cell |
| cell | cell  | cell | cell|


# 语法高亮

This is an example of `inline` code. put code in a pair of \` (the key of `~`)<br>

代码块：成对的三个 ```符号构成代码块<br>
```
void fun(int x)
{
  return 0;
}
```

语法高亮：在开始的三个```符号后加入语言名，如：c/C, c++/C++, bash/Bash, makefile/Makefile<br>
```C
void fun(int x)
{
  return 0;
}
```

```c++
template<T>
T fun(T var)
{
  return var;
}
```

```bash
VAR=`pwd`
if [ ${VAR} != "/home" ]; then
  echo "do something"
else
  echo "do others"
fi
```

```makefile
all:
  gcc main.c inx.h inxy.h
clean:
  rm -f *.out *.o
```

```cmake
cmake_minimum_required(VERSION 2.8.7)
project(NAME)
set(MACRO_VAR 1)
add_executable(NAME src.cpp)
```


# Markdown 中使用 HTML 标记表示空格

En 是字体排印学的计量单位, 为 Em 宽度的一半

1. `&nbsp;`    No-Break Space       按下 Space 键产生的空格, 空格占据宽度受字体影响强烈
2. `&ensp;`    En Space             空格占据宽度基本上不受字体影响, 名义上是小写字母 n 的宽度
3. `&emsp;`    Em Space             空格占据宽度基本上不受字体影响, 名义上是一个中文字符的宽度
4. `&thinsp;`  Thin Space
5. `&zwnj;`    Zero Width Non Joiner
6. `&zwj;`     Zero Width Joiner

- `&nbsp;`空格宽度示例: 开始 [&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;] 结束
- `&ensp;`空格宽度示例: 开始 [&ensp;&ensp;&ensp;&ensp;&ensp;] 结束
- `&emsp;`空格宽度示例: 开始 [&emsp;&emsp;&emsp;&emsp;&emsp;] 结束


# Github
1. 评论时输入 `#` 显示任务号列表
2. 评论时输入 `@` 显示要`at`的人的名字
