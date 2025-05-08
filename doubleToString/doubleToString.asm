.386
.model flat

.const
doublePosZero equ 0
doubleNegZero equ 80000000h
doublePosInf equ 7ff00000h
doubleNegInf equ 0fff00000h
doubleNaNmask equ 7ff00000h
signMask equ 80000000h

strPosZero db "+0",0
strNegZero db "-0",0
strPosInf db "+inf",0
strNegInf db "-inf",0
strNaN db "NaN",0
; strNumber db "Number",0

rcMask equ 0c00h
digitCount equ 16
base10 equ 10
const10 dq 10.0
buffer16 dw ?
buffer32 dd ?

.code

    public doubleToString

doubleToString proc
num equ dword ptr [ebp + 8]
res equ dword ptr [ebp + 12]

    push ebp
    mov ebp, esp
    push esi
    push edi

    mov edi, res
    mov ecx, num  ; загр. смещение num
    mov eax, [ecx]  ; загр. посл. 4 байта
    test eax, eax  ; равны 0?
    mov eax, [ecx + 4]  ; загр. перв. 4 байта
    jne checkNaN  ; есла нет, проверить на NaN

    ; иначе проверки на +0, -0, +inf, -inf:
    cmp eax, doublePosZero
    je pointPosZero
    cmp eax, doubleNegZero
    je pointNegZero
    cmp eax, doublePosInf
    je pointPosInf
    cmp eax, doubleNegInf
    je pointNegInf
    jmp number

number:
checkNaN:
    and eax, doubleNaNmask
    cmp eax, doubleNaNmask
    je pointNaN
    jmp findNumber

pointPosZero:
    mov esi, offset strPosZero
    jmp writeConst
pointNegZero:
    mov esi, offset strNegZero
    jmp writeConst
pointPosInf:
    mov esi, offset strPosInf
    jmp writeConst
pointNegInf:
    mov esi, offset strNegInf
    jmp writeConst
pointNaN:
    mov esi, offset strNaN
    jmp writeConst
; pointNumber:
;     mov esi, offset strNumber
;     jmp writeConst

findNumber:
    mov eax, [ecx + 4]
    and eax, signMask
    test eax, eax  ; если равно 0
    je posSign  ; знак "+" (пропускаем)
    mov al, '-'  ; записать "-"
    stosb
    jmp afterSign

posSign:
    ; mov al, '+'  ; записать "+"
    ; stosb

afterSign:
    fstcw buffer16
    or buffer16, rcMask
    fldcw buffer16

    fld qword ptr [ecx]
    fabs
    fist buffer32
    fld st(0)
    frndint
    fsubp

    mov eax, buffer32
    mov ecx, base10
    push 0  ; признак конца числа

intDigit:
    xor edx, edx
    div ecx
    add edx, 30h
    push edx
    test eax, eax
    jne intDigit

writeIntDigit:
    pop eax
    test eax, eax
    je afterIntDigits
    stosb
    jmp writeIntDigit

afterIntDigits:
    mov al, '.'
    stosb
    mov ecx, digitCount

getDigit:
    fmul const10
    fist buffer32
    fld st(0)
    frndint
    fsubp

    mov eax, buffer32
    add eax, 30h  ; преобразование к цифре
    stosb
    loop getDigit

    fstp buffer32
    mov al, 0  ; конец строки
    stosb
    jmp done

writeConst:
    xor ecx, ecx
    mov edx, esi

computeLen:
    inc ecx
    mov al, byte ptr [edx]
    inc edx
    test al, al
    jne computeLen

    rep movsb
    jmp done

done:
    pop edi
    pop esi
    pop ebp
    ret
doubleToString endp

    ends
    end