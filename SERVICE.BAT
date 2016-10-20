@echo off
cls
@echo ------------------------------------------------------------
@echo           Aguarde, Listando SERVICOS!......
@echo ------------------------------------------------------------
set est=\\%1
.\tools\xnet list  %est% |more
pause
