set compiler=..\tasm32.exe
set linker=..\tlink32.exe
set debugger=..\td32.exe
set name=main
set filepath=example.txt

%compiler% /ml %name%.asm
pause

%linker% /Tpe /ap /x /c %name%.obj
pause

del /q %name%.obj
del /q %name%.map

@REM %debugger% %name%.exe %filepath%
%name%.exe %filepath%
pause
