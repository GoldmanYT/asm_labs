code            segment
                assume  cs:code,ds:code
                public  Delete

; procedure Delete(var S: string; Start, Len: byte)
; Удаляет в строке S символы с позиции Start и длинной Len
; Если Start больше длины S, то ничего не изменяется
Delete          proc
S               equ     dword ptr[bp+8]
Start           equ     byte ptr[bp+6]
Len             equ     byte ptr[bp+4]
                push    bp
                mov     bp,sp
                push    bx
                push    cx
                push    si
                push    di
                push    es

; Формулы
; Len = min(Len, |S| - Start + 1)       // Длина удаляемого куска
; bx = addr(S)                          // адрес начала строки
; di = Start [+ addr(S)]                // адрес начала записи
; si = Start + Len [+ addr(S)]          // адрес записываемой части
; cx = |S| - Start - Len + 1            // количество записываемых символов
; |S| = |S| - Len                       // новая длина строки

                ; Загрузка данных
                les     bx,S            ; bx = addr(S)
                xor     cx,cx
                mov     cl,Start        
                mov     di,cx           ; di = Start
                mov     cl,Len          
                mov     si,cx           ; si = Len
                mov     cl,es:[bx]      ; cl = |S|

                cmp     di,cx           ; Start > |S|
                ja      exit            ; exit

                sub     cx,di           ; cx = |S| - Start
                add     cx,1            ; cx = |S| - Start + 1
                cmp     si,cx           ; Len ? |S| - Start + 1
                jb      del
                mov     si,cx           ; Len = |S| - Start + 1

del:            sub     es:[bx],si      ; |S| = |S| - Len
                sub     cx,si           ; cx = |S| - Start - Len + 1
                add     si,di           ; si = Start + Len
                add     di,bx           ; di = Start + addr(S)
                add     si,bx           ; si = Start + Len + addr(S)
                rep movs byte ptr [si],[di]

exit:           pop     es
                pop     di
                pop     si
                pop     cx
                pop     bx
                mov     sp,bp
                pop     bp
                ret
Delete          endp
code            ends
                end