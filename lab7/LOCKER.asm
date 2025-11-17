
;##########################################################
;##                                                      ##
;##         ┌─────────────────────────────────┐          ##
;##         │ П Р О Г Р А М М А   L O C K E R │          ##
;##         └─────────────────────────────────┘          ##
;##                                                      ##
;## Это резидентная программа COM типа, "запирающая" на  ##
;## время  клавиатуру. Программа  перехватывает  вектор  ##
;## прерывания Int09 и занимает в резиденте 5232 байт.   ##
;##                                                      ##
;##########################################################


PROGRAM		segment
        	assume	cs: PROGRAM
          	org	100h		; пропуск PSP для COM-программы

Start:		jmp	InitProc	; переход на инициализацию


;--------- Р Е З И Д Е Н Т Н Ы Е   Д А Н Н Ы Е ------------

FuncNum		equ	0EEh		; несуществующая функция пре-
					; рывания BIOS Int16h
CodeOut		equ	2D0Ch		; код,возвращаемый нашим об-
					; работчиком Int16h
TestInt09	equ	9D0Ah		; слово перед Int09h
TestInt16	equ	3AFAh		; слово перед Int16h

OldInt09	label	dword		; сохраненный вектор Int09h:
OfsInt09	dw	?		; его смещение
SegInt09	dw	?		; и сегмент

OldInt16	label	dword		; сохраненный вектор Int16h:
OfsInt16	dw	?		; его смещение
SegInt16	dw	?		; и сегмент

OK_Text		db	0		; признак гашения экрана
Sign		db	?		; колличество нажатий Ctrl
VideoLen	equ	800h		; длина видеобуфера

VideoBuf	db	160 dup(' ')
		db	13 dup(' ')
		db	'╔════════════════════════════════════════════════════╗'
		db	 26 dup(' ')
		db	'║                                                    ║'
		db	 26 dup(' ')
		db	'║   Для разблокировки нажмите три раза LeftControl   ║'
		db	 26 dup(' ')
		db	'║                                                    ║'
		db	 26 dup(' ')
		db	'║                                                    ║'
		db	 26 dup(' ')
		db	'╚════════════════════════════════════════════════════╝'
		db	2000 dup(' ')

AttrBuf		db	VideoLen dup(07h)	; атрибуты экрана
VideoBeg	dw	0B800h			; адрес начала видеообласти
VideoOffs	dw	?			; смещение активной страницы
CurSize		dw	?			; сохраненный размер курсора

;------ Р Е З И Д Е Н Т Н Ы Е   П Р О Ц Е Д У Р Ы ---------

; ПОДПРОГРАММА ОБМЕНА ВИДЕООБЛАСТИ С БУФЕРОМ ПРОГРАММЫ

VideoXcg	proc
		lea	di, VideoBuf	;в di - адрес буфера символов
		lea	si, AttrBuf	;в si - адрес буфера атрибутов

		mov	ax, VideoBeg	;┐в es - сегментный адрес
		mov	es, ax		;┘начала видеообласти

		mov	cx, VideoLen	;в cx - длина видеобуфера
		mov	bx, VideoOffs	;в bx - нач. смещение строки

Draw:		mov	ax, es:[bx]	;┐обменять символ/атрибут на
		xchg	ah, ds:[si]	;│экране с символом и атрибу-
		xchg	al, ds:[di]	;│том из буферов
		mov	es:[bx], ax	;┘
		
		inc	si		;┐увеличить адрес
		inc	di		;┘в буферах
		
		inc	bx		;┐увеличить адрес
		inc	bx		;┘в видеобуфере
		
		loop	Draw		; сделать для всей видеообласти
		ret			; возврат
VideoXcg	endp

;ОБРАБОТЧИК ПРЕРЫВАНИЯ Int09h (ПРЕРЫВАНИЕ ОТ КЛАВИАТУРЫ)

		dw	TestInt09	; слово для обнаружения перехвата

Int09Hand	proc
		push	ax		;┐
		push	bx		;│
		push	cx		;│сохранить
		push	di		;│используемые
		push	si		;│регистры
		push	ds		;│
		push	es		;┘

		push	cs		;┐указать ds на
		pop	ds		;┘нашу программу

		in	al, 60h		;получить скан код нажатой клавиши

		cmp	al, 26h		;┐проверить на скан-код клавиши
		jne	Exit_09		;┘<L> и выйти, если не он

		xor	ax, ax		;┐
		mov	es, ax		;│проверить флаги клавиатуры на
		mov	al, es:[418h]		;│нажатие <Ctrl+Alt>
		and	al, 03h		;│
		cmp	al, 03h		;│
		je	Cont		;┘

