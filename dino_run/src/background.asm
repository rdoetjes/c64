#importonce

scrollBgLogic:
  ldx #$02
!:
  lda scroll_position_layer, x
  sec
  sbc scroll_speed_layer, x
  bcs !+
  lda #$07
!:
  sta scroll_position_layer, x
  dex
  bpl !--
  rts

Background:
  ldx #$02
!:
  lda scroll_position_layer, x
  cmp #$07
  bne !+
  jsr HardScroll
  lda #$07
!:
  sta $d016
  dex
  bpl !-
  rts

HardScroll:
  ldx #1
  !:
  lda SCREEN + (BG_LINE * 40), x
  sta SCREEN + (BG_LINE * 40) - 1, x
  lda SCREEN + ((BG_LINE+1) * 40), x
  sta SCREEN + ((BG_LINE+1) * 40) - 1, x
  inx
  cpx #40 
  bne !-
  lda SID_OSC3_RO
  and #15
  adc #63
  sta SCREEN + (BG_LINE * 40) + 39
  lda SID_OSC3_RO
  and #15
  adc #79
  sta SCREEN + ((BG_LINE+1) * 40) + 39
  rts

  createLandscape:
  ldx #0
  !:
    lda $d41b
    and #15
    adc #64
    sta SCREEN + (BG_LINE * 40), x
    lda #9
    sta $d800 + (BG_LINE * 40), x
    //burn nops to get to new random number (SID chip refreshed every 16 cycles)
    nop
    nop
    nop
    nop
    nop
    lda $d41b
    and #15
    adc #80
    sta SCREEN + ((BG_LINE+1) * 40), x
    lda #9
    sta $d800 + ((BG_LINE +1) * 40), x
    inx
    cpx #40
    bne !-
    rts
