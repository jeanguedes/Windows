@echo off

set maq=%1
set nomemaq=%maq%

if [%maq%] EQU [] set maq=127.0.0.1&set nomemaq=%computername%

set contador=0

:begin
::cd \
	.\tools\xnet list \\%maq%\mcshield| find /i "running" && goto :stopAV
	echo Iniciando o antivirus na estacao %nomemaq%. Aguarde...
	.\tools\xnet start \\%maq%\McAfeeFramework
	.\tools\xnet start \\%maq%\McAfeeEngineService
	.\tools\xnet start \\%maq%\McTaskManager
	.\tools\xnet start \\%maq%\McShield
	
goto end_ToggleAV

:StopAV

:iniciareg
.\tools\xnet modify \\%maq%\RemoteRegistry /s: auto /u:"NT AUTHORITY\LocalService">nul
.\tools\xnet start \\%maq%\RemoteRegistry>nul

	Echo Parando o antivirus na estacao %nomemaq%. Aguarde...
	
	.\tools\oreg update "HKLM\software\mcafee\desktopProtection\uip" \\%maq% 
	.\tools\oreg update "HKLM\software\mcafee\desktopProtection\uipmode=0" \\%maq% 
	.\tools\oreg update "HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\SystemCore\VSCore\On Access Scanner\BehaviourBlocking\PVSPTEnabled=0" \\%maq% 
	.\tools\oreg update "HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\SystemCore\VSCore\On Access Scanner\BehaviourBlocking\APEnabled=0" \\%maq% 
	
	
	::adicionado por felipe
	
	.\tools\oreg update "HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\SystemCore\VSCore\LockDownEnabled=0"
	.\tools\oreg update "HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\SystemCore\VSCore\On Access Scanner\BehaviourBlocking\APEnabled=0"
	
	.\tools\xnet stop \\%maq%\McAfeeEngineService 
	.\tools\xnet stop \\%maq%\McAfeeFramework 
	.\tools\xnet stop \\%maq%\McShield
	.\tools\xnet stop \\%maq%\McTaskManager 
	set /a contador+=1
	.\tools\xnet list \\%maq%\mcshield| find /i "running"
	if %errorlevel% EQU 0 if %contador% LSS 2 goto :StopAV
	
:End_ToggleAV
pause
