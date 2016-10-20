@echo off
set est=%1
set processo=%2

cls
color 2F
cls
@echo -------------------------------------------------------
@echo    AGUARDE, FINALIZANDO O PROCESSO SELECIONADO......
@echo -------------------------------------------------------
set est=%1
set processo=%2

taskkill /s \\%est% /IM %processo%

PAUSE