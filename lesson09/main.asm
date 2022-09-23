#import "memorymap.asm"     //include some of the the constants aka lables for VIC and SID so we don't need to do that manually every time.

.const OFFSET = $190        //offset for where we want to begin writing the string

BasicUpstart2(main)

main:
  jsr setup                 // setup routine will tell VIC where to find custom charset and clears the screen
  jsr fillColorOnline       // fill the lines for the text with the repeating color gradient

everyFrame:
    jsr frameWait           // wait for rasterline (in essence waiting for the next frame)
    jsr fineScroll
    jsr colorCycle          // slide the colorgradient to the left
    
    jmp everyFrame

frameWait:
   lda #$ff                 // loop until line 255 is drawn by the VIC
 !raster:
   cmp VIC.RASTER_LINE      // compare current raster line with #$ff
   bne !raster-             // current rasterline not #$ff jump to raster, this way we sync drawing with raster line
!end:    
rts

fineScroll:
  dec VIC.XSCROLL         // decrement the VIC.XSCROLL which will only effect bits 0,1,2
  lda VIC.XSCROLL         // load the value from VIC.XSCROLLL
  and #7                  // keep last three bits intact
  cmp #0                  // check if it's 0 if inc hard_scroll to signal the event_loop to hard scroll left
  beq !+
  jmp !++
!:
  jsr scroller           // set flag to do a whole byte hard scroll
  // reset the bottom 3 bits to high again so we can count back without harming the upper bit
  lda VIC.XSCROLL           
  ora #7
  sta VIC.XSCROLL
!:
  rts
  
insertCharAtBack:
  ldx textOffset
  lda text1, x
  cmp #$00
  beq !++
!:
  sta VIC.SCREEN + OFFSET + 39
  adc #127
  sta VIC.SCREEN + OFFSET + 79
  inc textOffset
  jmp !++
!:
  ldx #$00
  stx textOffset
!:
  rts

scroller:
  ldx #1
!:
  lda VIC.SCREEN + OFFSET, x
  sta VIC.SCREEN + OFFSET - 1 , x

  lda VIC.SCREEN + OFFSET + 40 , x
  sta VIC.SCREEN + OFFSET + 40 - 1 , x
  inx
  cpx #40
  bne !-
  jsr insertCharAtBack
  rts

// this will slide the colors on the two lines pointed to by SCREEN + OFFSET to the left and inserts the first color at the back
// in essence cycling the gradient around
// clobbers, A, X and Y
colorCycle:
  ldx VIC.COLOR_RAM + OFFSET
  ldy #0
!:
  lda VIC.COLOR_RAM + OFFSET + 1, y
  sta VIC.COLOR_RAM + OFFSET + 40 , y
  sta VIC.COLOR_RAM + OFFSET, y
  iny
  cpy #41
  bne !-
  sta VIC.COLOR_RAM + OFFSET + 39
  rts

// returns the next color from the gradientColor array
//clobbers X and A
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

// Fills the colors of the gradientColors array over the two lines pointed to by COLOR+RAM + OFFSET, the gradient colors will
// loop when we get to the end of the gradientColors array. In essence filling the lines with multiple copies of the gradientColors pallet
// clobbers Y and A
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
//clobbers X and A
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

//Sets up the demo, where the character ram is pointed to $3000
// and the screen is cleared
// and border and background are set to black
// clobbers A, X and Y
setup:
  jsr pointToRAMCharSet
    
  lda #$00
  sta VIC.BORDER_COLOR
  sta VIC.SCREEN_COLOR

  jsr clearScreen
rts

// Draws the line of text to the screen on localation SCREEN+OFFSET
// The font we use is an "elongated font", that uses two characters, the top half and the bottom half.
// The top and bottom part of each letter are offset by 127 characters
text:
  ldx #$00
!write:   
  lda text1, x                          // load next character from the string text1
  cmp #$00                              // keep printing the text tuill we find character 00
  beq !end+
   
  sta VIC.SCREEN + OFFSET, x            // write top half of the character
  adc #127                              // add 127 to the character to point to the bottom half of the character
  sta VIC.SCREEN + OFFSET + 40, x       // write bottom half of the character on the next line
  inx                                   // inc offset for chracter string and location on the screen
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

hard_scroll:
  .byte 00

textOffset:
  .byte 00

text1:
  .text "...are you keeping up with the commodore?! cos, the commodore is keeping up with you...are you keeping up? cos, the commodore is keeping up with you!!!...do not forget to subscribe!!!"
  .byte 00

gradientOffset:
  .byte 00

gradientColor:
  .byte $07, $07, $0f, $0a, $0c, $04, $0b, $06, $06, $04, $0c, $0a, $0f, $0b


*=$3000                     //load charset in $3000
#import "charset_1.asm"     // load the charset_1.asm into this project, this charset is created using https://petscii.krissz.hu/ editor. Then exported to assembly and made to work with kickassembler