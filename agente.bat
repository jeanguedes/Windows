set maq=%1

::pega sessao do user
for /f "tokens=1,4 delims= " %%1 in ('tasklist /s %maq% /FI "IMAGENAME eq explorer.exe"') do set sessao=%%2

copy \\rs7876sr881\repinvent$\ScriptAg.cmd \\%maq%\c$\Temp\ScriptAg.cmd

psexec -s -i %sessao% -d \\%maq% c:\Temp\ScriptAg.cmd /norestart /quiet

echo "agente instalado com sucesso"


pause

