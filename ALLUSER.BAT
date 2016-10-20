@echo off
cls
set est=\\%1
set estacao=%1

title .::    %estacao%    ::.

.\tools\netusers %est% /h |more
pause
