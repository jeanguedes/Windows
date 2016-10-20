@echo off
Title Wake On Lan
set maq=%1
set servidorDHCP=10.68.10.40
set ip=n/d
set subrede=n/d
set escopo=n/d
set macadress=n/d
set cont=1
set dbserver=rs7876nt004
set cont=0
set flag=NO
set flag2=0
set camelo=%maq:~0,6%NT002

	cls
	Echo AGUARDE....Pesquisando MAcAdress no servidor DB...
	for /f %%1 in ('.\isql -S" %dbserver% -n -h-1 -d TELEDATA -U acesso -P acesso -Q "SELECT MAC from WOLtable where Nomemaq='%maq%'"^| find /i /v "affected"') do set flag=%%1
	if /i [%flag%] NEQ [no] set flag2=1
	
	
:inicio
	for /f "tokens=1,3 delims= " %%1 in ('ping -n 1 -w 5000 %maq% ^|find /i "[10."') do set ip=%%2
	set ip=%ip:[=%
	set ip=%ip:]=%
:ip	
	echo %ip%>.\ip.txt
	for /f "tokens=1 delims=." %%1 in (.\ip.txt) do set oc1=%%1
	for /f "tokens=2 delims=." %%1 in (.\ip.txt) do set oc2=%%1
	for /f "tokens=3 delims=." %%1 in (.\ip.txt) do set oc3=%%1
	for /f "tokens=4 delims=." %%1 in (.\ip.txt) do set oc4=%%1
	::set subrede=%ip:~0,7%
	set subrede=%oc1%.%oc2%.%oc3%
	if /i %flag2% EQU 1 set macadress=%flag% & goto :show
::goto :fim
	set escopo=%subrede%.0
	::pega campo mac adress
	::netsh dhcp server %servidorDHCP% scope %escopo% show clients | find /i "%ip%"
	cls
	Echo AGUARDE....Pesquisando MAcAdress no servidor %servidorDHCP%
	netsh dhcp server %servidorDHCP% scope %escopo% show clients | find /i "%ip%">.\x.txt
	for /F "tokens=5 eol= " %%1 in (.\x.txt) do set macadress=%%1
	type Q:\bkp jean\Nova pasta\WakeonLan\x.txt | find /i "NUNCA ESPIRA"
	if %errorlevel% EQU 0 for /F "tokens=4 delims= " %%1 in (.\x.txt") do set macadress=%%1
	type C:\Sistemas\FenixVB\Exec\WakeOnLanB\x.txt | find /i "INATIVO"
	if %errorlevel% EQU 0 for /F "tokens=4 delims= " %%1 in (.\x.txt") do set macadress=%%1
	set macadress=%macadress:-=%
	if /i [%macadress%] EQU [n/d] goto :server2
:show
	echo.
	echo estacao	%maq%
	echo ip	%ip%
	echo mac	%macadress%
	echo camelo	%camelo%

:gravaDB
	::grava no banco
	if /i [%flag2%] NEQ [1] .\isql -S %dbserver% -n -h-1 -d TELEDATA -U acesso -P acesso -Q" "insert into WOLtable VALUES ('%maq%','%ip%','%macadress%')"
	
	::testa se esta ligado
	echo.
	ping -n 1 -w 3000 %maq% | find /i "bytes=32">nul
	if %errorlevel% EQU 0 Echo equipamento ja esta ligado, nada a fazer ! & goto :fim
	set /p power=Voce quer tentar ligar este equipamento (S/N)? 
	if /i [%power%] EQU [S] goto :liga
	
goto :fim

:server2
	set /a cont=%cont%+1
	if /i [%cont%] GTR [2] goto :DB
	cls
	set servidorDHCP=10.68.4.33
	Echo AGUARDE....Pesquisando MAcAdress no servidor %servidorDHCP%
	goto :inicio

:DB
	cls
	echo Aguarde...Pesquisando no DB...
	
	::pesquisa no banco
	for /f %%1 in (.\isql -S %dbserver% -n -h-1 -d TELEDATA -U acesso -P acesso -Q "SELECT MAC from WOLtable where Nomemaq='%maq%'"^| find /i /v "affected"') do set macadress=%%1

goto :show

:liga
	copy .\wolcmd.exe \\%camelo%\C$\temp /z
	Title Tentando ligar a esta‡Æo %maq%
	C:\Sistemas\FenixVB\tools\psexec -s \\%camelo% c:\temp\wolcmd.exe %macadress% %ip% 255.255.255.0 7
	if %errorlevel% EQU 0 start ping -t -w 3000 %maq%
goto :fim


:fim
if exist .\x.txt" del .\x.txt >nul
if exist .\ip.txt del .\ip.txt >nul
pause

