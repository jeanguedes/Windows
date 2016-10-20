::Desenvolvido por: Felipe Baum - Analista TotalService GISUTPO
::Desenvolvido em: 08/2012
::Data ultima Alteracao: 11/04/2014
::Instala EPO em Winxp, 2003, win7 e win8


::@echo off
set maq=%1
set v1=00
set v2=01
set porIP=nao

for /f %%a in ('type \\rs7876nt412\avtoolsNew\versao.ini') do set v1=%%a
for /f %%a in ('type versao.ini') do set v2=%%a
if %v1% NEQ %v2% goto newver

if /i %maq:~0,2%! NEQ RS! set porIP=SIM
if %porIP% EQU SIM goto pula

if /i %maq:~6,2% NEQ SR if /i %maq:~6,2% NEQ NT if /i %maq:~6,2% NEQ EV if /i %maq:~6,2% NEQ EF if /i %maq:~6,2% NEQ ET if /i %maq:~6,2% NEQ NB if /i %maq:~6,2% NEQ PA goto :fim

:iniciareg
.\tools\xnet modify \\%maq%\RemoteRegistry /s: auto /u:"NT AUTHORITY\LocalService">nul
.\tools\xnet start \\%maq%\RemoteRegistry>nul
:pula
set ip=
set versao=
set dat=
set OS=5.1
ping -n 1 %maq% | find /i "bytes=32"
if %errorlevel% NEQ 0 goto fim
echo Maquina:     %maq%
.\tools\robocopy .\tools \\%maq%\c$\temp robocopy.exe /z
if %porIP% EQU nao for /f "tokens=2,3 delims=." %%1 in ('ping -n 1 %maq% ^| find /i "bytes=32"') do set ip=%%1.%%2.
if %porIP% EQU SIM for /f "tokens=2,3 delims=." %%1 in ('echo %maq%') do set ip=%%1.%%2.
for /f "tokens=1 delims=	 " %%1 in ('type \\rs7876nt412\AvToolsNew\repositorio.dat ^|find /i "%ip%"') do set repo=%%1
if exist \\%repo%\gisut\epo goto ok
set repo=RS7876NT015
:ok
echo Repositorio: %repo%
for /f "tokens=2 delims=	 " %%1 in ('.\tools\srvinfo -ns \\%maq% ^| find /i "version"') do set OS=%%1
echo WinVer:      %OS%

if %OS%! NEQ 5.2! if %OS%! NEQ 6.1! if %OS%! NEQ 5.0! if %OS%! NEQ 5.1! if %OS%! NEQ 6.2! goto :fim
::Copia do repositório local o EPO 4.6.0.1694 para windows 7
.\tools\psexec7 -e -s -h \\%maq% c:\temp\robocopy \\%repo%\epo_rep$\Current\EPOAGENT3000\Install\0409 c:\temp /z 
.\tools\psexec7 -e -s -h \\%1 c:\temp\framepkg.exe /install=agent /forceinstall /silent
::Mostra situacao da maquina apos atualizacao
.\Exec\Av\verav %1
goto :fim
:newver
msg %USERNAME% /server:%computername% /time:3000 "Novas versoes dos Scripts disponiveis em \\rs7876NT412\avtoolsNew"
goto fim
:fim