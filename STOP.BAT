@echo off
	set maq=%1

	shutdown | find /i "Release 2.0"
	if /i %errorlevel% EQU 0 goto :v1.0

:v1.0
	shutdown /m \\%maq% /a

goto :fim

:v2.0
	shutdown /m %maq% /a

:fim