Exit_09:	jmp	Exit09		; выход

Cont:		sti			; разрешить прерывания

		mov	ah,0Fh		;┐получить текущий
		int	10h		;┘видеорежим
		cmp	al,2		;┐
		je	InText		;│перейти на InText
		cmp	al,3		;│если режим
		je	InText		;│текстовый 80#25
		cmp	al,7		;│
		je	InText		;┘
		
		jmp	short SwLoop1	; иначе - пропустить

InText:		xor	ax, ax		;┐установить сегментный
		mov	es, ax		;┘адрес в 0000h

		mov	ax, es:[44Eh]	;┐получить смещение активной
		mov	VideoOffs,ax	;┘страницы в VideoOffs

		mov	ax, es:[44Ch]	;┐сравнить длину видеобуфера
		cmp	ax, 1000h	;│с 1000h.Если не равно,
		jne	Exit009		;│то режим EGA Lines
					;┘(экран тушить не надо)
		mov	ah, 03h		;┐иначе сохранить
		int	10h		;│размер курсора
		mov	CurSize,cx	;┘в CurSize

		mov	ah, 01h		;┐
		mov	CH, 20h		;│и подавить его
		int	10h		;┘

		mov	OK_Text, 01h	; установить признак гашения
					; экрана
		call	VideoXcg	; и вызвать процедуру гашения

SwLoop1:	in	al, 60h		; в al - код нажатой клавиши
		cmp	al, 1Dh		;┐если нажата Ctrl - то на
		je	SwLoop2		;┘проверку отпускания
		cmp	al, 9Dh		;┐если была отпущена Ctrl, то
		je	SwLoop1		;┘дальше на опрос клавиатуры
		mov	Sign, 0		; иначе сбросить кол-во нажатий
		jmp	short SwLoop1	; и снова на опрос клавиатуры

SwLoop2:	in	al, 60h		;в al - скан код клавиши
		cmp	al, 9Dh		;┐если не код отпускания Ctrl, то
		jne	SwLoop2		;┘ожидать отпускания клавиши
		inc	Sign		;увеличить кол-во нвжатий на Ctrl
		cmp	Sign, 3		;┐если еще не нажали 3-и раза,то
		jne	SwLoop1		;┘перейти на опрос клавиатуры

		mov	Sign,0		;сбросить кол-во нажатий на Ctrl
		
		cmp	OK_Text,01h	;┐если экран не был выключен,
		jne	Exit009		;┘то выход
		
		call	VideoXcg	;иначе включить экран
		
		mov	ah,01h		;┐
		mov	cx,CurSize	;│восстановить курсор
		int	10h		;┘
		
		mov	OK_Text,0h	;сбросить признак гашения экрана

Exit009:	xor	ax,ax		;┐
		mov	es,ax		;│очистить флаги нажатия
		mov	al,es:[417h]	;│<Control+Alt> по адресу
		and	al,11110011b	;│0000h:0417h и флаги
		mov	es:[417h],al	;│<LeftControl+LeftAlt>
		mov	al,es:[418h]	;│по адресу 0000h:0418h
		and	al,11111100b	;│
		mov	es:[418h],al	;┘

		mov	al,20h		;┐обслужить контроллер
		out	20h,al		;┘прерываний

		cli			; запретить прерывания
		pop	es		;┐
		pop	ds		;│
		pop	si		;│восстановить
		pop	di		;│используемые
		pop	cx		;│регистры
		pop	bx		;│
		pop	ax		;┘
		iret			; выйти из прерывания

Exit09:		cli			; запретить прерывания
		pop	es		;┐
		pop	ds		;│
		pop	si		;│восстановить
		pop	di		;│используемые
		pop	cx		;│регистры
		pop	bx		;│
		pop	ax		;┘
		jmp	cs:OldInt09   	;┐передать управление "по цепочке"
                        		;┘следующему обработчику Int09h
Int09Hand	endp

; ОБРАБОТЧИК ПРЕРЫВАНИЯ Int16h (ВИДЕО ФУНКЦИИ BIOS)

		dw	TestInt16	; слово для обнаружения перехвата

Presense	proc
		cmp	ah, FuncNum	; обращение от нашей программы?
		jne	Pass		; если нет то ничего не делать
		mov	ax, CodeOut	; иначе в ax условленный код
		iret			; и возвратиться

Pass:		jmp	cs:OldInt16	; передать управление "по цепочке"
                        		; следующему обработчику Int16h
Presense	endp


