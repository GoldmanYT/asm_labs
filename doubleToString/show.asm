includelib import32.lib

.386
.model FLAT,STDCALL
    extrn MessageBoxA: proc
    extrn ExitProcess: proc
    extrn doubleToString: proc

.data
num dq 213762314083450.0
mb_text db 32 dup(?),0
mb_title db 'Next program',0

.code
start:
    finit
    fldz
    ; fchs
    ; fsqrt
    fstp num
    call doubleToString, offset num, offset mb_text
    call MessageBoxA, 0, offset mb_text, offset mb_title, 0
    call ExitProcess, 0
    ends
    end start