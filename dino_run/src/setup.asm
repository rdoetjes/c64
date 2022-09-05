
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

dinoSprite:
  lda #$80
  sta $07f8   //load sprite offset
  lda $d015
  ora #1  
  sta $d015   // enable sprite 1

  lda #$80
  sta $d000
  sta $d001   //set initial sprite position

  lda #$05     
  sta $d027   //set sprite color
  rts

cactusSprite:
  lda #$81
  sta $07f9   //load sprite offset
  lda $d015
  ora #2  
  sta $d015   // enable sprite 1

  lda #$9e
  sta $d002
  lda #$80
  sta $d003   //set initial sprite position

  lda #$05     
  sta $d028   //set sprite color
  rts

setup:
  lda #$00
  jsr screenColor
  jsr cls
  jsr dinoSprite
  jsr cactusSprite
  rts