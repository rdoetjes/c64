#import "memorymap.asm"     //include some of the the constants aka lables for VIC and SID so we don't need to do that manually every time.

.const OFFSET = $190        //offset for where we want to begin writing the string

BasicUpstart2(main)

main:
  jsr setup                 // setup routine will tell VIC where to find custom charset and clears the screen
  jsr fillColorOnline       // fill the lines for the text with the repeating color gradient
  eventLoop:
    jsr text                // write text over and over again, as later on we will make this scroll and now it will slow down the pulsing off the colors nicely    
    jsr colorCycle          // slide the colorgradient to the left
    jsr frameWait           // wait for rasterline (in essence waiting for the next frame)
    jmp eventLoop

frameWait:
   lda #$ff                 // loop until line 255 is drawn by the VIC
 !raster:
   cmp VIC.RASTER_LINE      // compare current raster line with #$ff
   bne !raster-             // current rasterline not #$ff jump to raster, this way we sync drawing with raster line
!end:    
rts

colorCycle:
  ldx VIC.COLOR_RAM + OFFSET
  ldy #1
!:
  lda VIC.COLOR_RAM + OFFSET + 1, y
  sta VIC.COLOR_RAM + OFFSET + 40 , y
  sta VIC.COLOR_RAM + OFFSET, y
  iny
  cpy #41
  bne !-
  sta VIC.COLOR_RAM + OFFSET + 39
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
  // Table of lower nibble and the corresponding character ram address  
  // $D018 = %xxxx000x -> charmem is at $0000
  // $D018 = %xxxx001x -> charmem is at $0800
  // $D018 = %xxxx010x -> charmem is at $1000
  // $D018 = %xxxx011x -> charmem is at $1800
  // $D018 = %xxxx100x -> charmem is at $2000
  // $D018 = %xxxx101x -> charmem is at $2800
  // $D018 = %xxxx110x -> charmem is at $3000
  // $D018 = %xxxx111x -> charmem is at $3800
  and #240              // keep the upper 4 bits, so that screen RAM points to 0400
  ora #12               // set lowest 4 bits to 12, moving charset ram to $3000
  sta VIC.MEMORY_SETUP  // sta the configuration of screen ram and character ram offsets to VIC
rts

text1:
  .text " are you keeping up with the commodore?!"
  .byte 00

gradientOffset:
  .byte 00

gradientColor:
  .byte $07, $07, $0f, $0a, $0c, $04, $0b, $06, $06, $04, $0c, $0a, $0f, $0b

//load charset in $3000
*=$3000
#import "charset_1.asm"
