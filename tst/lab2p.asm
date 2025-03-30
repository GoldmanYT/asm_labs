code		segment
		assume	cs:code,ds:code
		public	CompString

CompString	proc
S1		equ	dword ptr [bp+8]
S2		equ	dword ptr [bp+4]

		push	bp
		mov	bp,sp
		push	si
		push	di

		cld
		xor	cx,cx
		les	si,S2
		lodsb
		mov	cl,al
		mov	di,si

		les	si,S1
		lodsb
		cmp	al,cl

len1:		jbe	len2
ret1:		mov	al,1		; S1 > S2
		jmp	exit

len2:		jae	len3
ret2:		mov	al,2		; S1 < S2
		jmp	exit

len3:		test	cl,cl		; |S1| = |S2|
		jnz	loops

ret0:		mov	al,0		; S1 = S2
		jmp	exit

loops:		cmpsb
		ja	ret1
		jb	ret2
		loop	loops
		jmp	ret0

exit:		pop	di
		pop	si
		pop	bp
		ret	8
CompString	endp

code		ends
		end