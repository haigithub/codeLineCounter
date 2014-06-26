@echo off
set CurrentDir=%~dp0
rem echo %CurrentDir%
cd %CurrentDir%
rem pause
echo 请输入要统计的文件或目录(请输入绝对路径)
:Start
set /p DstFile=

if not exist %DstFile% ( echo 您输入的文件为空或不存在，请重新输入 
@goto Start )

if not exist %DstFile%\  (echo 您输入的文件为 %DstFile%
goto IsFile)
rem 输入的文件为目录

dir %DstFile% /S/B /A:A > filefile
del filenames
del detail_record
echo 请输入要查询文件类型: c cpp java s h
set /p FileType=
:STR_VISTOR
for /f "tokens=1,*" %%a in ("%FileType%") do (
	rem 这里可以替换成自己的处理程序，现在只是简单地显示值
	findstr \.%%a$ filefile >> filenames
	rem 将剩余字符串赋值给str变量
	set FileType=%%b
	goto STR_VISTOR
)

for /f "" %%a in (filenames) do (
	awk95.exe -f line_counter.awk %%a >> detail_record
	rem echo %%a
)

awk95.exe -f line_sum.awk detail_record
goto :eof

:IsFile
rem 输入的文件是非目录文件
awk95.exe -f line_counter.awk %DstFile%
goto :eof