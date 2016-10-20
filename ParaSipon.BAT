@echo off
cls

set est=%1
ping -n 1 -w 3000 %est% | find /i "bytes=32">nul
if %errorlevel% NEQ 0 echo DESLIGADA& goto :fim

.\tools\xnet stop \\%est%\ClienteSipon>nul
echo.
echo Servi‡o Sipon Parado com sucesso na esta‡Æo %est%!
echo.
:fim
pause
