includelib	../import32.lib
		extrn	ExitProcess: near
		extrn	SetFileAttributesA: near
		extrn	GetFileAttributesA: near
		extrn	GetStdHandle: near
		extrn	WriteConsoleA: near
		extrn	ReadConsoleA: near
		extrn	StrTrimA: near
		extrn	GetCommandLineA: near

SetFileAttributes	equ	SetFileAttributesA
FILE_ATTRIBUTE_HIDDEN	equ	2h

WriteConsole		equ	WriteConsoleA
STD_INPUT_HANDLE	equ	-10
STD_OUTPUT_HANDLE	equ	-11

ReadConsole	equ	ReadConsoleA
StrTrim		equ	StrTrimA
GetCommandLine	equ	GetCommandLineA
GetFileAttributes	equ	GetFileAttributesA