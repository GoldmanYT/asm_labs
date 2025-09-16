includelib	../import32.lib
		extrn	MessageBoxA: near
		extrn	ExitProcess: near
		extrn	LoadLibraryA: near
		extrn	FreeLibrary: near
		extrn	GetProcAddress: near
		extrn	_wsprintfA: near

MessageBox	equ	MessageBoxA
LoadLibrary	equ	LoadLibraryA
MB_OK		equ	00000h