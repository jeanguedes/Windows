::Desenvolvido por: Felipe Baum - Analista TotalService GISUTPO
::Desenvolvido em: 08/2012
::Data ultima Alteracao: 06/08/2012
::For‡a a imposi‡Æo das politicas e atualiza o Host em Winxp, 2003, win7 e win8

@echo off
set maq=%1
set v1=00
set v2=01
echo Aguarde atualizando Antivirus...

ping -n 1 %maq% |find /i "bytes=32" >nul

:: Testa se a maquina esta desligada e pula para o fim
if %errorlevel% NEQ 0 echo %maq%>desligadas\%maq% & goto fim
if %errorlevel% NEQ 0 echo %maq%>>desligadas\np.txt & goto fim

:: Testa se a maquina ja fo atualizada e pula para o fim
if exist feitas\%maq% goto fim

:inicia registro remoto
:iniciareg
.\tools\xnet modify \\%maq%\RemoteRegistry /s: auto /u:"NT AUTHORITY\LocalService">nul
.\tools\xnet start \\%maq%\RemoteRegistry>nul

:continue

::testa se eh win8

for /f "delims=	 tokens=3" %%1 in ('.\tools\regxp query "HKLM\SOFTWARE\microsoft\windows nt\currentversion\currentversion" \\%1 ^|find /i "currentversion"') do set versao=%%1

if /i "%versao%" EQU "6.2" goto :testa_build

::testa_build
:testa_build
set build=x86

for /f "delims=	 tokens=3" %%1 in ('.\tools\regxp query "HKLM\SOFTWARE\microsoft\windows nt\currentversion\BuildLabEx" \\%maq% ^| find /i "amd64"') do set build=%%1
if /i "%build%" NEQ "x86" set build=x64

if /i "%build%" EQU "x64" goto :cont7
if /i "%build%" NEQ "x64" goto :contserv

if /i %versao% EQU 5.2 goto :contServ 
if /i %versao% EQU 5.1 goto :contServ
if /i %versao% NEQ 6.2 if /i %versao% NEQ 6.1 Echo Sistema Operacional do equipamento %MAQ% nao eh Windows7/Windows8 & goto :fim

:contServ
.\tools\pulist \\%maq% | find /i "mcupdate"
if %errorlevel% EQU 0 goto rodando
.\tools\pulist \\%maq% | find /i "mcscript_inuse"
if %errorlevel% EQU 0 goto rodando

for /f "tokens=3,4 delims=	 " %%1 in ('.\tools\xnet list \\%maq%\mcafeeframework ^|find /i "service state"') do set srvfrm=%%1 %%2
set versao=80

.\tools\regxp query "hklm\SOFTWARE\McAfee\ePolicy Orchestrator\Application Plugins\VIRUSCAN8800\install path" \\%maq%>nul
if %errorlevel% EQU 0 set versao=88

for /f "tokens=3 delims=	" %%1 in ('.\tools\regxp query "hklm\SOFTWARE\Network Associates\TVD\Shared Components\Framework\data path" \\%maq% ^| find /i "data path"') do set pathmanifest=%%1
for /f "tokens=3 delims=	" %%1 in ('.\tools\regxp query "hklm\SOFTWARE\McAfee\ePolicy Orchestrator\Application Plugins\VIRUSCAN8800\install path" \\%maq% ^| find /i "install path"') do set pathupdate=%%1
for /f "tokens=3 delims=	" %%1 in ('.\tools\regxp query "hklm\SOFTWARE\Network Associates\ePolicy Orchestrator\Agent\installed path" \\%maq% ^| find /i "installed path"') do set pathagent=%%1

goto :atualiza

:cont7
.\tools\pulist \\%maq% | find /i "mcupdate"
if %errorlevel% EQU 0 goto rodando
.\tools\pulist \\%maq% | find /i "mcscript_inuse"
if %errorlevel% EQU 0 goto rodando

for /f "tokens=3,4 delims=	 " %%1 in ('.\tools\xnet list \\%maq%\mcafeeframework ^|find /i "service state"') do set srvfrm=%%1 %%2
::if /i %srvfrm%! NEQ running! goto errosrv
set versao=80

.\tools\regxp query "hklm\SOFTWARE\Wow6432Node\McAfee\ePolicy Orchestrator\Application Plugins\VIRUSCAN8800\install path" \\%maq%>nul
if %errorlevel% EQU 0 set versao=88

for /f "tokens=3 delims=	" %%1 in ('.\tools\regxp query "hklm\SOFTWARE\Wow6432Node\Network Associates\TVD\Shared Components\Framework\data path" \\%maq% ^| find /i "data path"') do set pathmanifest=%%1
for /f "tokens=3 delims=	" %%1 in ('.\tools\regxp query "hklm\SOFTWARE\Wow6432Node\McAfee\ePolicy Orchestrator\Application Plugins\VIRUSCAN8800\install path" \\%maq% ^| find /i "install path"') do set pathupdate=%%1
for /f "tokens=3 delims=	" %%1 in ('.\tools\regxp query "hklm\SOFTWARE\Wow6432Node\Network Associates\ePolicy Orchestrator\Agent\installed path" \\%maq% ^| find /i "installed path"') do set pathagent=%%1

:atualiza
set pathagent=%pathagent%\
set pathmanifest=%pathmanifest%\

if %versao%! EQU 88! goto pulaxml

del \\%maq%\c$\temp\frameworkmanifest.xml
.\tools\robocopy . \\%maq%\c$\temp frameworkmanifest.xml robocopy.exe /z
.\tools\psexec -e -s \\%maq% del "%pathmanifest%"frameworkmanifest.xml /z
.\tools\psexec -e -s \\%maq% c:\temp\robocopy c:\temp "%pathmanifest%" frameworkmanifest.xml /z
.\tools\xnet start \\%maq%\McAfeeFramework
.\tools\xnet start \\%maq%\McShield
.\tools\xnet start \\%maq%\McTaskManager

:pulaxml

if not exist "\\%maq%\%pathagent::=$%cmdagent.exe" goto semexe
if not exist "\\%maq%\%pathupdate::=$%mcupdate.exe" goto semexe

.\tools\sleep 10
.\tools\psexec -e -s \\%maq% "%pathagent%cmdagent.exe" /P
.\tools\sleep 10
.\tools\psexec -e -s \\%maq% "%pathagent%cmdagent.exe" /E
.\tools\sleep 10
.\tools\psexec -e -s \\%maq% "%pathagent%cmdagent.exe" /C
.\tools\sleep 60
.\tools\psexec -e -s \\%maq% "%pathupdate%mcupdate.exe" /UPDATE /QUIET
.\tools\sleep 10

goto fim

:semexe
::net send %computername% Executavel nao encontrado
msg %USERNAME% /server:%computername% /time:3000 "Executavel nao encontrado"
goto fim

:newver
::net send %computername% Novas versoes dos Scripts disponiveis em \\rs7876NT412\avtoolsNew
msg %USERNAME% /server:%computername% /time:3000 "Novas versoes dos Scripts disponiveis em \\rs7876NT412\avtoolsNew"
goto fim

:errosrv
::net send %computername% Framework nao esta rodando
msg %USERNAME% /server:%computername% /time:3000 "Framework nao esta rodando"
goto fim

:rodando
call verav %maq%

goto fim

:fim
pause