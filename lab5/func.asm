; Написать процедуру, производящую поиск заданной
; цепочки бит в массиве. Адрес массива задается парой ES:BX,
; длина (в байтах) - регистром CX. Битовая строка записывается в
; регистр EAX, начиная с младшего бита, количество бит в строке
; указывается в регистре DL. Процедура возвращает в регистре DI
; значение 0FFFFh, если строка не найдена, или номер первого
; бита строки.

; def find_bits(es_bx, cx, eax, dl):
;     for start_bit in range(cx * 8 - dl + 1):
;         found = True
;         for check_bit in range(dl):
;             if es_bx[start_bit + check_bit] != eax[check_bit]:
;                 found = False
;                 break
;         if found:
;             di = start_bit
;             break
;     else:
;         di = -1
;     return di

code		segment
		assume	cs: code

		public	findBits
.386
findBits	proc
		; eax:	битовая строка
		; bx:	массив байт
		; cx:	длина массива (в байтах)
		; dl:	длина битовой строки
		; dh:	значение бита из массива
		; bp:	индекс проверяемого бита в массиве
		; esi:	индекс проверяемого бита в битовой строке
		; di:	индекс начального бита в массиве
		
		xor	di, di		; индекс начального бита = 0
		shl	cx, 3		; находим последний индекс
		xor	dh, dh		; начального бита в массиве:
		sub	cx, dx		; cx * 8 - dl + 1
		inc	cx

startBitLoop:	mov	bp, di		; индекс проверяемого бита в массиве = индексу начального бита
		xor	esi, esi		; индекс проверяемого бита в строке = 0

checkBitLoop:	xor	dh, dh		; бит массива = 0
		bt	es:[bx], bp	; считать бит массива в CF
		jnc	arr0		; если CF = 0, то переход

arr1:		mov	dh, 1		; иначе бит массива = 1
arr0:		bt	eax, esi	; считать бит строки в CF
		jnc	bits0		; если CF = 0, то переход

bits1:		xor	dh, 1		; иначе инвертируем бит массива
bits0:		test	dh, dh		; т.о. если биты равны, то DH = 0
		jnz	nextBit		; если биты не равны, то переход

		inc	bp		; увеличить индекс бита в массиве
		inc	esi		; увеличить индекс бита в битовой строке
		xor	dh, dh		; DH = 0, для сравнения
		cmp	si, dx		; если достигнут конец битовой строки
		jae	found		; то проверены все биты и можно вернуть ответ
		jmp	checkBitLoop	; иначе рассматриваем следующий бит

nextBit:	inc	di
		cmp	cx, di
		jae	startBitLoop

notFound:	mov	di, -1
found:		ret

findBits	endp

code		ends
		end