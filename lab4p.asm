code		segment
		assume	cs:code,ds:code
		public	word_count
; function WordCount(S: pchar; C: char): byte
; Возвращает количество слов в строке S ограниченных символaми С.
word_count	proc
s		equ	dword ptr [bp+4]
c		equ	byte ptr [bp+8]
ans		equ	cx		; ответ
cur		equ	al		; текущий символ
flag		equ	bl		; флаг начала нового слова

		push	bp
		mov	bp,sp

		lds	si,s
		xor	ans,ans		; обнуление ответа
		cld			; индексы строк++

begin:		lodsb
		cmp	cur,0		; сравнение текущего символа с концом строки
		je	exit
		cmp	cur,c		; сравнение текущего символа с разделяющим
		jne	letter		; если равно, то
		mov	flag,1		; флаг равен 1
		jmp	begin
letter:		test	flag,flag	; символ не разделяющий, сравнить флаг
		jz	begin		; если флаг != 0, то 
		inc	ans		; увеличение ответа
		xor	flag,flag	; обнуление флага
		jmp	begin

exit:		mov	ax,ans
		pop	bp
		ret	6
word_count	endp
code		ends
		end