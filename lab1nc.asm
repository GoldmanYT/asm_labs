data            segment
array           db      1,10,-5,7,-8,0,4
len             dw      $-array
data            ends

cnt_pos         macro   adr,n
                mov     dl,0            
                mov     bx,0            
                mov     cx,n
next_iter:      mov     al,adr[bx]      
                cmp     al,0            
                jng     ignore          
                inc     dl              
ignore:         inc     bx              
                loop    next_iter       
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
