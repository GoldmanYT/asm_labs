sseg		segment	stack 'stack'
		dw	256 dup(?)
sseg		ends

data		segment

		; 11000000 10000111 10011111 10110000
arr1		db	00000011b, 11100001b, 11111001b, 00001101b
size1		dw	$-arr1

		; 0000001000
str1		dd	0001000000b
len1		db	10

		; 10110000
str2		dd	00001101b
len2		db	8

		; 01010101
str3		dd	10101010b
len3		db	8

data		ends

code		segment
		assume  ds: data, cs: code, ss: sseg

		extrn	findBits: near
.386
callFindBits	macro	arr, size, string, len
		lea	bx, arr1
		mov	cx, size
		mov	eax, string
		mov	dl, len
		call	findBits
		endm

_start:		mov	ax, data
		mov	ds, ax
		mov	es, ax

		callFindBits	arr1, size1, str1, len1	; DI = 00002h
		callFindBits	arr1, size1, str2, len2	; DI = 0018h
		callFindBits	arr1, size1, str3, len3	; DI = FFFFh

		mov	ax, 4c00h
		int	21h
code		ends
		end	_start