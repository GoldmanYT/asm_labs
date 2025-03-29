set main=main
set func=itos
tasm %func%.asm /l
pause
tasm %main%.asm /l
pause
tlink %main%+%func%
pause
td %main%.exe