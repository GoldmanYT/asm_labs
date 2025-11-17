set compiler=tasm
set linker=tlink
set debugger=td
set name=LOCKER
set folder=lab7

%compiler% %folder%\%name%.asm
pause

%linker% %name%.obj /t
pause

del %name%.obj
del %name%.map

%name%.com