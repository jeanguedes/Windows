@echo off

::set servidorFenixVB=\\rs7876nt519\fenixVB
::set pastaFenixVBLocal=C:\Sistemas\FenixVB

::for /f %%a in ('type %servidorFenixVB%\versao.ini') do set v1=%%a
::for /f %%a in ('type %pastaFenixVBLocal%\versao.ini') do set v2=%%a

::if not exist C:\Sistemas\FenixVB\versao.ini call .\bats\atualiza.bat

::if %v1% EQU %v2% goto :fim_atu
del /q C:\Sistemas\FenixVB\versao.ini

.\tools\sleep 2
call .\bats\atualiza.bat


:fim_atu
call .\exec\control.bat

