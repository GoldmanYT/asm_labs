data            segment
array           db      1,10,-5,7,-8,0,4        ; массив с данными
; array           db      9,10,10,-10,-5
; array           db      -7,10,1,-8,-10,7
len             dw      $-array                 ; длина массива
data            ends

; Макрокоманда посчёта количества положительных чисел
; Ввод: N чисел от ADR до ADR+N
; Вывод: DL
cnt_pos         macro   adr,n
                mov     dl,0            ; результат: количество подходящих чисел
                mov     bx,0            ; количество рассмотренных чисел
                mov     cx,n
next_iter:      mov     al,adr[bx]      ; поместить число в AL
                cmp     al,0            ; сравнить AL с нулём
                jng     ignore          ; если положительное, то
                inc     dl              ; посчитать его
ignore:         inc     bx              ; иначе - пропустить; число рассмотрено
                loop    next_iter       ; перейти к след. итерации
                endm

code            segment
                assume  cs:code,ds:data
start:          mov     ax,data
                mov     ds,ax
                cnt_pos array,len
                mov     ax,4c00h
                int     21h
code            ends
                end     start
