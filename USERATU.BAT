@echo off
cls
set est=\\%1 
.\tools\netusers %est% 
pause
