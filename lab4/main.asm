include 	incfile.inc
includelib	word_count.lib
		extrn	word_count: near	; неявное связывание

		.386
		.model	FLAT, STDCALL

.const
libr		db	'word_count.dll', 0
nameproc	db	'word_count', 0
mb_title	db	'String:'
s		db	'  some  words with   spaces  ', 0
c		db	' '

.data
fmt		db	'Count1: %d', 13, 10, 'Count2: %d', 0
answer		db	32 dup(0)
hlib		dd	?
word_count2	dd	?
count1		dd	?
count2		dd	?

.code
_start:		call	LoadLibrary, offset libr
		mov	hlib, eax
		call	GetProcAddress,hlib, offset nameproc	; явное связывание
		mov	word_count2, eax

		call	word_count, offset s, word ptr c
		movzx	eax, al
		mov	count1, eax

		call	word_count2, offset s, word ptr c
		movzx	eax, al
		mov	count2, eax

		call	_wsprintfA, offset answer, offset fmt, count1, count2

		call	MessageBox, 0, offset answer, offset mb_title, MB_OK
		call	ExitProcess, 0
	        ends
		end	_start