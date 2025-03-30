set folder=lab3
set name=lab3
tasm %folder%\%name%.asm /l
pause
tlink %name%.obj
pause
td %name%.exe