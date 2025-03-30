		.386
		.model	flat
		public	int2str_asm	; eax -> [edx]
		public	int2str		; void int2str(int, char*)

		.code
_start@12:	mov	al,1
		ret	12

int2str		proc
		pop	ecx
		pop	eax
		pop	edx
		push	ecx
int2str		endp

int2str_asm	proc
		push	si
		push	edi

		push	0		; завершнающий символ
		xor	si,si		; знак
		mov	edi,edx		; указатель начала строки
		push	ds
		pop	es		; загрузка регистра es
		mov	ecx,10		; основание СС
		cld			; адреса строк++

		cmp	eax,0
		jge	convert
		neg	eax
		mov	si,1		; si = 1 => есть минус

convert:	cmp	eax,ecx
		jl	last_digit
		xor	edx,edx
		div	ecx
		add	edx,30h		; код символа
		push	edx		; в стек
		jmp	convert

last_digit:	add	eax,30h		; код символа
		push	eax		; в стек

		test	si,si		; проверка знака
		jz	write
		push	'-'

write:		pop	eax
		stosb
		test	eax,eax		; проверка конца строки
		jnz	write

		pop	edi
		pop	si
		ret
int2str_asm	endp
		end	_start@12