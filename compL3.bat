set folder=lab3
set name=lab3
set asm_path=%folder%\%name%.asm
tasm %asm_path%
pause
tlink %name%.obj
pause

del %name%.obj
del %name%.map

td %name%.exe
