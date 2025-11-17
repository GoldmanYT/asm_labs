
 @TopRow     equ   1
 @LeftCol    equ   3
 @BotRow     equ   22
 @RightCol   equ   76
 @MsgAddres  dw    ?
 @VGAFlag    db    1
 @ScrBufSeg  dw    0B800h
 @PageOfs    dw    ?
 @SaveRegime db    ?
 @Attr1      db    74*8 dup(1Ch),74*2 dup(0)
 @Attr2      db    74*13 dup(1Eh)
 @PelRegMas  db    300h dup(?)

 ifdef       Color
 @ColorInfo  db    ' ┌──────────────────────────────────────────────────────────────────────┐ '
             db    ' │                                                                      │ '
             db    ' │                   ▄▀▀▀▄  ▄▀▀▀▄  █     ▄▀▀▀▄  █▀▀▀▄                   │ '
             db    ' │                   █      █   █  █     █   █  █   █                   │ '
             db    ' │                   █      █   █  █     █   █  █▀█▀                    │ '
             db    ' │                   ▀▄▄▄▀  ▀▄▄▄▀  █▄▄▄▄ ▀▄▄▄▀  █  ▀▄                   │ '
             db    ' │                                                                      │ '
             db    ' └──────────────────────────────────────────────────────────────────────┘ '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ╔══════════════════════════════════════════════════════════════════════╗ '
             db    ' ║  COLOR - это демонстрационная  программа по использованию системных  ║ '
             db    ' ║  средств MS DOS и BIOS  для IBM-совместимых  компьютеров. COLOR по-  ║ '
             db    ' ║  зволяет изменять первые 16 цветовых регистров заданием долей крас-  ║ '
             db    ' ║  ного, зеленого и синего цветов. Управление осуществляется клавиша-  ║ '
             db    ' ║  ми:                                                                 ║ '
             db    ' ║     7,8,9         - увеличение долей красного, зеленого и синего;    ║ '
             db    ' ║     4,5,6         - уменьшение долей красного, зеленого и синего;    ║ '
             db    ' ║     gray+ и gray- - смена изменяемого цветового регистра;            ║ '
             db    ' ║     Enter         - завершение программы с сохранением изменений;    ║ '
             db    ' ║     Esc           - завершение программы с восстановлением палитры.  ║ '
             db    ' ╚══════════════════════════════════════════════════════════════════════╝ '
 endif

 ifdef       Defend
 @DefendInfo db    ' ┌──────────────────────────────────────────────────────────────────────┐ '
             db    ' │                                                                      │ '
             db    ' │               █▀▀▀▄  █▀▀▀▀  █▀▀▀▀  █▀▀▀▀  █    █  █▀▀▀▄              │ '
             db    ' │               █   █  █▄▄▄   █▄▄▄   █▄▄▄   █▀▄  █  █   █              │ '
             db    ' │               █   █  █      █      █      █  ▀▄█  █   █              │ '
             db    ' │               █▄▄▄▀  █▄▄▄▄  █      █▄▄▄▄  █    █  █▄▄▄▀              │ '
             db    ' │                                                                      │ '
             db    ' └──────────────────────────────────────────────────────────────────────┘ '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ╔══════════════════════════════════════════════════════════════════════╗ '
             db    ' ║  DEFEND - это демонстрационная программа по использованию системных  ║ '
             db    ' ║  средств MS DOS и BIOS  для IBM-совместимых компьютеров. DEFEND за-  ║ '
             db    ' ║  щищает COM-файлы от копирования методом привязки к месту на диске.  ║ '
             db    ' ║  После  копирования защищенная  программа выведет сообщение и отка-  ║ '
             db    ' ║  жется работать. В программе не предусмотрено скрытие механизма за-  ║ '
             db    ' ║  щиты от отладчиков и дизассемблеров, что делает защиту практически  ║ '
             db    ' ║  бессмысленной, но оставляет ее подходящей для примера. При запуске  ║ '
             db    ' ║  необходимо через  пробел  указать имя защищаемого файла, который в  ║ '
             db    ' ║  последствии станет защищенным, несколько  удлиннившись. Отсутствие  ║ '
             db    ' ║  имени файла в командной строке вызовет появление данной информации. ║ '
             db    ' ╚══════════════════════════════════════════════════════════════════════╝ '
 endif

 ifdef       Locker
 @LockerInfo db    ' ┌──────────────────────────────────────────────────────────────────────┐ '
             db    ' │                                                                      │ '
             db    ' │               █      ▄▀▀▀▄  ▄▀▀▀▄  █  ▄▀   █▀▀▀▀  █▀▀▀▄              │ '
             db    ' │               █      █   █  █      █▄▀     █▄▄▄   █   █              │ '
             db    ' │               █      █   █  █      █ ▀▄    █      █▀█▀               │ '
             db    ' │               █▄▄▄▄  ▀▄▄▄▀  ▀▄▄▄▀  █   ▀▄  █▄▄▄▄  █  ▀▄              │ '
             db    ' │                                                                      │ '
             db    ' └──────────────────────────────────────────────────────────────────────┘ '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ╔══════════════════════════════════════════════════════════════════════╗ '
             db    ' ║  LOCKER - это демонстрационная программа по использованию системных  ║ '
             db    ' ║  средств MS DOS и BIOS  для IBM-совместимых компьютеров. LOCKER по-  ║ '
             db    ' ║  зволяет "запирать" клавиатуру на время  вашего отсутствия, если вы  ║ '
             db    ' ║  хотите что-то скрыть от посторонних глаз или нежелательного вмеша-  ║ '
             db    ' ║  тельства. При запуске используются следующие ключи:                 ║ '
             db    ' ║     /i - установить программу в резидент;                            ║ '
             db    ' ║     /u - снять программу с резидента.                                ║ '
             db    ' ║  Клавиатура  "запирается"  нажатием <Cntrl+Alt+L> , а  "отпирается"  ║ '
             db    ' ║  трехкратным нажатием на <Cntrl>  (тук-тук-тук). Любой  другой ключ  ║ '
             db    ' ║  или его отсутствие вызовут появление данной информации.             ║ '
             db    ' ╚══════════════════════════════════════════════════════════════════════╝ '
 endif

 ifdef       Floppy
 @FloppyInfo db    ' ┌──────────────────────────────────────────────────────────────────────┐ '
             db    ' │                                                                      │ '
             db    ' │               █▀▀▀▀  █      ▄▀▀▀▄  █▀▀▀▄  █▀▀▀▄  █   █               │ '
             db    ' │               █▄▄▄   █      █   █  █   █  █   █  ▀▄ ▄▀               │ '
             db    ' │               █      █      █   █  █▀▀▀   █▀▀▀     █                 │ '
             db    ' │               █      █▄▄▄▄  ▀▄▄▄▀  █      █        █                 │ '
             db    ' │                                                                      │ '
             db    ' └──────────────────────────────────────────────────────────────────────┘ '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ╔══════════════════════════════════════════════════════════════════════╗ '
             db    ' ║  FLOPPY - это демонстрационная программа по использованию системных  ║ '
             db    ' ║  средств MS DOS и BIOS  для IBM-совместимых компьютеров. FLOPPY ус-  ║ '
             db    ' ║  танавливает запрет записи или чтения/записи на floppy-дисководе.    ║ '
             db    ' ║  При запуске используются следующие ключи:                           ║ '
             db    ' ║     /w - защита от записи и установка в pезидент;                    ║ '
             db    ' ║     /r - защита от чтения/записи и установка в pезидент;             ║ '
             db    ' ║     /n - снятие защиты и установка в pезидент;                       ║ '
             db    ' ║     /u - снять программу с резидента.                                ║ '
             db    ' ║  Установка в резидент только при первом запуске. Любой другой ключ   ║ '
             db    ' ║  или его отсутствие вызовут появление данной информации.             ║ '
             db    ' ╚══════════════════════════════════════════════════════════════════════╝ '
 endif

 ifdef       Elisa
 @ElisaInfo  db    ' ┌──────────────────────────────────────────────────────────────────────┐ '
             db    ' │                                                                      │ '
             db    ' │                 █▀▀▀▀  █      ▀▀█▀▀  ▄▀▀▀▄   ▄▀▄                     │ '
             db    ' │                 █▄▄▄   █        █    ▀▄▄    █   █                    │ '
             db    ' │                 █      █        █       ▀▄  █▀▀▀█                    │ '
             db    ' │                 █▄▄▄▄  █▄▄▄▄  ▄▄█▄▄  ▀▄▄▄▀  █   █                    │ '
             db    ' │                                                                      │ '
             db    ' └──────────────────────────────────────────────────────────────────────┘ '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ╔══════════════════════════════════════════════════════════════════════╗ '
             db    ' ║  ELISA - это демонстрационная программа по использованию системных   ║ '
             db    ' ║  средств MS DOS и BIOS для IBM-совместимых компьютеров. ELISA вос-   ║ '
             db    ' ║  производит мелодию, почти не влияя на производительность  компью-   ║ '
             db    ' ║  тера. При запуске используются следующие ключи:                     ║ '
             db    ' ║     /i - установить программу в резидент (install);                  ║ '
             db    ' ║     /u - снять программу с резидента (uninstall).                    ║ '
             db    ' ║  Любой другой ключ или его отсутствие вызовут появление данной ин-   ║ '
             db    ' ║  формации.                                                           ║ '
             db    ' ║                                                                      ║ '
             db    ' ║                                                                      ║ '
             db    ' ╚══════════════════════════════════════════════════════════════════════╝ '
 endif

 @WriteInfo  proc
             push  ES

             ifdef Floppy
              lea   BP,@FloppyInfo
             endif

             ifdef Elisa             
              lea   BP,@ElisaInfo
             endif
             
             ifdef Locker
              lea   BP,@LockerInfo
             endif   

             ifdef Color
              lea   BP,@ColorInfo
             endif

             ifdef Defend
              lea   BP,@DefendInfo
             endif

             lea   SI,@Attr1
             mov   AX,@ScrBufSeg
             mov   ES,AX
             mov   DH,@TopRow
             mov   AL,160
             mul   DH
             mov   DI,AX
    @L1Draw: mov   DL,@LeftCol
             xor   BH,BH
             mov   BL,DL
             shl   BX,1
             add   BX,@PageOfs
    @L2Draw: mov   AH,DS:[SI]
             inc   SI
             mov   AL,DS:[BP]
             inc   BP
             mov   ES:[BX+DI],AX
             inc   BX
             inc   BX
             inc   DL
             cmp   DL,@RightCol
             jbe   @L2Draw
             add   DI,160
             inc   DH
             cmp   DH,@BotRow
             jbe   @L1Draw
             pop   ES
             ret
 @WriteInfo  endp
 
 @TestVideo  proc
             mov   AH,0Fh
             int   10h
             mov   @SaveRegime,AL
             cmp   AL,07h
             mov   AL,02h
             jne   @NotMDA

             mov   @ScrBufSeg,0B000h
             mov   AL,70h
             mov   CX,74*8
             lea   DI,@Attr1
             rep   stosb
             mov   AL,07h
             mov   CX,74*13
             lea   DI,@Attr2
             rep   stosb

   @NotMDA:  xor   AH,AH
             int   10h
             mov   CH,20h
             mov   AH,1
             int   10h

             push  ES
             xor   AX,AX
             mov   ES,AX
             mov   AX,ES:[44Eh]
             mov   @PageOfs,AX
             pop   ES
             
             mov   AX,1A00h
             int   10h
             cmp   AL,1Ah
             je    @EndTst
             dec   @VGAFlag

   @EndTst:  ret
 @TestVideo  endp

 @ReadPelReg proc
             mov   DX,3C7h
             xor   AL,AL
             cli
             out   DX,AL

             mov   CX,300h
             mov   DX,3C9h

   @NextPelR:in    AL,DX
             and   AL,3Fh
             stosb
             loop  @NextPelR

             sti
             ret
 @ReadPelReg endp

 @WritePelReg proc
             mov   DX,3C8h
             xor   AL,AL
             cli
             out   DX,AL

    @Vert:   mov   DX,3DAh
             in    AL,DX            
             and   AL,08h
             jz    @Vert

             mov   CX,300h
             mov   DX,3C9h

   @NextPelW:lodsb
             or    AL,AL
             jz    @OutPel
             add   AL,AH
             cmp   AL,0
             jg    @MaxPel
             mov   AL,0
             jmp   short @OutPel

   @MaxPel:  cmp   AL,3Fh
             jbe   @OutPel
             mov   AL,3Fh

   @OutPel:  out   DX,AL
             loop  @NextPelW

             sti
             ret
 @WritePelReg endp

 @BeepSound  proc
             mov     CX,90
             mov     DX,600
             mov     BX,600

             in      AL,61h
             and     AL,0FEh

    @L1Beep: push    CX
             or      AL,02h
             out     61h,AL

             mov     CX,DX
    @L2Beep: loop    @L2Beep
             sub     DX,5

             and     AL,0FDh
             out     61h,AL

             mov     CX,BX
    @L3Beep: loop    @L3Beep
             add     BX,5

             pop     CX
             loop    @L1Beep

             ret
 @BeepSound  endp

 @InfoAbout  proc
             cld
             mov   @MsgAddres,DX
             call  @TestVideo
             cmp   @VGAFlag,1
             jne   @NotVGA

             lea   DI,@PelRegMas
             call  @ReadPelReg
             mov   AH,-60
             lea   SI,@PelRegMas
             call  @WritePelReg

    @NotVGA: call  @WriteInfo
             cmp   @VGAFlag,1
             jne   @Key

             mov   AH,-60

    @Next:   inc   AH
             lea   SI,@PelRegMas
             call  @WritePelReg

             mov   CX,25000
    @Pausa:  loop  @Pausa

             cmp   AH,0
             jne   @Next

    @Key:    call  @BeepSound
             mov   AH,08h
             int   21h

             xor   AH,AH
             mov   AL,@SaveRegime
             int   10h
             ret 
 @InfoAbout  endp
