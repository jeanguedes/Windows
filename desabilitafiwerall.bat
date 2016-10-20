set maq=%1

shutdown -r -f -m \\%1 -t 30
xnet stop \\%1\MpsSvc
xnet Modify \\%1\MpsSvc :disabled

pause
