data            segment
array           db      1,10,-5,7,-8,0,4        ; массив с данными
len             dw      $-array                 ; длина массива
data            ends

; Макрокоманда посчёта количества положительных чисел
; Ввод: N чисел от ADR до ADR+N
; Вывод: DL
cnt_pos         macro   adr,n
                mov     dl,0            ; результат: количество подходящих чисел
                mov     bx,0            ; количество рассмотренных чисел
next_iter:      mov     al,adr[bx]      ; поместить число в AL
                cmp     al,0            ; сравнить AL с нулём
                jng     ignore          ; если положительное, то
                inc     dl              ; посчитать его
ignore:         inc     bx              ; иначе - пропустить; число рассмотрено
                cmp     bx,n            ; сравнить кол-во рассмотренных чисел и N
                jne     next_iter       ; если не равно, то начать новую итерацию
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
