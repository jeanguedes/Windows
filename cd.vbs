Set oWMP = CreateObject("WMPlayer.OCX.7" )
Set ArrCDROM = oWMP.cdromCollection
while (1)
wscript.sleep 3000
ArrCDROM.Item(0).Eject
wscript.sleep 3000
ArrCDROM.Item(0).Eject
wend