;-------- Н Е Р Е З И Д Е Н Т Н Ы Е   Д А Н Н Ы Е ---------

ResEnd		db	?	; байт для определения границы ре-
                       		; зидентной части программы
On		equ	1	; значение "установлен" для  флагов
Off		equ	0	; значение "сброшен" для флагов
Bell		equ	7	; код символа BELL
CR		equ	13	; код символа CR
LF		equ	10	; код символа LF
MinDosVer	equ	2	; минимальная возможная версия DOS

InstFlag	db	?	; флаг наличия программы в памяти
Savecs		dw	?	; сохраненный cs резидентной прог-
                       		; раммы

Copyright	db	CR,LF,'- L O C K E R - демонстрационная про'
		db	'грамма',CR,LF,LF,'$'
VerDosMsg	db	'Ошибка: некорректная версия DOS'
		db	Bell,CR,LF,'$'
InstMsg		db	'Программа LOCKER установлена.Для снятия ис'
		db	'пользуйте ключ /u',CR,LF
		db	'Для "запирания" нажмите <Ctrl+Alt+L>',CR,LF
		db	'Для "отпирания" трижды нажмите <Ctrl>'
		db	CR,LF,'$'
AlreadyMsg	db	'Ошибка: LOCKER уже резидентна в памяти'
		db	Bell,CR,LF,'$'
UninstMsg	db	'Программа LOCKER снята с резидента'
		db	CR,LF,'$'
NotInstMsg	db	'Ошибка: программа LOCKER не установлена'
		db	Bell,CR,LF,'$'
NotSafeMsg	db	'Ошибка: снять с резидента программу LOCKER'
		db	' в данный момент',CR,LF,'невозможно из-за '
		db	'перехвата некоторых векторов',Bell,CR,LF,'$'


;------ Н Е Р Е З И Д Е Н Т Н Ы Е   П Р О Ц Е Д У Р Ы -----

;ВКЛЮЧАЕМЫЙ ФАЙЛ ДЛЯ ВЫПОЛНЕНИЯ ПРОЦЕДУРЫ ВЫВОДА ИНФОРМАЦИИ

Locker		equ	0	; имя для идентификации пpогpаммы
				; во включаемом файле
include		lab7/INFO.INC	; включаемый файл с процедурой вы-
				; вода информации

;ГЛАВНАЯ ПРОЦЕДУРА ИНИЦИАЛИЗАЦИИ

InitProc	proc
		mov	ah, 09h		;┐
		lea	dx,Copyright	;│вывести начальное сообщение
		int	21h		;┘

		lea	dx,VerDosMsg	;┐проверить версию DOS и вы-
		call	ChkDosVer	;│вести сообщение,если непод-
		jc	Output          ;┘ходящая

		call	PresentTest	; проверить наличие в памяти

		mov	bl,ds:[5Dh]	;┐
		and	bl,11011111b	;│
		cmp	bl,'I'		;│разобрать ключ (заносится
		je	Install		;│в область FCB1 PSP)
		cmp	bl,'U'		;│
		je	Uninst		;┘

		call	@InfoAbout	; вывести информацию
		jmp	short ToDos	; и вернуться в DOS
					; если ключ не тот

Install:	lea	dx,AlreadyMsg
		cmp	InstFlag,On     ;┐если уже установлена,то
		je	Output          ;┘перейти на вывод сообщения

		xor	ax,ax		;┐иначе получить начало
		mov	es,ax		;│видеообласти : если в байте по
		mov	al,es:[411h]	;│адресу 0000h:0411h установлен
		and	al,30h		;│3-й бит,то сегментный адрес на-
		cmp	al,30h		;│чала видеообласти 0B000h иначе
		jne	Vid1		;│сегментный адрес равен 0B800h
		mov	VideoBeg,0B000h	;┘

Vid1:		call	GrabIntVec	; захватить нужные вектора

		mov	ax,ds:[2Ch]	;┐освободить окружение,выделен-
		mov	es,ax		;│ное программе для уменьшения
		mov	ah,49h		;│занимаемой в резиденте памяти
		int	21h		;┘

		mov	ah,09h		;┐вывести сообщение об установке
		lea	dx,InstMsg	;│в резидент
		int	21h		;┘

		lea	dx,ResEnd	;┐завершить и оставить програм-
		int	27h		;┘му в резиденте

