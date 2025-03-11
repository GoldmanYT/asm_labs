code            segment
                assume  cs:code,ds:code
                public  print_dec

print_dec       proc
                push    bp
                mov     bp,sp
                push    ax
                push    bx
                push    cx
                push    dx
                push    di
                
                mov     ax,[bp+4]
                mov     bx,10000
                mov     cx,5

                cmp     ax,0
                jg      zeros

                push    ax
                mov     dl,'-'
                mov     ah,02h
                int     21h
                pop     ax
                neg     ax
                xor     dx,dx

zeros:          div     bx
                push    dx
                xor     dx,dx
                mov     di,10
                xchg    ax,bx
                div     di
                xchg    ax,bx
                cmp     ax,0
                jne     output
                pop     ax
                loop    zeros

                mov     dl,30h
                mov     ah,02h
                int     21h
                jmp     exit

number:         div     bx
                push    dx
                xor     dx,dx
                mov     di,10
                xchg    ax,bx
                div     di
                xchg    ax,bx
output:         add     al,30h
                mov     dl,al
                mov     ah,02h
                int     21h
                xor     dx,dx
                pop     ax
                loop    number

exit:           pop     di
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                pop     bp
                ret
print_dec       endp
code            ends
                end