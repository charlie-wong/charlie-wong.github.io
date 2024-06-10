rem 关闭回显 @echo off
::  打开回显 @echo on
@echo on

echo %PATH%

rem 正确显示中文
rem -> 换行符：CR LF
rem -> 字符编码选择 ANSI 或 GB2312
rem -> 特殊字符需要转义符前缀才能正常显示 ^! ^| ^& ^< ^> ^^
echo -^> 中文显示特殊字符 ^!  ^|  ^&  ^<  ^>  ^^

choice /C:YN /M "选择 Yes 或 No"
if ErrorLevel 1 goto Yes
if ErrorLevel 2 goto No

:Yes
echo 选择 Yes
pause
exit

:No
echo 选择 No
pause
