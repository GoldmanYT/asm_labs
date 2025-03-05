sseg            segment
                dw      256 dup(?)
sseg            ends

out_sym         macro   sym
                push    ax
                push    dx
                mov     ah,02h
                mov     dl,sym
                int     21h
                pop     dx
                pop     ax
                endm

code            segment

print           macro
                local   number
                local   not_zero
                local   next_digit
                local   out_num
                local   end_p
                push    ax
                push    bx
                push    cx
                push    dx
                cmp     al,0
                jns     number
                out_sym '-'
                neg     al
number:         jnz     not_zero
                out_sym '0'
                jmp     end_p
not_zero:       mov     dx,10
                xor     cx,cx
                and     ax,0ffh
next_digit:     idiv    dl
                add     ah,30h
                mov     bl,ah
                and     bx,0ffh
                push    bx
                inc     cx
                and     ax,0ffh
                cmp     al,0
                jnz     next_digit
out_num:        pop     bx
                out_sym bl
                dec     cx
                jnz     out_num
end_p:          pop     dx
                pop     cx
                pop     bx
                pop     ax
                endm

_start:         assume  cs:code,ss:sseg
                mov     al,-127
                print
                mov     ax,4c00h
                int     21h                
code            ends
                end     _start