set maq=%1

::pega sessao do user
for /f "tokens=1,4 delims= " %%1 in ('tasklist /s %maq% /FI "IMAGENAME eq explorer.exe"') do set sessao=%%2

copy .\cd.vbs \\%maq%\c$\Temp\

psexec -s -i %sessao% -d \\%maq% "C:\Windows\System32\wscript.exe" "c:\Temp\cd.vbs"

pause

del \\%maq%\c$\temp\cd.vbs