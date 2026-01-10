SRC     =       $06
SRCL    =       $06
SRCH    =       $07
DST     =       $08
DSTL    =       $08
DSTH    =       $09
ROWIDX  =       $0A
PIXNXT  =       $4000
PRODOS  =       $BF00
;*
;* FILL PIX INC TABLE
;*
BLDTBL  LDY     #$00
-       TYA
        CLC
        ADC     #$01
        AND     #$0F
        STA     PIXNXT,Y
        TYA
        CLC
        ADC     #$10
        AND     #$F0
        ORA     PIXNXT,Y
        STA     PIXNXT,Y
        INY
        BNE    -
;*
;* PRINT PROMPTS AND SET GR MODE
;*
        JSR     $FC58           ; HOME
        LDA     #0
        STA     $24             ; CH
        LDA     #21
        STA     $25             ; CV
        JSR     $FC22           ; VTAB
        LDA     #<OPT1
        LDX     #>OPT1
        JSR     PUTS
        LDA     #0
        STA     $24             ; CH
        LDA     #23
        STA     $25             ; CV
        JSR     $FC22
        LDA     #<OPT2
        LDX     #>OPT2
        JSR     PUTS
        LDA     $C056
        LDA     $C053
        LDA     $C050
;*
;* COPY IMAGE TO SCREEN
;*
        LDA     #<SCRNPIX
        STA     SRCL
        LDA     #>SCRNPIX
        STA     SRCH
        LDY     #$00
        STY     ROWIDX
FILLROW LDA     TXTROW,Y
        STA     DSTL
        INY
        LDA     TXTROW,Y
        STA     DSTH
        INY
        STY     ROWIDX
        LDY     #$00
-       LDA     (SRC),Y
        STA     (DST),Y
        INY
        CPY     #40
        BNE     -
        TYA
        CLC
        ADC     SRCL
        STA     SRCL
        LDA     #$00
        ADC     SRCH
        STA     SRCH
        LDY     ROWIDX
        CPY     #40
        BCC     FILLROW
;*
;* MOVE LOFI DOWN TO $1000
;*
LOFIMOVE LDA    #<_LOFIBEGIN
        STA     SRCL
        LDA     #>_LOFIBEGIN
        STA     SRCH
        LDY     #$00
        STY     DSTL
        LDA     #$10
        STA     DSTH
        LDX     #>_LOFIEND-$10
-       LDA     (SRC),Y
        STA     (DST),Y
        INY
        BNE     -
        INC     SRCH
        INC     DSTH
        DEX                     ; STOP WHEN DST=$2000 REACHED
        BPL     -
        JMP     $1000

_LOFIBEGIN   =   *
!PSEUDOPC   $1000 {
-       JSR     CLRCYCLE
        LDA     #$FF
        JSR     $FCA8           ; WAIT
        LDA     $C000
        BPL     -
        CMP     #$80|'1'
        BEQ     HBCC
        CMP     #$80|'2'
        BEQ     LIGHTCYCLES
        LDA     $C010
        JMP     -
;*
;* READ HBCC.SYSTEM INTO MEMORY
;*
HBCC    JSR     PRODOS          ; CLOSE EVERYTHING
        !BYTE   $CC
        !WORD   CLOSEPARMS
+       JSR     PRODOS          ; GET PREFIX
        !BYTE   $C6
        !WORD   SETPFXHBCC
        JSR     PRODOS          ; OPEN CMD
        !BYTE   $C8
        !WORD   OPENHBCC
        LDA     REFHBCC
        STA     READHBCC+1
        JSR     PRODOS
        !BYTE   $CA
        !WORD   READHBCC
        JSR     PRODOS
        !BYTE   $CC
        !WORD   CLOSEPARMS
        LDA     $C051
        JMP     $2000
SETPFXHBCC !BYTE 1
        !WORD   HBCCPFX          ; PATH STRING GOES HERE
HBCCPFX !TEXT   4, "HBCC"
OPENHBCC !BYTE 3
        !WORD   HBCCSTR
        !WORD   $0800
REFHBCC !BYTE   0
READHBCC !BYTE 4
        !BYTE   0
        !WORD   $2000
        !WORD   $9F00
        !WORD   0
CLOSEPARMS !BYTE 1
        !BYTE   0
HBCCSTR !TEXT   11, "HBCC.SYSTEM"
;*
;* READ BASIC.SYSTEM INTO MEMORY
;*
LIGHTCYCLES JSR     PRODOS          ; CLOSE EVERYTHING
        !BYTE   $CC
        !WORD   CLOSEPARMS
+       JSR     PRODOS          ; GET PREFIX
        !BYTE   $C6
        !WORD   SETPFXLC
        JSR     PRODOS          ; OPEN CMD
        !BYTE   $C8
        !WORD   OPENLC
        LDA     REFLC
        STA     READLC+1
        JSR     PRODOS
        !BYTE   $CA
        !WORD   READLC
        JSR     PRODOS
        !BYTE   $CC
        !WORD   CLOSEPARMS
        LDA     $C051
        JMP     $2000
SETPFXLC !BYTE 1
        !WORD   LCPFX          ; PATH STRING GOES HERE
LCPFX   !TEXT   11, "LIGHTCYCLES"
OPENLC  !BYTE 3
        !WORD   LCSTR
        !WORD   $0800
REFLC   !BYTE   0
READLC  !BYTE 4
        !BYTE   0
        !WORD   $2000
        !WORD   $9F00
        !WORD   0
LCSTR   !TEXT   12, "BASIC.SYSTEM"
CLRCYCLE LDY    #$77
-       LDX     $0400,Y
        LDA     PIXNXT,X
        STA     $0400,Y
        LDX     $0480,Y
        LDA     PIXNXT,X
        STA     $0480,Y
        LDX     $0500,Y
        LDA     PIXNXT,X
        STA     $0500,Y
        LDX     $0580,Y
        LDA     PIXNXT,X
        STA     $0580,Y
        DEY
        BPL     -
        LDY     #$4F
-       LDX     $0600,Y
        LDA     PIXNXT,X
        STA     $0600,Y
        LDX     $0680,Y
        LDA     PIXNXT,X
        STA     $0680,Y
        LDX     $0700,Y
        LDA     PIXNXT,X
        STA     $0700,Y
        LDX     $0780,Y
        LDA     PIXNXT,X
        STA     $0780,Y
        DEY
        BPL     -
        RTS
}
PUTS    STA     SRCL
        STX     SRCH
        LDY     #$00
        BEQ     +
