@echo off
cls
@echo -------------------------------------------------------------
@echo    Aguarde, listando os PROCESSOS ativos na estacao!......
@echo -------------------------------------------------------------
set est=%1
tasklist /s \\%est% | more
PAUSE