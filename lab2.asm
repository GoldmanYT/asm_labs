data            segment
array           dw      1,10,-5,7,-8,0,4        ; массив с данными
len             dw      $-array         ; длина массива
data            ends

; Макрокоманда посчёта количества положительных чисел
; Ввод: N чисел от ADR до ADR+N
; Вывод: DL
cnt_pos         macro
                mov     dl,0            ; результат: количество подходящих чисел
                mov     bx,0            ; количество рассмотренных чисел
next_iter:      mov     ax,[bx]         ; поместить число в AL
                cmp     ax,0            ; сравнить AL с нулём
                jle     ignore          ; если не положительное, то не считать его
                inc     dl              ; иначе - посчитать
ignore:         inc     bx              ; число рассмотрено
                cmp     bx,len          ; сравнить кол-во рассмотренных чисел и N
                jne     next_iter       ; если не равно, то начать новую итерацию
                endm

code            segment
                assume  cs:code,ds:data
start:          mov     ax,data
                mov     dx,ax
                cnt_pos
                mov     ax,4c00h
                int     21h
code            ends
                end     start
