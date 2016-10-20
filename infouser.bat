@echo off
set user=%1
cls
net user %user% /domain
pause
