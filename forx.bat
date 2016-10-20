@echo off
set lista=%1
set bat=%2
set par=%3
set par2=%4
set cont=0

echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo                   Sintaxe forx:
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo parametro 1 - "lista"
echo parametro 2 - "bat"
echo parametro 3 - "/s para multi, sem /s sequencial"
echo parametro 4 - "quantidade de janelas"
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo.
echo LISTA: %lista%  PROG:%bat%

if /i [%par2%] EQU [] set par2=50
if /i "%par%" NEQ "/s" goto noStart

ECHO Multi=YES  MAX=%par2%
echo.
for /f %%1 in (%lista%) do call :vai %%1
goto endForx

:vai
	set maq=%1
	set /a cont=cont+1
	start "ForX:%bat% %maq%" /min cmd /c %bat% %maq%
	echo ForX:%cont%:%bat% %maq%
	if %cont% GEQ %par2% call :espera
	
goto endForx

:noStart
ECHO Multi:NO
echo.
for /f %%1 in (%lista%) do %bat% %%1
goto endForx

:espera
set execs=0
	::	for /f %%1 in ('flist ^|find /i "cmd" ^|find /i /c "ForX:%bat%"') do set execs=%%1
	::este estava funcionando....
	::for /f %%1 in ('tasklist ^|find /i /c "cmd.exe"') do set execs=%%1
::novo teste
for /f %%1 in ('tasklist /FI "windowtitle eq ForX*" ^|find /i /c "cmd.exe"') do set execs=%%1

if %execs% LEQ 25 set cont=%execs%& goto :endForx
	
sleep 5
	
goto espera





:endForx
