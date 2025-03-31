include 	lab4\int2str.inc
includelib	word_count.lib
		extrn	word_count:near

		.386
		.model	FLAT,STDCALL

		.const
libr		db	'int2str.dll',0
nameproc	db	'int2str',0
mb_title	db	'String:'
s		db	'  some  words with   spaces  ',0
c		dd	' '
		.data
string		db	'Count: '
count_str	db	12 dup(?)
number		dd	0
hlib		dd	?
int2str		dd	?

.code
_start:		call	LoadLibrary,offset libr
		mov	hlib,eax
		call	GetProcAddress,hlib,offset nameproc
		mov	int2str,eax

		call	word_count,offset s,c
		movzx	eax,al
		mov	number,eax

		call	int2str,number,offset count_str
		call	MessageBox,0,offset string,offset mb_title,MB_OK
		call	ExitProcess,0
	        ends
		end	_start