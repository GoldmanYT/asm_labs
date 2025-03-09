sseg            segment stack   'stack'
                dw      256 dup(?)
sseg            ends


data            segment
S1              db      14,"Hello, World!$"
Start1          db      6
Len1            db      7
data            ends


code            segment

; procedure Delete(var S: string; Start, Len: byte)
; Удаляет в строке S символы с позиции Start и длинной Len
; Если Start, больше длины S, то ничего не изменяется
Delete          proc    near
S_seg           equ     word ptr[bp+10]
S_offst         equ     word ptr[bp+8]
Start           equ     word ptr[bp+6]
Len             equ     word ptr[bp+4]
                push    bp
                mov     bp,sp
                push    ax
                push    cx
                push    si
                push    di
                push    es

                mov     cx,S_seg
                mov     es,cx

                mov     cx,Start
                add     cx,0ffh
                mov     di,cx           ; di = Start

                mov     cx,es:[S_offst]
                add     cx,0ffh
                sub     cx,di
                add     cl,1            ; cx = |S|-Start+1
                cmp     Len,cx
                jg      del             ; если длина уходит за границу
                mov     cx,Len          ; корректировка длины
                add     cx,0ffh

del:            sub     Len,cx
                add     di,S_offst
                mov     si,di
                add     si,cx
                rep movs word ptr es:[si],[word ptr di]

                pop     es
                pop     di
                pop     si
                pop     cx
                pop     ax
                mov     sp,bp
                pop     bp
                ret
endp            Delete


_start:         assume  cs:code,ss:sseg,ds:data
                mov     ax,data
                mov     ds,ax
                mov     ax,seg S1
                push    ax
                mov     ax,offset S1
                push    ax
                mov     al,Start1
                push    ax
                mov     al,Len1
                push    ax
                call    Delete
                mov     ax,4c00h
                int     21h
code            ends
                end     _start