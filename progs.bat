@echo off
set "lc="
if [%1] EQU [] set maq=%computername% & set lc=LOCAL & goto local

CLS
echo.
echo ----------------------------------------------------------
echo  LISTAGEM DOS PROGRAMAS INSTALADOS NA ESTACAO %LC%%1
echo ----------------------------------------------------------
echo.
echo.
echo Aguarde... Conectando na estacao...
set maq=%1

:local
ping %maq% -n 2 -w 3000 | find /i "Resposta de" > nul
if not %errorlevel%==0 ECHO. & ECHO A estacao %maq% nao pode ser encontrada. Abortado. & echo ---------------------------------------------------------- & goto fim

.\TOOLS\xnet modify \\%maq%\RemoteRegistry /s: auto /u:"NT AUTHORITY\LocalService">nul
.\TOOLS\xnet start \\%maq%\RemoteRegistry>nul
.\tools\regxp query HKLM\software\microsoft\windows\currentVersion\uninstall /s \\%maq%|find /i "displayname" |find /i /v "QuietDisplayName" > %temp%\progs.tmp

CLS
echo.
echo ----------------------------------------------------------
echo  LISTAGEM DOS PROGRAMAS INSTALADOS NA ESTACAO %LC%%1
echo ----------------------------------------------------------

for /f "tokens=2-12" %%a in (%temp%\progs.tmp) do call :extrai %%a %%b %%c %%d %%e %%f %%g %%h %%i
echo ----------------------------------------------------------
pause
goto fim

:extrai

echo %2 %3 %4 %5 %6 %7 %8 %9


:fim
