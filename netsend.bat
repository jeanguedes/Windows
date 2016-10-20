@echo off
::set /p msg=Digite a sua mensagem:
set maq=%1
set texto=%2


TITLE NETSEND
::if exist C:\Sistemas\FenixVB\Exec\maquinas.txt del C:\Sistemas\FenixVB\Exec\maquinas.txt

::notepad maquinas.txt
::for /f %%f in (maquinas.txt) do call :rotina %%f

::goto fim_netsendio


:Begin
:rotina
::	set maq=%1
	::Verifica Versao SO
	:iniciareg
	xnet modify \\%maq%\RemoteRegistry /s: auto /u:"NT AUTHORITY\LocalService">nul
	xnet start \\%maq%\RemoteRegistry>nul
::Teste SO
::5.1=xp
::5.2=serevr
::6.2=win8
	for /f "delims=	 tokens=3" %%1 in ('.\tools\regxp query "HKLM\SOFTWARE\microsoft\windows nt\currentversion\currentversion" \\%maq% ^|find /i "currentversion"') do set OS=%%1
::	echo %os%
	if /i [%os%] EQU [5.1] goto :winxp
	if /i [%os%] EQU [6.2] goto :win8

	:win8
	.\tools\netusers \\%maq% | find /i "corpcaixa">nul
	if %errorlevel% EQU 0 goto :corp

	:port
	for /f "tokens=1,3 delims= " %%1 in ('.\tools\netusers \\%maq% ^| find /i "portoalegre"') do set usuario=%%1
	set usuario=%usuario:~-7%

:goto :envia

	:corp
	for /f "tokens=1,3 delims= " %%1 in ('.\tools\netusers \\%maq% ^| find /i "corpcaixa"') do set usuario=%%1
	set usuario=%usuario:~-7%

:envia
	.\tools\msg.exe %usuario% /server:%maq% /time:3000 "%texto%"

	goto :fim_netsendio

	:winxp
	.\tools\xnet modify \\%maq%\Messenger /s:auto>nul
	.\tools\xnet start \\%maq%\Messenger>nul
	.\tools\sleep 2
	psexec7 \\rs7876nt519 net send %maq% %texto%

goto :fim_netsendio

::envia
::	msg %usuario% /server:%maq% /time:3000 "%msg%"

:fim_netsendio
