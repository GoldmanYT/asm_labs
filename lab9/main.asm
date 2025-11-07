include		incfile.inc

		.386
		.model	flat, stdcall

.const
endl		dd	1, 0, 800h, 0
text_right_alt	db	'Right alt'
text_left_alt	db	'Left alt'
text_right_ctrl	db	'Right ctrl'
text_left_ctrl	db	'Left ctrl'
text_shift	db	'Shift'
text_numlock	db	'NumLock'
text_scrolllock	db	'ScrollLock'
text_capslock	db	'CapsLock'
text_pressed	db	'pressed'
text_released	db	'released'
fmt		db	'%s: %s'

text_array	dd	offset text_right_alt, \
			offset text_left_alt, \
			offset text_right_ctrl, \
			offset text_left_ctrl, \
			offset text_shift, \
			offset text_numlock, \
			offset text_scrolllock, \
			offset text_capslock

.data
tmp		dd	?
inputHandle	dd	?
outputHandle	dd	?

RightAltDown	db	0
LeftAltDown	db	0
RightCtrlDown	db	0
LeftCtrlDown	db	0
ShiftDown	db	0
NumLockDown	db	0
ScrollLockDown	db	0
CapsLockDown	db	0
EscapeDown	db	0

messageBuffer	db	256 dup(0)

ConsoleSize	COORD	<120, 30>
CursorPosition	COORD	<>

eventBuffer	INPUT_RECORD	256 dup(<>)
eventNum	dw	?

.code

strLen		proc
		push	ebp
		mov	ebp, esp
		push	esi
		push	edi

		mov	ecx, -1
		mov	edi, dword ptr [ebp + 8]
		mov	esi, edi
		xor	al, al	; '\0'

		repne	scasb

		dec	edi
		mov	eax, edi
		sub	eax, esi

		pop	edi
		pop	esi
		pop	ebp
		
		ret
strLen		endp

_start:		call	GetStdHandle, STD_INPUT_HANDLE	; получаем HANDLE буфера ввода
		mov	inputHandle, eax

		call	GetStdHandle, STD_OUTPUT_HANDLE	; получаем HANDLE буфера вывода
		mov	outputHandle, eax

begin_while_esc: mov	al, EscapeDown
		test	al, al
		jnz	exit

		call	ReadConsoleInput, inputHandle, offset eventBuffer, 256, offset eventNum

		xor	ecx, ecx
		mov	esi, offset eventBuffer

begin_for_event: cmp	cx, eventNum
		jae	end_for_event

		mov	di, [esi]	; EventType

case_key:	test	di, KEY_EVENT
		jne	case_wnd_size
		mov	eax, [esi + 4 + 12]	; dwControlKeyState
		mov	RightAltDown, al
		or	RightAltDown, 1
		shr	eax, 1
		mov	LeftAltDown, al
		or	LeftAltDown, 1
		shr	eax, 1
		mov	RightCtrlDown, al
		or	RightCtrlDown, 1
		shr	eax, 1
		mov	LeftCtrlDown, al
		or	LeftCtrlDown, 1
		shr	eax, 1
		mov	ShiftDown, al
		or	ShiftDown, 1
		shr	eax, 1
		mov	NumLockDown, al
		or	NumLockDown, 1
		shr	eax, 1
		mov	ScrollLockDown, al
		or	ScrollLockDown, 1
		shr	eax, 1
		mov	CapsLockDown, al
		or	CapsLockDown, 1
		mov	EscapeDown, 0
		cmp	word ptr [esi + 4 + 6], VK_ESCAPE	; wVirtualKeyCode
		jne	end_case
		mov	EscapeDown, 1
		jmp	end_case

case_wnd_size:	test	di, WINDOW_BUFFER_SIZE_EVENT
		jne	end_case
		mov	ax, [esi + 4]
		mov	ConsoleSize.X, ax
		mov	ax, [esi + 6]
		mov	ConsoleSize.Y, ax
		jmp	end_case

end_case:	inc	cx
		add	esi, 20
		jmp	begin_for_event

end_for_event:	xor	ecx, ecx
		mov	ax, ConsoleSize.Y
		mov	CursorPosition.Y, ax
		sub	CursorPosition.Y, 8
		shr	CursorPosition.Y, 1

begin_for_write:call	wsprintf, offset messageBuffer, offset fmt
		mov	ax, ConsoleSize.X
		mov	CursorPosition.X, ax
		call	strLen, offset messageBuffer
		sub	CursorPosition.X, ax
		shr	CursorPosition.X, 1

		call	SetConsoleCursorPosition, outputHandle, CursorPosition
		call	WriteConsole, outputHandle, offset messageBuffer, ax, offset tmp, 0

		inc	CursorPosition.Y
		cmp	ecx, 8
		jb	begin_for_write

end_for_write:	jmp	begin_while_esc

exit:		call	ExitProcess, 0
		ends
		end	_start