set folder=lab4\
set dll1=int2str
set dll2=word_count
set main=main
tasm32 /ml /l %folder%%dll1%.asm
timeout 100
tlink32 /Tpd /c %dll1%.obj,,,,%folder%%dll1%.def
timeout 100
tasm32 /ml /l %folder%%dll2%.asm
timeout 100
tlink32 /Tpd /c %dll2%.obj,,,,%folder%%dll2%.def
timeout 100
tasm32 /ml /l %folder%%main%.asm
timeout 100
implib %dll2%.lib %dll2%.dll
tlink32 /Tpe /aa /x /c %main%.obj
timeout 100
td32 %main%
