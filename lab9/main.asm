include		incfile.inc

		.386
		.model	flat, stdcall

.const		
mesEnterFile	db	'Entered filename: '
mesEnterFileLen	dd	$ - mesEnterFile

mesSuccess	db	0Ah, 'File attribute has been set', 0Ah
mesSuccessLen	dd	$ - mesSuccess

mesFail		db	0Ah, 'Error! File attribute has not been set', 0Ah
mesFailLen	dd	$ - mesFail

endl		dd	1, 0, 800h, 0

.data
tmp		dd	?
inputHandle	dd	?
outputHandle	dd	?
filenamePtr	dd	?
filenameLen	dd	?

.code
_start:		call	GetStdHandle, STD_INPUT_HANDLE	; получаем HANDLE буфера ввода
		mov	inputHandle, eax

		call	GetStdHandle, STD_OUTPUT_HANDLE	; получаем HANDLE буфера вывода
		mov	outputHandle, eax

		call	WriteConsole, outputHandle, offset mesEnterFile, mesEnterFileLen, offset tmp, 0

		call	GetCommandLine

		; поиск конца строки
		cld
		mov	ecx, -1
		mov	edi, eax
		mov	al, 0
		repne	scasb
		dec	edi
		mov	filenameLen, edi

		std
		mov	ecx, -1
		mov	al, ' '
		repne	scasb

		cld
		add	edi, 2
		sub	filenameLen, edi
		mov	filenamePtr, edi

		call	WriteConsole, outputHandle, edi, filenameLen, offset tmp, 0
		
		call	GetFileAttributes, filenamePtr
		test	eax, eax
		jz	err			; EAX = 0, то произошла ошибка

		or	eax, FILE_ATTRIBUTE_HIDDEN
		call	SetFileAttributes, filenamePtr, eax
		test	eax, eax
		jz	err			; EAX = 0, то произошла ошибка
		
		; иначе - всё ОК
		call	WriteConsole, outputHandle, offset mesSuccess, mesSuccessLen, offset tmp, 0
		jmp	exit

err:		call	WriteConsole, outputHandle, offset mesFail, mesFailLen, offset tmp, 0

exit:		call	ReadConsole, inputHandle, offset tmp, 255, offset tmp, offset endl
		call	ExitProcess, 0
		ends
		end	_start