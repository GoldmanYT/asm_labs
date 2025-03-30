set folder=lab4\
set dll=int2str
set main=main
tasm32 /ml /l %folder%%dll%.asm
timeout 100
tlink32 /Tpd /c %dll%.obj,,,,%folder%%dll%.def
timeout 100
tasm32 /ml /l %folder%%main%.asm
timeout 100
tlink32 /Tpe /aa /x /c %main%.obj
timeout 100
td32 %main%
