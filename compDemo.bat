set compiler=tasm
set linker=tlink
set debugger=td
set debug=1
set name=demo
set folder=lab6

%compiler% %folder%\%name%.asm
pause

%linker% %name%.obj /t
pause

del %name%.obj
del %name%.map

%name%.com