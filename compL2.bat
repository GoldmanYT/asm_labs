set main=lab2m
set func=lab2p
tasm %func%.asm /l
pause
tasm %main%.asm /l
pause
tlink %main%+%func%
pause
td %main%.exe