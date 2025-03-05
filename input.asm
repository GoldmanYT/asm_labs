sseg            segment
                dw      256 dup(?)
sseg            ends

code            segment
in_sym          macro
                push    ax
incor:          mov     ah,08h
                int     21h
                cmp     al,30h
                jl      incor
                cmp     al,39h
                jg      incor
                mov     ah,02h
                mov     dl,al
                int     21h
                pop     ax
                endm

_start:         assume  cs:code,ss:sseg
                mov     al,-127
                in_sym
                mov     ax,4c00h
                int     21h                
code            ends
                end     _start