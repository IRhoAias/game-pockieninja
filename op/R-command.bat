rem @ECHO OFF
set SSHpath=C:\cwRsyncServer\bin
set SSH=C:\cwRsyncServer\bin\ssh
@ECHO. #######��ȡ�����ɹ�#######


for /f "tokens=1,2 delims=," %%i in (D:\op\game.txt) do  start %ssh% %%i "/cygdrive/d/op/scripts/Dream2Info.exe"
