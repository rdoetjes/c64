#import "memorymap.asm"
#importonce

// clears the VIC.SCREEN
// Call example:
// jsr cls
//
// Clobbers: A and X
cls:
  ldx #250
  lda #32
!:
  sta VIC.SCREEN +   0, x
  sta VIC.SCREEN + 250, x
  sta VIC.SCREEN + 500, x
  sta VIC.SCREEN + 750, x
  dex
  bne !-
  rts

//Fill the color ram with this color provided in A
fillColor:
  ldx #250
!:
  sta VIC.COLOR_RAM +   0, x
  sta VIC.COLOR_RAM + 250, x
  sta VIC.COLOR_RAM + 500, x
  sta VIC.COLOR_RAM + 750, x
  dex
  bne !-
  rts

// initialize the game and setup a raster interrupt that counts the frame_counter variable, which we will poll in game loop
// X contains the line to interrupt on
// You need to set $fffe to low byte and $ffff to high byte of routine before calling this
// Call example:
//  ldx #$a0
//  lda #<gameIrq               // setup gameIrq which is basically the game loop
//  sta $fffe
//  lda #>gameIrq
//  sta $ffff
//  jsr setupRasterInt
//
//Clobbers: A
setupRasterInt:
  sei

  lda #$7f
  sta CIA.ICR1                //acknowledge pending interrupts from CIA-1
  sta CIA.ICR2                //acknowledge pending interrupts from CIA-2

  lda #1
  sta VIC.ICR                 // enable raster interrupts

  lda VIC.SCREEN_CR_1
  and #$7f
  sta VIC.SCREEN_CR_1           // clear most significant bit of vicii

  stx VIC.RASTER_LINE         //trigger raster interrupt on 00

  asl VIC.ISR                 // accept current interrupt
  
  cli
  rts