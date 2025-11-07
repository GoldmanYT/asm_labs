include		incfile.inc

		.386
		.model	flat, stdcall

.const
endl		dd	1, 0, 800h, 0
text_right_alt	db	'Right alt', 0
text_left_alt	db	'Left alt', 0
text_right_ctrl	db	'Right ctrl', 0
text_left_ctrl	db	'Left ctrl', 0
text_shift	db	'Shift', 0
text_numlock	db	'NumLock', 0
text_scrolllock	db	'ScrollLock', 0
text_capslock	db	'CapsLock', 0
text_pressed	db	'pressed', 0
text_released	db	'released', 0
fmt		db	'%s: %s', 0

text_array	dd	offset text_right_alt, \
			offset text_left_alt, \
			offset text_right_ctrl, \
			offset text_left_ctrl, \
			offset text_shift, \
			offset text_numlock, \
			offset text_scrolllock, \
			offset text_capslock

HomePos		COORD	<0, 0>

.data
tmp		dd	?
inputHandle	dd	?
outputHandle	dd	?

key_array	db	8 dup(0)
EscapeDown	db	0

ConsoleInfo	CONSOLE_SCREEN_BUFFER_INFO	<>

messageLen	dd	?
messageBuffer	db	256 dup(0)

ConsoleSize	COORD	<>
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

		call	GetConsoleScreenBufferInfo, outputHandle, offset ConsoleInfo
		mov	ax, ConsoleInfo.dwSize.X
		mov	ConsoleSize.X, ax
		mov	ax, ConsoleInfo.dwSize.Y
		mov	ConsoleSize.Y, ax

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
		jz	case_wnd_size
		mov	eax, [esi + 4 + 12]	; dwControlKeyState

		xor	ebx, ebx
		mov	edi, offset key_array

begin_for_key:	cmp	ebx, 8
		jae	end_for_key
		
		mov	[edi + ebx], al
		and	byte ptr [edi + ebx], 1
		shr	eax, 1

		inc	ebx
		jmp	begin_for_key
		
end_for_key:	mov	EscapeDown, 0
		cmp	word ptr [esi + 4 + 6], VK_ESCAPE	; wVirtualKeyCode
		jne	end_case
		mov	EscapeDown, 1
		jmp	end_case

case_wnd_size:	test	di, WINDOW_BUFFER_SIZE_EVENT
		jz	end_case
		mov	ax, [esi + 4]
		mov	ConsoleSize.X, ax
		mov	ax, [esi + 6]
		mov	ConsoleSize.Y, ax
		jmp	end_case

end_case:	inc	cx
		add	esi, 20
		jmp	begin_for_event

end_for_event:	mov	ax, ConsoleSize.X
		mov	dx, ConsoleSize.Y
		mul	dx
		call	FillConsoleOutputCharacter, outputHandle, ' ', eax, HomePos, offset tmp

		xor	ebx, ebx
		mov	ax, ConsoleSize.Y
		mov	CursorPosition.Y, ax
		sub	CursorPosition.Y, 8
		shr	CursorPosition.Y, 1
		mov	esi, offset text_array
		mov	edi, offset key_array

begin_for_write: mov	ecx, offset text_released
		mov	al, [edi + ebx]
		test	al, al
		jz	not_pressed
		mov	ecx, offset text_pressed
not_pressed:	call	wsprintf, offset messageBuffer, offset fmt, dword ptr [esi + ebx * 4], ecx
		call	strLen, offset messageBuffer
		mov	messageLen, eax
		mov	ax, ConsoleSize.X
		mov	CursorPosition.X, ax
		mov	eax, messageLen
		sub	CursorPosition.X, ax
		shr	CursorPosition.X, 1

		call	SetConsoleCursorPosition, outputHandle, CursorPosition
		call	WriteConsole, outputHandle, offset messageBuffer, messageLen, offset tmp, 0

		inc	CursorPosition.Y
		inc	ebx
		cmp	ebx, 8
		jb	begin_for_write

end_for_write:	jmp	begin_while_esc

exit:		call	ExitProcess, 0
		ends
		end	_start