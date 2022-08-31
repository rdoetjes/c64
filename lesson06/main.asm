.const SCREEN = $0400
.const COLOR_RAM = $d800
.const RASTER_LINE = $d012

BasicUpstart2(main)
*=$1000

main:
  lda #$00          // set background and border to black
  sta $d020
  sta $d021

  lda #'.'          // fill the screen with .
  jsr fillScreen

loop:
  lda #$f0          // wait for raster line $f0 (so we only draw when that line has been reached)
!:
  cmp RASTER_LINE   // check the value $f0 in A to the actual rasterline being drawn by the VIC chip
  bne !-            // if rasterline is not $f0 then jump and read rasterline until it is at $f0 (this is polling the raster line and is bad practice, but here we can get away with it)
  
  lda frame_delay   // load the value with the frame_delay count in A (we count the frame in this variable adn when it reaches 12 we reset it and fill the colours again)
  cmp #12           // this allows us to only redraw the colours every 12 frames -- otherwise it's seizure inducing flickering :D
  beq !+
  inc frame_delay   // increment the frame count
  jmp loop
!:
  jsr fillColors    // 12 frames have past so we will fill the character colours. 
  lda #0            // reset the frame_delay counter
  sta frame_delay
  jmp loop          // and loop forever

// fillScreen, fills the screen with a character set in A
// will globber X
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

//fillColors, will fill the COLOR_ROM with each char getting the next colour out of the gradientColors array
//colorOffset is the index pointer variable that points to the next gradientColors 
//Since gradientColors is not devisible by 40, it will create a moving gradient lighting bolt like pattern that has the illusion of it moving
//globbers: A, Y, X (they are not saved to save speed)
fillColors:
  ldy #$00                      //index pointing to the color_ram row char
!:
  jsr getNextColor              // get the next color from graduentColors array usingf the colorOffset variable (both defined at bottom)
  sta COLOR_RAM, y              // fill the current color at this color ram location
  sta COLOR_RAM + $100, y       // fill the current color at this color ram location offset by $100
  sta COLOR_RAM + $200, y       // fill the current color at this color ram location offset by $200
  sta COLOR_RAM + $2e8, y       // fill the current color at this color ram location offset by $2e8
  jsr getNextColor              // calling getNexColor again greates more "zigzag like strokes"; experiment with calling more or less of them
  dey                           // decrement y and if not 00 then continue filling colour ram
  bne !-
  rts                           // return from subroutine

// getNext Color will set the next color from the gradientColor array in A
// the offset into the array is stored in variable colorOffset (gradient and colorOffset are defined below )
// globbers X and A
getNextColor:
  ldx colorOffset         // load the offset into the gradientColor 
  cpx #13                 // when the offset is 13 we are at the end of the array and we need to reset it, to prevent reading outside of the array
  beq !+
  jmp !++
!:
  ldx #$00                // reset the colorOffset index to 0 when it's 13
  stx colorOffset         // store the reser offset
!:
  lda gradientColor, x    // load the color from the gradientColor based on colorOffset, it's offset
  inc colorOffset         // increment the colorOffset variable for the next call
  rts

frame_delay:              // frame_delay counter variable
  .byte $00

colorOffset:              // colorOffset variable that is the index into gradientColor array
  .byte $00

gradientColor:            // gradientColor array that defines the colours the characters on screen will have
  .byte $01, $07, $0f, $0a, $0c, $04, $0b, $06, $06, $04, $0c, $0a, $03