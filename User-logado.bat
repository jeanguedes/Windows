set maq=%1

ping -n 1 -w 3000 %maq% | find /i "bytes=32">nul

if %errorlevel% NEQ 0 echo %maq% >> desligada.log :fim

pulist %maq% | find /i "LogonUI"

if %errorlevel% EQU 0 echo %maq% >> estacao_liberada.log & :fim

echo %maq% >> usuario-na-trabalhando.log

:fim