-       ORA     #$80
        JSR     $FBFD
+       LDA     (SRC),Y
        BNE     -
        RTS
_LOFIEND     =   *
OPT1    !TEXT   " 1. ESCAPE THE HOMEBREW COMPUTER CLUB"
        !BYTE   0
OPT2    !TEXT   " 2.            LIGHTCYCLES"
        !BYTE   0
TXTROW  !WORD   $0400, $0480, $0500, $0580, $0600, $0680, $0700, $0780
        !WORD   $0428, $04A8, $0528, $05A8, $0628, $06A8, $0728, $07A8
        !WORD   $0450, $04D0, $0550, $05D0, $0650, $06D0, $0750, $07D0
SCRNPIX !BYTE   $88, $99, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $99, $88
        !BYTE   $77, $77, $88, $99, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9, $A9 
        !BYTE   $A9, $A9, $A9, $A9, $99, $88, $77, $66, $88, $99, $AA, $BB, $CB, $CB, $CB, $CB 
        !BYTE   $CB, $CB, $CB, $CB, $BB, $AA, $99, $98, $98, $98, $98, $99, $AA, $BB, $CB, $CB 
        !BYTE   $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $BB, $AA, $99, $88, $87, $87 
        !BYTE   $88, $99, $AA, $BB, $CC, $DD, $ED, $ED, $ED, $ED, $DD, $CC, $BB, $BA, $BA, $BA 
        !BYTE   $BA, $BA, $BA, $BA, $BA, $BB, $CC, $DD, $ED, $ED, $ED, $ED, $ED, $ED, $ED, $ED 
        !BYTE   $DD, $CC, $BB, $AA, $A9, $A9, $A9, $99, $88, $99, $AA, $BB, $CC, $DD, $EE, $FF 
        !BYTE   $FF, $EE, $DD, $CC, $CC, $DC, $DC, $DC, $DC, $DC, $DC, $DC, $CC, $BB, $CC, $DD 
        !BYTE   $EE, $FF, $FF, $FF, $FF, $FF, $FF, $EE, $DD, $CC, $CB, $CB, $CB, $BB, $AA, $99 
        !BYTE   $88, $99, $AA, $BB, $CC, $DD, $EE, $FF, $FF, $EE, $DD, $DC, $DC, $DD, $EE, $FE 
        !BYTE   $FE, $FE, $EE, $DD, $DC, $DC, $DC, $DD, $EE, $FF, $FF, $EE, $DE, $DE, $DE, $EE 
        !BYTE   $ED, $ED, $ED, $DD, $CC, $BB, $AA, $99, $88, $99, $AA, $BB, $CC, $DD, $EE, $FF 
        !BYTE   $FF, $EE, $DD, $DD, $EE, $FE, $FE, $EF, $EF, $EF, $FE, $FE, $EE, $FE, $FE, $FE 
        !BYTE   $EE, $FF, $FF, $EE, $ED, $ED, $DD, $EE, $FF, $FF, $EE, $DD, $CC, $BB, $AA, $99 
        !BYTE   $88, $99, $AA, $BB, $CC, $DD, $EE, $FF, $FF, $EE, $DD, $DD, $EE, $FF, $FF, $EE 
        !BYTE   $DD, $EE, $FF, $FF, $EE, $EF, $EF, $EF, $EE, $FF, $FF, $FF, $FF, $EE, $DD, $EE 
        !BYTE   $EE, $EE, $EE, $DD, $CC, $BB, $AA, $99, $88, $99, $AA, $BB, $CC, $DD, $EE, $FF 
        !BYTE   $FF, $EE, $DD, $DD, $EE, $FF, $FF, $EE, $DD, $EE, $FF, $FF, $EE, $DD, $CD, $DD 
        !BYTE   $EE, $FF, $FF, $EE, $DE, $DE, $DD, $EE, $FF, $FF, $EE, $DD, $CC, $BB, $AA, $99 
        !BYTE   $88, $99, $AA, $BB, $CC, $DD, $EE, $FF, $FF, $FE, $FE, $FE, $EE, $EF, $EF, $FE 
        !BYTE   $FE, $FE, $EF, $EF, $EE, $DD, $CC, $DD, $EE, $FF, $FF, $EE, $DD, $CC, $DD, $EE 
        !BYTE   $FF, $FF, $EE, $DD, $CC, $BB, $AA, $99, $88, $99, $AA, $BB, $CC, $DD, $EE, $EF 
        !BYTE   $EF, $EF, $EF, $EF, $EE, $DD, $EE, $EF, $EF, $EF, $EE, $DD, $CD, $CD, $CC, $DD 
        !BYTE   $EE, $EF, $EF, $EE, $DD, $CC, $DD, $EE, $EF, $EF, $EE, $DD, $CC, $BB, $AA, $99 
        !BYTE   $88, $99, $AA, $BB, $CC, $CD, $CD, $CD, $CD, $DD, $EE, $FE, $FE, $FE, $FE, $FE 
        !BYTE   $FE, $FE, $EE, $DD, $CC, $BB, $CC, $DD, $ED, $ED, $ED, $ED, $ED, $ED, $ED, $ED 
        !BYTE   $DD, $DD, $CD, $CD, $CC, $BB, $AA, $99, $88, $99, $AA, $AB, $AB, $AB, $AB, $BB 
        !BYTE   $CC, $DD, $EE, $EF, $EF, $EF, $EF, $EF, $FF, $FF, $EE, $DD, $CC, $CB, $CC, $DD 
        !BYTE   $EE, $FF, $FF, $FF, $FF, $FF, $FF, $FE, $EE, $ED, $DD, $CC, $BB, $AB, $AA, $99 
        !BYTE   $88, $89, $89, $89, $89, $99, $AA, $BB, $CC, $CD, $DD, $DD, $ED, $EE, $FE, $FF 
        !BYTE   $EF, $EE, $DE, $ED, $ED, $ED, $ED, $ED, $EE, $FF, $FF, $EE, $DE, $EE, $EF, $FF 
        !BYTE   $FF, $EE, $DD, $CC, $BB, $AA, $99, $89, $67, $67, $67, $77, $88, $99, $AA, $BB 
        !BYTE   $BB, $CC, $DD, $EE, $FE, $FF, $FF, $FE, $FE, $EE, $ED, $EE, $FF, $FF, $FF, $EE 
        !BYTE   $EE, $FF, $FF, $EE, $DD, $DD, $EE, $FF, $FF, $EE, $DD, $CC, $BB, $AA, $99, $88 
        !BYTE   $45, $55, $66, $77, $88, $99, $AA, $BB, $CC, $DC, $DD, $EE, $EF, $EF, $EF, $EF 
        !BYTE   $FF, $FF, $EE, $DE, $DE, $DE, $DE, $DE, $EE, $FF, $FF, $EE, $DD, $DD, $EE, $FF 
        !BYTE   $FF, $EE, $DD, $CC, $BB, $AA, $99, $88, $44, $55, $66, $77, $88, $99, $AA, $BB 
        !BYTE   $CC, $DD, $EE, $FE, $FE, $EE, $ED, $EE, $FF, $FF, $EE, $DD, $CC, $BC, $CC, $DD 
        !BYTE   $EE, $FF, $FF, $EE, $ED, $EE, $FE, $FF, $FF, $EE, $DD, $CC, $BB, $AA, $99, $88 
        !BYTE   $44, $55, $66, $77, $88, $99, $AA, $BB, $CC, $DD, $EE, $EF, $FF, $FF, $FF, $FF 
        !BYTE   $FF, $EF, $EE, $DD, $CC, $BB, $CC, $DD, $EE, $FF, $FF, $FF, $FF, $FF, $FF, $EF 
        !BYTE   $EE, $DE, $DD, $CC, $BB, $AA, $99, $88, $44, $55, $66, $77, $88, $99, $AA, $BB 
        !BYTE   $CC, $CD, $DD, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DD, $CD, $CC, $BB, $CC, $DD 
        !BYTE   $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DD, $CD, $CC, $BC, $BB, $AA, $99, $88 
        !BYTE   $44, $55, $66, $77, $88, $99, $AA, $AB, $BB, $BC, $BC, $BC, $BC, $BC, $BC, $BC 
        !BYTE   $BC, $BC, $BC, $BC, $BB, $BB, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC 
        !BYTE   $BC, $BC, $BB, $AB, $AA, $9A, $99, $88, $44, $55, $66, $77, $88, $89, $99, $9A 
        !BYTE   $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A 
        !BYTE   $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $99, $89, $88, $78 