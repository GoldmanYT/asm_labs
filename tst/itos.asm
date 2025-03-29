code		segment
		assume	cs:code,ds:code
		.386
		public	short_to_str
; void short_to_str(short src, char* dest)
; функция переводит число src в строку и располагает в dest
; в dest должно хватать байт для записи (7 байт)
short_to_str	proc

src		equ	word ptr [ebp+6]
dest		equ	dword ptr [ebp+8]

		push	ebp
		mov	ebp,esp
		push	si
		push	edi

		mov	ax,src		; ax = число
		mov	si,0		; si = знак
		mov	bx,10		; bx = 10 (СС)
		push	0		; завершающий символ

		cmp	ax,0
		jge	get_digits	; если число < 0, то
		mov	si,1		; si = 1
		neg	ax

get_digits:	cmp	ax,bx		; число >= 10
		jb	last_digit
		xor	dx,dx		; подготовка dx для деления
		div	bx		; ax = частное; dx = остаток
		add	dx,30h		; dx += код нуля
		push	dx
		jmp	get_digits

last_digit:	add	ax,30h		; ax += код нуля
		push	ax

		test	si,si
		jz	write		; есть ли знак
		push	'-'

write:		les	di,dest		; адрес начала строки
		cld			; индексы строк++
write_next:	pop	ax
		stosb			; запись символа в строку
		cmp	al,0		; если строка закончилась, то
		jne	write_next	; выход

		pop	edi
		pop	si
		pop	ebp
		ret	6
short_to_str	endp

code		ends
		end