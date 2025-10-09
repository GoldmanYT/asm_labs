include		incfile.inc

		.386
		.model	flat, stdcall

.const		
mesEnterFile	db	'Enter filename: '
mesEnterFileLen	dd	$ - mesEnterFile

mesSuccess	db	'File attribute has been set', 0Ah
mesSuccessLen	dd	$ - mesSuccess

mesFail		db	'Error! File attribute has not been set', 0Ah
mesFailLen	dd	$ - mesFail

endl		dd	1, 0, 800h, 0

.data
tmp		dd	?
inputHandle	dd	?
outputHandle	dd	?
filename	db	100h dup(0)

.code
_start:		call	GetStdHandle, STD_INPUT_HANDLE	; получаем HANDLE ввода
		mov	inputHandle, eax

		call	GetStdHandle, STD_OUTPUT_HANDLE	; получаем HANDLE вывода
		mov	outputHandle, eax

		call	WriteConsole, outputHandle, offset mesEnterFile, mesEnterFileLen, offset tmp, 0

		call	ReadConsole, inputHandle, offset filename, 255, offset tmp, offset endl
		
		; необходимо удалить перевод строки и возврат каретки
		mov	al, 0Dh
		mov	ecx, 256
		mov	edi, offset filename
		repne	scasb
		mov	[edi - 1], 0

		call	SetFileAttributes, offset filename, FILE_ATTRIBUTE_READONLY
		test	eax, eax
		jz	err			; EAX = 0, то произошла ошибка
		
		; иначе - всё ОК
		call	WriteConsole, outputHandle, offset mesSuccess, mesSuccessLen, offset tmp, 0
		jmp	exit

err:		call	WriteConsole, outputHandle, offset mesFail, mesFailLen, offset tmp, 0

exit:		call	ReadConsole, inputHandle, offset filename, 255, offset tmp, offset endl
		call	ExitProcess, 0
		ends
		end	_start