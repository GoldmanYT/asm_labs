set folder=tst\
set main=lab2m
set func=lab2p
tasm %folder%%func%.asm /l
pause
tasm %folder%%main%.asm /l
pause
tlink %main%+%func%
pause
td %main%.exe