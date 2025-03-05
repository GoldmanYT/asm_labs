sseg            segment
                dw      256 dup(?)
sseg            ends

; ввод с клавиатуры одной цифры
; вывод: dl
code            segment
in_sym          macro
                local   incor
                local   in_end
                push    ax
incor:          mov     ah,08h
                int     21h
                cmp     al,20h
                je      in_end
                cmp     al,30h
                jl      incor
                cmp     al,39h
                jg      incor
in_end:         mov     ah,02h
                mov     dl,al
                int     21h
                pop     ax
                endm

; ввод с клавиатуры числа без знака
; вывод: bx
in_num          macro
                local   next_digit
                local   form_num
                local   next_iter
                push    ax
                push    cx
                push    dx
                xor     cx,cx
next_digit:     in_sym
                cmp     dl,20h
                je      form_num
                sub     dl,30h
                and     dx,0ffh
                push    dx
                inc     cx
                jmp     next_digit
form_num:       xor     bx,bx
                mov     dx,1
next_iter:      pop     ax
                imul    dl
                add     bx,ax
                mov     ax,dx
                mov     dx,10
                imul    dl
                mov     dx,ax
                loop    next_iter
                pop     dx
                pop     cx
                pop     ax
                endm

_start:         assume  cs:code,ss:sseg
                in_num
                mov     ah,4ch
                mov     al,bl
                int     21h                
code            ends
                end     _start