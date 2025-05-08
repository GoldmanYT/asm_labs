set folder=doubleToString\
set name=show
set func=doubleToString
tasm32 /ml %folder%%func%.asm
pause
tasm32 /ml /l %folder%%name%.asm
pause
tlink32 /Tpe /aa /c /x %name%+%func%
pause
td32 %name%.exe