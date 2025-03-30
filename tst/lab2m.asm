sseg		segment	stack 'stack'
		dw	256 dup(?)
sseg		ends

data		segment
msg0		db	'S1 = S2$'
msg1		db	'S1 > S2$'
msg2		db	'S1 < S2$'
msg_err		db	'Error$'

S1		db	3,'123'
S2		db	3,'122'

; S1		db	3,'123'
; S2		db	3,'423'

; S1		db	3,'123'
; S2		db	3,'123'

; S1		db	3,'123'
; S2		db	5,'12345'

; S1		db	5,'12345'
; S2		db	3,'123'
data		ends

code		segment
		assume	cs:code,ds:data
		extrn	CompString:near

_start:		mov	ax,data
		mov	ds,ax

		mov	ax,seg S1
		push	ax
		mov	ax,offset S1
		push	ax
		mov	ax,seg S2
		push	ax
		mov	ax,offset S2
		push	ax
		call	CompString

case0:		cmp	al,0
		jne	case1
		lea	dx,msg0
		jmp	print_msg

case1:		cmp	al,1
		jne	case2
		lea	dx,msg1
		jmp	print_msg

case2:		cmp	al,2
		jne	err_case
		lea	dx,msg2
		jmp	print_msg

err_case:	lea	dx,msg_err

print_msg:	mov	ah,09h
		int	21h

		mov	ax,4c00h
		int	21h
code		ends
		end	_start