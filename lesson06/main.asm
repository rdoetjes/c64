.const SCREEN = $0400
.const COLOR_RAM = $d800
.const RASTER_LINE = $d012

BasicUpstart2(main)
*=$1000

main:
  lda #$00
  sta $d020
  sta $d021
  lda #122
  jsr fillScreen
loop:
  lda #$f0 
!:
  cmp RASTER_LINE
  bne !-
  
  lda frame_delay
  cmp #12
  beq !+
  inc frame_delay
  jmp loop
!:
  jsr fillColors
  lda #0
  sta frame_delay
  jmp loop

fillScreen:
  ldx #$00
!:
  sta SCREEN, X           //store value in a to screen  x
  sta SCREEN + $0100, X   //store value in a to screen + $100 x
  sta SCREEN + $0200, X   //store value in a to screen + $200 x
  sta SCREEN + $02e8, X   //store value in a to screen + $300 x
  dex
  bne !-
  rts

fillColors:
  ldy #$00
!:
  jsr getNextColor
  sta COLOR_RAM, y
  sta COLOR_RAM + $100, y
  sta COLOR_RAM + $200, y
  sta COLOR_RAM + $2e8, y
  jsr getNextColor
  dey
  bne !-
  rts

getNextColor:
  ldx colorOffset
  cpx #13
  beq !+
  jmp !++
!:
  ldx #$00
  stx colorOffset
!:
  lda gradientColor, x
  inc colorOffset
  rts

frame_delay:
  .byte $00

colorOffset:
  .byte $00

gradientColor:
  .byte $01, $07, $0f, $0a, $0c, $04, $0b, $06, $06, $04, $0c, $0a, $0f, $07