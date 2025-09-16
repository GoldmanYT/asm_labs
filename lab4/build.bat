set dll=word_count
set name=main

set compiler=..\tasm32
set linker=..\tlink32
set debugger=..\td32

%compiler% /ml %dll%.asm
pause

%linker% /Tpd /c %dll%.obj,,,,%dll%.def
pause

del /q word_count.map
del /q word_count.obj

..\implib %dll%.lib %dll%.dll
pause

%compiler% /ml %name%.asm
pause

%linker% /Tpe /aa /x /c %name%.obj
pause

del /q %name%.obj

%debugger% %name%.exe
