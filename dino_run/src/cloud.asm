#importonce

drawCloud:
    ldx #$00
    !:
    lda cloud, x
    sta VIC.SCREEN + (3 * 40) + 10, x
    lda #$01
    sta VIC.COLOR_RAM + (3 * 40) + 10,x 
    lda cloud + 4, x
    sta VIC.SCREEN + (4 * 40) + 10, x
    lda #$01
    sta VIC.COLOR_RAM + (4 * 40) + 10, x 
    inx
    cpx #$04
    bne !-

    ldx #$00
    !:
    lda cloud, x
    sta VIC.SCREEN + (8 * 40) + 30, x
    lda #$01
    sta VIC.COLOR_RAM + (8 * 40) + 30, x
    lda cloud + 4, x
    sta VIC.SCREEN + (9 * 40) + 30, x
    lda #$01
    sta VIC.COLOR_RAM + (9 * 40) + 30, x
    inx
    cpx #$04
    bne !-
    rts

cloud:
    .byte 128, 129, 130, 131
    .byte 144, 145, 146, 147