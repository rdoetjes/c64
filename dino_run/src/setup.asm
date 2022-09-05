
cls:
  ldx #250
  lda #32
!:
  sta SCREEN, x
  sta SCREEN + 250, x
  sta SCREEN + 500, x
  sta SCREEN + 750, x
  dex
  bne !-
  rts

screenColor:
  lda #00
  sta $d020
  sta $d021
  rts

setup:
  lda #$00
  jsr screenColor
  jsr cls
  rts