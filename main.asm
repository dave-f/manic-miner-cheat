; Manic Miner Level Select
; Dave Footitt, 3 Dec 2018

ORG $900
GUARD &A00

.START:
    LDA #&C6
    STA &73B3
    LDA #&73
    STA &73B4
    LDA #&60
    STA &748F
    JSR &7300
    LDX #0

.LOOP:
    LDA PATCH,X
    CMP #&FF
    BEQ OUT
    STA &73C6,X
    INX
    JMP LOOP

.OUT:
    LDX #0

.LOOP2:
    LDA TEXT,X
    CMP #&FF
    BEQ OUT2
    JSR &FFEE
    INX
    JMP LOOP2

    ; Read the user's level choice via OSWORD 0
.OUT2:
    LDA #0
    LDX #BUF MOD 256
    LDY #BUF DIV 256
    JSR &FFF1
    CPY #1
    BNE PARSE

    ; Just one digit; so go straight to validation
    ; After taking 48 off.
    LDA LEVEL
    SEC
    SBC #48
    STA &F8
    JMP CLAMP

.PARSE:
    LDA LEVEL
    CMP #48
    BNE notZero

    ; First digit is zero, so use digit+1 
    LDA LEVEL+1
    SEC
    SBC #48
    STA &F8
    JMP CLAMP

.notZero:
    CMP #49
    BNE notOne
    
    ; First digit is one, so add 10 to digit+1
    LDA LEVEL+1
    SEC
    SBC #48
    CLC
    ADC #10
    STA &F8
    JMP CLAMP

.notOne:
    CMP #50
    BNE notTwo
    
    ; First digit is two, so we just set it to 20
    LDA #20
    STA &F8
    JMP OKGO

.notTwo:
    JMP DEFAULT

    ; Clamp level (&F8) between 1-20
.CLAMP:
    LDA &F8
    BEQ DEFAULT
    CMP #21
    BCC OKGO
    LDA #&14
    STA &F8
    JMP OKGO

.DEFAULT:
    LDA #1
    STA &F8

.OKGO:
    JMP &749C

.PATCH:
    EQUB &A5
    EQUB &F8
    EQUB &49
    EQUB &55
    EQUB &48
    EQUB &A2
    EQUB &00
    EQUB &BD
    EQUB &DB
    EQUB &73
    EQUB &9D
    EQUB &E1
    EQUB &2D
    EQUB &E8
    EQUB &E0
    EQUB &07
    EQUB &D0
    EQUB &F5
    EQUB &4C
    EQUB &00
    EQUB &2D
    EQUB &68
    EQUB &8D
    EQUB &01
    EQUB &62
    EQUB &4C
    EQUB &03
    EQUB &2E
    EQUB &FF

.TEXT:
    EQUB 12
    EQUB 23
    EQUB 0
    EQUB 10
    EQUB 0
    EQUB 0
    EQUB 0
    EQUB 0
    EQUB 0
    EQUB 0
    EQUB 0
    EQUS "  Start level (1-20): "
    EQUB &FF

.BUF:
    EQUB LEVEL MOD 256
    EQUB LEVEL DIV 256
    EQUB 2
    EQUB 48
    EQUB 57

.LEVEL:
    EQUB 0
    EQUB 0
    EQUB 0

.CREDIT:
    EQUS "DCF 2018"

.END:
    PRINT "Bytes used: ",END-START
    SAVE  "Miner0",START,END
