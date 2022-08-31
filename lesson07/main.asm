*=$1000
#import "memorymap.asm"

.var OFFSET = $140

BasicUpstart2(main)

main:
  jsr setup

  ldx #00
  sta frameCount
  sta frameCount+1

  eventLoop:
    jsr colorCycle

    jsr text

    jsr frameWait

    jmp eventLoop
rts

frameWait:
   lda #$f0
 !raster:
   cmp VIC.RASTER_LINE
   bne !raster-
   lda frameCount
   adc #1 
   sta frameCount
   bcs !add+
   jmp !end+
!add:
   adc frameCount+1
   sta frameCount+1
!end:    
rts

colorCycle:
  ldx gradientOffset
  inx
  cpx #14
  beq !resetX+
  jmp !storeX+
!resetX:
  ldx #$0
!storeX:
  stx gradientOffset
  
  ldy #$ff  //number of characters + 1
!fetchColor:
  dey
  lda gradientColor, x
  sta VIC.COLOR_RAM + OFFSET, y
  sta VIC.COLOR_RAM + OFFSET + 40, y
  inx
  cpx #14
  beq !+
  cpy #$00
  beq !end+
  jmp !fetchColor-
!:
  ldx #$0
  jmp !fetchColor-
!end:    
rts

setup:
   jsr pointToRAMCharSet
    
    lda #$00
    sta VIC.BORDER_COLOR
    sta VIC.SCREEN_COLOR

    jsr Cls
rts

text:
   ldx #$00
!write:   
   lda text1, X
   cmp #$00
   beq !end+
   
   sta VIC.SCREEN + OFFSET, x
   adc #31
   sta VIC.SCREEN + OFFSET + 40, x 
   inx

   jmp !write-
!end:
rts

//Point to Charset in $3000
pointToRAMCharSet:
    lda VIC.MEMORY_SETUP
    and #240
    ora #12
    sta VIC.MEMORY_SETUP
rts

//Clear the VIC.SCREEN in 4 250 character blocks
Cls:
    ldx #250
    lda #96 //blank tile in this map
  !:
    dex
    sta VIC.SCREEN, x
    sta VIC.SCREEN+250, x
    sta VIC.SCREEN+500, x
    sta VIC.SCREEN+750, x
    bne !-
rts

text1:
    .text "the commodore rules it is wonderful"
    .byte 00
text1end:

frameCount:
    .byte 00, 00

gradientOffset:
  .byte 00

gradientColor:
  .byte $01, $07, $0f, $0a, $0c, $04, $0b, $06, $06, $04, $0c, $0a, $0f, $07
//load charset in $3000
*=$3000
.import binary "myset.bin" 