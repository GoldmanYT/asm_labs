sseg            segment stack   'stack'
                dw      256 dup(?)
sseg            ends


data            segment
msg1            db      "Original string: $"
msg2            db      0dh,0ah,"Converted string: $"
S1              db      14,"Hello, World!$"
Start1          db      6
Len1            db      7
data            ends


code            segment
                assume  cs:code,ss:sseg,ds:data

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
                rep movs byte ptr es:[si],[di]

                pop     es
                pop     di
                pop     si
                pop     cx
                pop     bx
                mov     sp,bp
                pop     bp
                ret
Delete          endp


print_msg       proc
                push    ax
                mov     ah,09h
                int     21h
                pop     ax
                ret
print_msg       endp


_start:         mov     ax,data
                mov     ds,ax

                lea     dx,msg1
                call    print_msg

                lea     dx,S1
                call    print_msg

                mov     ax,seg S1
                push    ax
                mov     ax,offset S1
                push    ax
                mov     al,Start1
                push    ax
                mov     al,Len1
                push    ax
                call    Delete

                lea     dx,msg2
                call    print_msg

                lea     dx,S1
                call    print_msg

                mov     ax,4c00h
                int     21h
code            ends
                end     _start