#import "memorymap.asm"     //include some of the the constants aka lables for VIC and SID so we don't need to do that manually every time.

.const OFFSET = $190        //offset for where we want to begin writing the string

BasicUpstart2(main)

main:
  jsr setup                 // setup routine will tell VIC where to find custom charset and clears the screen
  eventLoop:
    jsr text                // write text over and over again, as later on we will make this scroll    
    jsr fillColorOnline     // cycle the colours in the text
    jsr frameWait           // wait for a frame
    jmp eventLoop

frameWait:
   lda #$ff                 // loop until line 255 is drawn by the VIC
 !raster:
   cmp VIC.RASTER_LINE      // compare current raster line with #$ff
   bne !raster-             // current rasterline not #$ff jump to raster, this way we sync drawing with raster line
!end:    
rts

getGradientColor:
  ldx gradientOffset 
  cpx #14
  beq !+
  jmp !++
!:
  ldx #$00
  sta gradientOffset
!:
  lda gradientColor, x
  inx
  stx gradientOffset
  rts

fillColorOnline:
  ldy #39
!:
  jsr getGradientColor
  sta VIC.COLOR_RAM + OFFSET, y
  sta VIC.COLOR_RAM + OFFSET + 40, y
  dey
  cpy #$ff
  bne !-
  rts

colorCycle:
 
    
rts

//Clear the VIC.SCREEN in 4 250 character blocks
clearScreen:
  ldx #250
  lda #32 //blank tile in this map
!:
  dex
  sta VIC.SCREEN, x
  sta VIC.SCREEN+250, x
  sta VIC.SCREEN+500, x
  sta VIC.SCREEN+750, x
  bne !-
  rts

setup:
  jsr pointToRAMCharSet
    
  lda #$00
  sta VIC.BORDER_COLOR
  sta VIC.SCREEN_COLOR

  jsr clearScreen
rts

text:
  ldx #$00
!write:   
  lda text1, X
  cmp #$00
  beq !end+
   
  sta VIC.SCREEN + OFFSET, x
  adc #127
  sta VIC.SCREEN + OFFSET + 40, x 
  inx

  jmp !write-
!end:
rts

//Point to Charset in $3000, we use 3000 because we will later set a sid tune on 2000
pointToRAMCharSet:
  lda VIC.MEMORY_SETUP
  and #240
  ora #12
  sta VIC.MEMORY_SETUP
rts

text1:
  .text " are you keeping up with the commodore!"
  .byte 00

text_color_delay:
  .byte 00

gradientOffset:
  .byte 00

gradientColor:
  .byte $07, $07, $0f, $0a, $0c, $04, $0b, $06, $06, $04, $0c, $0a, $0f, $0b

//load charset in $3000
*=$3000
#import "charset_1.asm"
