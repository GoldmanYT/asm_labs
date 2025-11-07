includelib	../import32.lib
		extrn	ExitProcess: near
		extrn	GetStdHandle: near
		extrn	WriteConsoleA: near
		extrn	ReadConsoleA: near
		extrn	ReadConsoleInput: near
		extrn	SetConsoleCursorPosition: near

WriteConsole		equ	WriteConsoleA
STD_INPUT_HANDLE	equ	-10
STD_OUTPUT_HANDLE	equ	-11

ReadConsole	equ	ReadConsoleA
GetCommandLine	equ	GetCommandLineA
