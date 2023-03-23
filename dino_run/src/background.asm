#importonce
#import "lib/memorymap.asm"

BACKGROUND: {
  .label LINE = 23
}

scrollBgLogic:
  lda scroll_position_layer
  sec
  sbc scroll_speed_layer
  bcs !+
  lda #$07
  !:
  sta scroll_position_layer
  rts

scrollBackground:
  lda playerState
  cmp #STATE.GAMEOVER
  beq !return+

  lda scroll_position_layer
  cmp #$07
  bne !+
  jsr HardScroll
  lda #$07
  !:
  sta VIC.SCREEN_CR_2

  !return:
  rts

HardScroll:
  ldx #1
  !:
  lda VIC.SCREEN + (BACKGROUND.LINE * 40), x
  sta VIC.SCREEN + (BACKGROUND.LINE * 40) - 1, x
  lda VIC.SCREEN + ((BACKGROUND.LINE+1) * 40), x
  sta VIC.SCREEN + ((BACKGROUND.LINE+1) * 40) - 1, x
  inx
  cpx #40 
  bne !-
  //lda SID.OSC3_RO
  jsr rand
  and #15
  clc
  adc #64
  sta VIC.SCREEN + (BACKGROUND.LINE * 40) + 39
  //lda SID.OSC3_RO
  jsr rand
  and #15
  clc
  adc #80
  sta VIC.SCREEN + ((BACKGROUND.LINE+1) * 40) + 39
  rts

  createLandscape:
  ldx #0
  !:
    jsr rand
    and #15
    clc
    adc #64
    sta VIC.SCREEN + (BACKGROUND.LINE * 40), x
    lda #9
    sta VIC.COLOR_RAM + (BACKGROUND.LINE * 40), x
    //burn nops to get to new random number (SID chip refreshed every 16 cycles)
    nop
    nop
    nop
    nop
    nop
    jsr rand
    and #15
    clc
    adc #80
    sta VIC.SCREEN + ((BACKGROUND.LINE+1) * 40), x
    lda #9
    sta VIC.COLOR_RAM + ((BACKGROUND.LINE +1) * 40), x
    inx
    cpx #40
    bne !-
    rts
