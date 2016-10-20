@echo off
set maq=%1
cls
ping -n 1 -w 3000 %maq% | find /i "bytes=32">nul

if %errorlevel% NEQ 0 goto :fim

for /f "tokens=1,5 delims= " %%1 in ('ping -n 1 -w 5000 %maq% ^|find /i "10"') do set ip=%%2
set ip=%ip::=%

for /F "tokens=1,5 delims=." %%1 in ('ping -a -n 1 -w 5000 %ip% ^|find /i "RS"') do set nome=%%1
set nome=%nome:~11,11%


echo.
echo.
echo ESTA€ÇO PESQUISADA:	%maq%
echo NOME RESOLVIDO:		%nome%
echo.
if /i [%maq%] NEQ [%nome%] echo Ping reverso falhou Verifique!!
if /i [%maq%] EQU [%nome%] echo   OK ! Nome confere !!
echo.

:fim
pause