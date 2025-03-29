cseg            segment
                assume  cs:cseg,ds:cseg
                .386
t               dd      0.0
; t               dd      1.0
; t               dd      2.0
res             dd      ?
n1_4            dd      0.25
n2              dd      2.0
n3              dd      3.0
n4              dd      4.0
n5              dd      5.0
n9              dd      9.0

; Макрокоманда возведения в степень: x^y
; y = st(1)
; x = st(0)
fpow            macro
                fyl2x
                f2xm1
                fld1
                faddp
                endm

_start:         mov     ax,cs
                mov     ds,ax
                finit           

                fld     n1_4    ; 1/4
                fld1            ; 1
                fld     t       ; t
                fcos            ; cos(t)
                fld     st(0)   ; cos(t)
                fmulp           ; cos^2(t) = cos(t) * cos(t)
                fld     st(0)   ; cos^2(t)
                fmulp           ; cos^4(t) = cos^2(t) * cos^2(t)
                fld     n4      ; 4
                fdivp           ; cos^4(t) / 4
                fsubp           ; 1 - cos^4(t) / 4
                fpow            ; (1 - cos^4(t) / 4) ^ (1/4)

                fld1            ; 1
                fld     n5      ; 5
                fdivp           ; 1/5
                fld1            ; 1
                fld     t       ; t
                fld1            ; 1
                fpatan          ; arctg(t) = atan(t/1)
                fld     n2      ; 2
                fdivp           ; arctg(t) / 2
                faddp           ; 1 + arctg(t) / 2
                fpow            ; (1 + arctg(t) / 2) ^ (1/5)

                fld1            ; 1
                fld     n9      ; 9
                fdivp           ; 1/9
                fld1            ; 1
                fld     n3      ; 3
                fld     t       ; t
                fld     st(0)   ; t
                fmulp           ; t^2 = t * t
                faddp           ; 3 + t^2
                fdivp           ; 1 / (3 + t^2)
                fpow            ; (1 / (3 + t^2)) ^ (1/9)

                fmulp           ; (...) ^ (1/5) * (...) ^ (1/9)
                faddp           ; (...) ^ (1/4) + (...) ^ (1/5) * (...) ^ (1/9)

                fstp    res

                mov     ax,4c00h
                int     21h
cseg            ends
                end     _start