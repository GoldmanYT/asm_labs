includelib	../import32.lib
		extrn	ExitProcess: near
		extrn	GetStdHandle: near
		extrn	WriteConsoleA: near
		extrn	ReadConsoleA: near
		extrn	ReadConsoleInputA: near
		extrn	SetConsoleCursorPosition: near
		extrn	_wsprintfA: near
		extrn	GetConsoleScreenBufferInfo: near
		extrn	FillConsoleOutputCharacterA: near

WriteConsole		equ	WriteConsoleA
STD_INPUT_HANDLE	equ	-10
STD_OUTPUT_HANDLE	equ	-11

ReadConsole	equ	ReadConsoleA
GetCommandLine	equ	GetCommandLineA
ReadConsoleInput	equ	ReadConsoleInputA
wsprintf	equ	_wsprintfA
FillConsoleOutputCharacter	equ	FillConsoleOutputCharacterA

KEY_EVENT			equ	00001h
MOUSE_EVENT			equ	00002h
WINDOW_BUFFER_SIZE_EVENT	equ	00004h
MENU_EVENT			equ	00008h
FOCUS_EVENT			equ	00010h

VK_ESCAPE	equ	01Bh

RIGHT_ALT_PRESSED	equ	00001h
LEFT_ALT_PRESSED	equ	00002h
RIGHT_CTRL_PRESSED	equ	00004h
LEFT_CTRL_PRESSED	equ	00008h
SHIFT_PRESSED		equ	00010h
NUMLOCK_ON		equ	00020h
SCROLLLOCK_ON		equ	00040h
CAPSLOCK_ON		equ	00080h
ENHANCED_KEY		equ	00100h

COORD		struc
X		dw	?
Y		dw	?
COORD		ends

INPUT_RECORD	struc
EventType	dw	?
		dw	?
Event		dd	4 dup(?)
INPUT_RECORD	ends

KEY_EVENT_RECORD	struc
bKeyDown		dd	?
wRepeatCount		dw	?
wVirtualKeyCode		dw	?
wVirtualScanCode	dw	?
uChar			dw	?
dwControlKeyState	dd	?
KEY_EVENT_RECORD	ends

WINDOW_BUFFER_SIZE_RECORD	struc
dwSize				COORD	<>
WINDOW_BUFFER_SIZE_RECORD	ends

SMALL_RECT	struc
Left		dw	?
Top		dw	?
Right		dw	?
Bottom		dw	?
SMALL_RECT	ends

CONSOLE_SCREEN_BUFFER_INFO	struct
dwSize				COORD	<>
dwCursorPosition		COORD	<>
wAttributes			dw	?
srWindow			SMALL_RECT	<>
dwMaximumWindowSize		COORD	<>
CONSOLE_SCREEN_BUFFER_INFO	ends