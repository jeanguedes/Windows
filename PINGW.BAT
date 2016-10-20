@echo off
set est=%1

title %est%
ping -a %est% -w 3000
