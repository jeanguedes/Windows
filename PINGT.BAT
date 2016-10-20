@echo off
set est=%1

title .::    %est%    ::.
ping %est% -t -w 3000

pause