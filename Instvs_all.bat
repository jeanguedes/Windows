@echo off
if not exist maquinas.txt goto erro
maquinas.txt
for /f %%1 in (maquinas.txt) do start "%%1" /min cmd /C .\exec\av\instvs.bat %%1
goto fim

:erro
echo.
echo.
echo Falta a lista de maquinas (arquivo atu.txt)
echo.
echo.
pause
goto fim
:fim