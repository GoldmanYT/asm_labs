include 	lab4\int2str.inc
		.386
		.model	FLAT,STDCALL

		.const
mb_title	db	'Lab 4',0
libr		db	'int2str.dll',0
nameproc	db	'int2str',0
.data
string		db	12 dup(?)
number		dd	-1234567890
hlib		dd	?
int2str		dd	?

.code
_start:		call	LoadLibrary,offset libr
		mov	hlib,eax
		call	GetProcAddress,hlib,offset nameproc
		mov	int2str,eax

		call	int2str,number,offset string
		call	MessageBox,0,offset string,offset mb_title,MB_OK
		call	ExitProcess,0
	        ends
		end	_start