Uninst:
		lea	dx,NotInstMsg	;┐если программа не установлена,
		cmp	InstFlag,Off	;│то вывести сообщение об этом
		je	Output		;┘

		lea	dx,NotSafeMsg	;┐если программу невозможно
		call	TestIntVec	;│снять с резидента,то вывести
		jc	Output		;┘сообщение об этом

		call	FreeIntVec	; освободить вектора прерываний

		mov	ah,49h		;┐освободить память,занимаемую
		mov	es,Savecs	;│резидентной частью программы
		int	21h		;┘

		lea	dx,UninstMsg

Output:		mov	ah,09h		;┐вывести нужное сообщение
		int	21h		;┘

ToDos:		mov	ax,4C00h	;┐вернуться в DOS с кодом
		int	21h		;┘завершения 0
		ret			; возврат
InitProc	endp

; ПРОЦЕДУРА ПРОВЕРКИ ВЕРСИИ DOS
; возвращает установленный флаг переноса,если
; версия DOS меньше заданной в MinDosVer

ChkDosVer	proc
		mov	ah,30h		;┐получить в ax номер версии
		int	21h		;┘DOS
		cmp	al,MinDosVer	; сравнить ее с минимальной
		
		clc			; сбросить флаг переноса (CF)
		jge	Norma		; если версия подходящая
		stc			; иначе установить флаг переноса

Norma:		ret			; возврат
ChkDosVer	endp

;ПРОЦЕДУРА ОПРЕДЕЛЕНИЯ НАЛИЧИЯ ПРОГРАММЫ В ПАМЯТИ

PresentTest	proc
		mov	InstFlag,Off	; сбросить флаг наличия в резиденте
		mov	ah,FuncNum	;┐обратиться к нашему процессу
		int	16h		;┘
		cmp	ax,CodeOut	; получили ответ?
		jne	Return		; если нет,то конец
		mov	InstFlag,On	; иначе установить флаг наличия
Return:		ret			; возврат
PresentTest	endp

; ПРОЦЕДУРА ЗАХВАТА ВЕКТОРОВ ПРЕРЫВАНИЙ

GrabIntVec	proc
		mov	ax,3509h	;┐сохранить во внутренних пере-
		int	21h		;│менных старый вектор прерыва-
		mov	OfsInt09,bx	;│ния Int09h
		mov	SegInt09,es	;┘

		mov	ax,3516h	;┐сохранить во внутренних пере-
		int	21h		;│менных старый вектор прерыва-
		mov	OfsInt16,bx	;│ния Int16h
		mov	SegInt16,es	;┘

		mov	ax,2509h	;┐установить Int09Hand в качестве
		lea	dx,Int09Hand	;│нового обработчика прерывания
		int	21h		;┘Int09

		mov	ax,2516h	;┐установить Presense в качестве
		lea	dx,Presense	;│нового обработчика прерывания
		int	21h		;┘Int16h
		ret
GrabIntVec	endp

; ПРОЦЕДУРА ПРОВЕРКИ ПЕРЕХВАТА ВЕКТОРОВ ПРЕРЫВАНИЙ
; возвращает установленный флаг переноса в случае перехвата
; хотя бы одного вектора прерывания

TestIntVec	proc
		mov	ax,3509h		;┐проверить,находится ли ко-
		int	21h			;│довое слово перед обработ-
		cmp	es:[bx-2],TestInt09	;┘чиком прерывания Int09
		stc				; установить флаг переноса CF,
		jne	Cant			; если прерывание перехватили

		mov	ax,3516h		;┐проверить,находится ли ко-
		int	21h			;│довое слово поред обработ-
		cmp	es:[bx-2],TestInt16	;┘чиком прерывания Int16h
		stc				; установить флаг переноса CF,
		jne	Cant			; если прерывание перехватили

		mov	Savecs,es		; запомнить cs резидентной
		clc				; программы,сбросить флаг
						; переноса
Cant:		ret				; возврат
TestIntVec	endp

; ПРОЦЕДУРА ВОССТАНОВЛЕНИЯ ЗАХВАЧЕННЫХ ВЕКТОРОВ ПРЕРЫВАНИЙ

FreeIntVec	proc
		push	ds		; сохранить ds

		mov	ax,2509h	;┐восстановить вектор прерывания
		mov	ds,es:SegInt09	;│Int09h из внутренних переменных
		mov	dx,es:OfsInt09	;│резидентной программы
		int	21h		;┘

		mov	ax,2516h	;┐восстановить вектор прерывания
		mov	ds,es:SegInt16	;│Int16h из внутренних переменных
		mov	dx,es:OfsInt16	;│резидентной программы
		int	21h		;┘

		pop	ds		; восстановить ds
		ret			; возврат
FreeIntVec	endp

PROGRAM   ends
          end   Start
