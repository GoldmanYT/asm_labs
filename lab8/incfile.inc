includelib	../import32.lib
		extrn	ExitProcess: near
		extrn	SetFileAttributesA: near
		extrn	GetStdHandle: near
		extrn	WriteConsoleA: near
		extrn	ReadConsoleA: near
		extrn	StrTrimA: near

SetFileAttributes	equ	SetFileAttributesA
FILE_ATTRIBUTE_READONLY equ	1h

WriteConsole		equ	WriteConsoleA
STD_INPUT_HANDLE	equ	-10
STD_OUTPUT_HANDLE	equ	-11

ReadConsole	equ	ReadConsoleA
StrTrim		equ	StrTrimA
