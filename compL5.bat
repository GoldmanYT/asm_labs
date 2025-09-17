set folder=lab5
set name=%main
set func=func

set compiler=tasm
set linker=tlink
set debugger=td

%compiler% %folder%\%func%.asm
pause

%compiler% %folder%\%name%.asm
pause

%linker% %name%.obj+%func%.obj
pause

del %func%.obj
del %name%.obj
del %name%.map

%debugger% %name%.exe