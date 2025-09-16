tasm32 /ml /l tst\deletech.asm
pause
tlink32 /Tpd /c deletech.obj,,,,tst\deletech.def
pause
tasm32 /ml /l tst\main.asm
pause
implib deletech.lib deletech.dll
pause
tlink32 /Tpe /aa /x /c main.obj