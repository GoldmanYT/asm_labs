		.386
		.model	flat
		public	word_count

		.code

_start@12:	mov	al,1
		ret	12
; function WordCount(S: pchar; C: char): byte
; Возвращает количество слов в строке S ограниченных символaми С.
word_count	proc
s		equ	dword ptr [ebp+8]
c		equ	byte ptr [ebp+12]
ans		equ	cl		; ответ
cur		equ	al		; текущий символ
flag		equ	dl		; флаг начала нового слова

		push	ebp
		mov	ebp,esp
		push	esi

		mov	esi,s
		xor	ans,ans		; обнуление ответа
		mov	flag,1		; флаг равен 1
		cld			; индексы строк++

begin:		lodsb
		test	cur,cur		; сравнение текущего символа с концом строки
		jz	exit
		cmp	cur,c		; сравнение текущего символа с разделяющим
		jne	letter		; если равно, то
		mov	flag,1		; флаг равен 1
		jmp	begin
letter:		test	flag,flag	; символ не разделяющий, сравнить флаг
		jz	begin		; если флаг != 0, то 
		inc	ans		; увеличение ответа
		xor	flag,flag	; обнуление флага
		jmp	begin

exit:		pop	esi
		mov	al,ans
		pop	ebp
		ret	8
word_count	endp
		end	_start@12