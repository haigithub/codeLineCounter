@echo off
set CurrentDir=%~dp0
rem echo %CurrentDir%
cd %CurrentDir%
rem pause
echo ������Ҫͳ�Ƶ��ļ���Ŀ¼(���������·��)
:Start
set /p DstFile=

if not exist %DstFile% ( echo ��������ļ�Ϊ�ջ򲻴��ڣ����������� 
@goto Start )

if not exist %DstFile%\  (echo ��������ļ�Ϊ %DstFile%
goto IsFile)
rem ������ļ�ΪĿ¼

dir %DstFile% /S/B /A:A > filefile
del filenames
del detail_record
echo ������Ҫ��ѯ�ļ�����: c cpp java s h
set /p FileType=
:STR_VISTOR
for /f "tokens=1,*" %%a in ("%FileType%") do (
	rem ��������滻���Լ��Ĵ����������ֻ�Ǽ򵥵���ʾֵ
	findstr \.%%a$ filefile >> filenames
	rem ��ʣ���ַ�����ֵ��str����
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
rem ������ļ��Ƿ�Ŀ¼�ļ�
awk95.exe -f line_counter.awk %DstFile%
goto :eof