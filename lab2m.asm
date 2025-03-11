sseg            segment stack   'stack'
                dw      256 dup(?)
sseg            ends


data            segment
msg1            db      "Original string: $"
msg2            db      0Dh,0Ah,"Converted string: $"
S1              db      9,"My String"
Start1          db      3
Len1            db      5
S2              db      9,"Assembler"
Start2          db      10
Len2            db      5
S3              db      13,"Hello, World!"
Start3          db      6
Len3            db      255
data            ends


code            segment
                assume  cs:code,ss:sseg,ds:data
                extrn   Delete: near


print_msg       proc
                push    ax
                mov     ah,09h
                int     21h
                pop     ax
                ret
print_msg       endp


print_str       proc
                push    ax
                push    bx
                push    cx
                push    dx

                mov     ah,02h
                xor     cx,cx
                mov     cl,[bx]

next_sym:       inc     bx
                mov     dl,[bx]
                int     21h
                loop    next_sym

                pop     dx
                pop     cx
                pop     bx
                pop     ax
                ret
print_str       endp

_start:         mov     ax,data
                mov     ds,ax

                lea     dx,msg1
                call    print_msg

                lea     bx,S1
                call    print_str

                mov     ax,seg S1
                push    ax
                mov     ax,offset S1
                push    ax
                mov     al,Start1
                push    ax
                mov     al,Len1
                push    ax
                call    Delete
                pop     ax
                pop     ax
                pop     ax
                pop     ax

                lea     dx,msg2
                call    print_msg

                lea     bx,S1
                call    print_str

                mov     ax,4c00h
                int     21h
code            ends
                end     _start