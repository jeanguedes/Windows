set maq=%1
set tempo=%2

.\tools\shutdown | find /i "Release 2.0"
if /i %errorlevel% EQU 0 goto :v2.0

:v1.0
.\tools\shutdown -r -f -t %tempo% -m \\%maq%
goto :fim

:v2.0
.\tools\shutdown \\%maq% /R /Y /C /T:%tempo%
:fim
