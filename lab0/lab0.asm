; Демонстрационная программа сложения двух
; одноразрядных беззнаковых чисел
; Для построения рабочей версии используйте
; команды:
; >tasm demo;
; >tlink demo;
; >demo
; Резервирoвание места под стек
sseg            segment stack 'stack'
                dw      256 dup(?)
sseg            ends

; Определение данных
data            segment
; Сообщения пользователю
msg1            db      10,13,'Program of substraction of two numbers'
                db      10,13,'Enter first number: ','$'
msg2            db      10,13,'Enter second number: ','$'
msg3            db      10,13,'Result = ','$'
data            ends


; Сегмент кода
code            segment
                assume  cs:code,ds:data,ss:sseg
start:          mov     ax,data         ; настроить сегментный
                mov     ds,ax           ; регистр DS на данные
                lea     dx,msg1         ; вывести сообщение
                call    print_msg
                call    input_digit     ; ввести первое число
                mov     bl,al           ; и сохранить в регистре BL
                lea     dx,msg2         ; вывести сообщение
                call    print_msg
                call    input_digit     ; ввести второе число
                lea     dx,msg3         ; вывести сообщение
                call    print_msg
                call    sub_and_show    ; вычесть и вывести результат
                mov     ah,4ch          ; завершить программу
                int     21h             ; и выйти в DOS


; Подпрограмма вывода сообщения на дисплей
; Вход: DS:DX - адрес сообщения
; Выход: вывод сообщения на дисплей
print_msg       proc
                push    ax              ; сохранить AX
                mov     ah,09h          ; вывести сообщение
                int     21h             ; с помощью функции DOS
                pop     ax              ; восстановить AX
                ret                     ; вернуться в вызывающую программу
print_msg       endp


; Подпрограмма ввода числа с клавиатуры
; Вход: набранная с клавиатуры цифра
; Выход: в AL - введенное число
input_digit     proc
input_again:    mov     ah,01h          ; ввести символ с клавиатуры
                int     21h             ; с помощью функции DOS
                cmp     al,'0'          ; если символ не цифра,
                jl      input_again     ; то повторить ввод
                cmp     al,'9'
                jg      input_again
                sub     al,30h          ; преобразовать код символа в число
                ret                     ; вернуться в вызывающую программу
input_digit     endp


; Подпрограмма вычитания двух чисел
; Вход: AL,BL,
; выход: вывод результата на дисплей
sub_and_show    proc
                sub     bl,al           ; вычесть (BL=BL-AL)
                jns     not_neg         ; если результат < 0, то
                neg     bl              ; поменять знак BL=-BL
                mov     ah,2h           
                mov     dl,'-'          ; вывести символ '-'
                int     21h             ; c помощью функции DOS
not_neg:        add     bl,30h          ; преобразовать число в код символа
                mov     ah,2h           ; вывести цифру
                mov     dl,bl           ; результата с помощью
                int     21h             ; функции DOS
                ret                     ; вернуться в вызывающую программу
sub_and_show    endp
code            ends
                end     start