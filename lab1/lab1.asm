data            segment
array           db      1,10,-5,7,-8,0,4        ; массив с данными
len             dw      $-array                 ; длина массива
array1           db      9,10,10,-10,-5
len1             dw      $-array1               ; длина массива
; array           db      -7,10,1,-8,-10,7
data            ends

; Макрокоманда посчёта количества положительных чисел
; Ввод: N чисел от ADR до ADR+N
; Вывод: DL
cnt_pos         macro   adr,n
                local   next_iter
                local   ignore
                mov     dl,0            ; результат: количество подходящих чисел
                lea     bx,adr          ; количество рассмотренных чисел
                mov     cx,n
next_iter:      mov     al,[bx]      ; поместить число в AL
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
                cnt_pos array1,len1
                mov     ax,4c00h
                int     21h
code            ends
                end     start
