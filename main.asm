        .model  small
        .stack  100h
        .code
start:  mov     ax,@data
        mov     ds,ax
        mov     cx,256
        mov     dl,0
        mov     ah,6
cloop:  int     21h
        inc     dl
        test    dl,0fh
        jnz     continue_loop
        push    dx
        mov     dl,0Dh
        int     21h
        mov     dl,0Ah
        int     21h
        pop     dx
continue_loop:
        loop    cloop
        mov     ax,4c00h
        int     21h
        end     start