@echo off
set maq=%computername%
set servidorFenixVB=\\rs7876nt519\fenixVB
set pastaFenixVBLocal=C:\Sistemas\FenixVB

:iniciareg
.\tools\xnet modify \\%maq%\RemoteRegistry /s: auto /u:"NT AUTHORITY\LocalService">nul
.\tools\xnet start \\%maq%\RemoteRegistry>nul
::Teste SO
::5.1=xp
::5.2=serevr
::6.2=win8
for /f "delims=	 tokens=3" %%1 in ('.\tools\regxp query "HKLM\SOFTWARE\microsoft\windows nt\currentversion\currentversion" \\%maq% ^|find /i "currentversion"') do set OS=%%1
if /i [%os%] EQU [5.1] goto :NaoRola
if /i [%os%] EQU [6.2] goto :testa_build
::testa_build
:testa_build
	set build=x86
		for /f "delims=	 tokens=3" %%1 in ('.\tools\regxp query "HKLM\SOFTWARE\microsoft\windows nt\currentversion\BuildLabEx" \\%maq%^| find /i "amd64"') do set build=%%1
			if /i "%build%" NEQ "x86" set build=x64
			if /i "%build%" EQU "x64" goto :Ta_tri
			if /i "%build%" EQU "x86" goto :NaoRola

::avisa que nao rola e cai fora
:NaoRola
	if exist "C:\Documents and Settings\All Users\*.*" net send %computername% ATENCAO ESTA VERSAO DO FENIXVB SO FUNCIONA EM SISTEMAS DE 64 BITS
	if exist C:\Users\Public\Desktop .\tools\msg %USERNAME% /server:%computername% /time:3000 "ATENCAO ESTA VERSAO DO FENIXVB SO FUNCIONA EM SISTEMAS DE 64 BITS"

	.\tools\pskill FenixVB.exe>nul
	taskkill /IM FenixVB.exe>nul
	if exist  C:\Users\Public\Desktop del /q C:\Users\Public\Desktop\FenixVB.lnk>nul
	if exist  "C:\Documents and Settings\All Users\Desktop\FenixVB.lnk" del /q "c:\Documents and Settings\All Users\Desktop\FenixVB.lnk"
	.\tools\sleep 5
	RD /S /Q C:\SISTEMAS\FENIXVB>nul
	
	goto :fim_atualizacao

:ta_tri
if not exist %pastaFenixVBLocal%\versao.ini goto :sem_versao

for /f %%a in ('type %servidorFenixVB%\versao.ini') do set v1=%%a
for /f %%a in ('type %pastaFenixVBLocal%\versao.ini') do set v2=%%a
if %v1% NEQ %v2% goto :newver


goto :fim_atualizacao


:sem_versao
	if not exist c:\sistemas md c:\sistemas
	if not exist c:\sistemas\FenixVB md c:\sistemas\FenixVB
	icacls c:\sistemas | find /i "CORPCAIXA\Domain Users:(OI)(CI)(F)"
	if %errorlevel% NEQ 0 icacls c:\sistemas /T /C /grant "corpcaixa\domain users":(OI)(CI)F
	taskkill /IM FenixVB.exe
	robocopy %servidorFenixVB% %pastaFenixVBLocal% /e /z /mir
	::Copia Link da app
	if exist  C:\Users\Public\Desktop copy %servidorFenixVB%\FenixVB.lnk C:\Users\Public\Desktop /y
	if exist  "C:\Documents and Settings\All Users\Desktop" copy %servidorFenixVB%\FenixVB.lnk "c:\Documents and Settings\All Users\Desktop" /y
	.\tools\reg832.exe Add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "c:\sistemas\FenixVB\FenixVB.exe" /d "~ RUNASADMIN" /f
	.\tools\reg864.exe Add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "c:\sistemas\FenixVB\FenixVB.exe" /d "~ RUNASADMIN" /f
	.\tools\msg %USERNAME% /server:%computername% /time:3000 "Sua vers∆o do FenixVB foi atualizada com base no servidor %servidorFenixVB%"
	start c:\sistemas\fenixvb\fenixVB.exe
	
goto :fim_atualizacao
:newver
if not exist c:\sistemas md c:\sistemas
	if not exist c:\sistemas\FenixVB md c:\sistemas\FenixVB
	icacls c:\sistemas | find /i "CORPCAIXA\Domain Users:(OI)(CI)(F)"
	if %errorlevel% NEQ 0 icacls c:\sistemas /T /C /grant "corpcaixa\domain users":(OI)(CI)F
	taskkill /IM FenixVB.exe
	robocopy %servidorFenixVB% %pastaFenixVBLocal% /e /z /mir
	::Copia Link da app
	if exist  C:\Users\Public\Desktop copy %servidorFenixVB%\FenixVB.lnk C:\Users\Public\Desktop /y
	if exist  "C:\Documents and Settings\All Users\Desktop" copy %servidorFenixVB%\FenixVB.lnk "c:\Documents and Settings\All Users\Desktop" /y
	.\tools\reg832.exe Add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "c:\sistemas\FenixVB\FenixVB.exe" /d "~ RUNASADMIN" /f
	.\tools\reg864.exe Add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "c:\sistemas\FenixVB\FenixVB.exe" /d "~ RUNASADMIN" /f
	.\tools\msg %USERNAME% /server:%computername% /time:3000 "Sua vers∆o do FenixVB foi atualizada com base no servidor %servidorFenixVB%"
	start c:\sistemas\fenixvb\fenixVB.exe

:fim_atualizacao
call .\exec\control.bat