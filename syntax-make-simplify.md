#       Mark down 语法简介
---
1. 空行表示另起一段<br>
2. 星号、加好、减号的效果一致<br>
3. 连续两个空格会变成一个\<br>，\<br>的意思在 HTML中表示换行<br>
4. \反斜线可用来转义<br>
5. 连续三个减号，会显示分割线<br>

---
#       标题
#       this is an header leval 1 tag<br>
##      this is an header level 2 tag<br>
###     this is an header level 3 tag<br>
####    this is an header level 4 tag<br>
#####   this is an header level 5 tag<br>
######  this is an header level 6 tag (just only 6 header level in mark-down)<br>
---
#       字体<br>
*斜体*<br>
_斜体_<br>
**黑体**<br>
__黑体__<br>
~~删除线~~
---
#       列表
* item num 1<br>
* item num 2<br>
  * item num 2-1<br>
  * item num 2-2<br>
    * item num 2-2-1<br>
    * item num 2-2-2<br>
      * item num 2-2-1<br>
      * item num 2-2-2<br>
    * item num 2-2-3<br>
  * item num 2-2-3<br>
* item num 3<br>

1. item 1<br>
2. item 2<br>
   * item 2-1<br>
3. item 3<br>
   * item 3-1<br>
     * item 3-1-1<br>

#       图片和链接<br>
[Baidu](www.baidu.com)<br>
自动显示URL链接：https://www.baidu.com，www.baidu.com<br>
[Link](github.com)<br>
![picture die show this](http://7xp01z.com1.z0.glb.clouddn.com/books.png "mouse on shou this")<br>

#       引用文字<br>
The below is an example of block quotes.<br>
>       quoted num 1.<br>
>>      quoted num 2.<br>
>>>     quoted num 3.<br>
>>>>    quoted num 4.<br>
>>>>>   quoted num 5.<br>
>>>>>>  quoted num 6.<br>
>>>>>>> quoted num 7.<br>

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
if [ ${VAR} != "/home" ]
then
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

#       表格<br>
### work good, look good, src good
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

### work good, look good, src bad
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

#       任务列表<br>
- [x] taget list, num 1, @charlie<br>
- [x] taget list, num 2, @username<br>
- [ ] taget list, num 3<br>

#       表情列表<br>
:smile:         :smirk:
:laughing:      :satisfied:
