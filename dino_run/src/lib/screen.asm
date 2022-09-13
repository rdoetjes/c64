#import "memorymap.asm"
#importonce

//clears the VIC.SCREEN
cls:
  ldx #250
  lda #32
!:
  sta VIC.SCREEN, x
  sta VIC.SCREEN + 250, x
  sta VIC.SCREEN + 500, x
  sta VIC.SCREEN + 750, x
  dex
  bne !-
  rts


// initialize the game and setup a raster interrupt that counts the frame_counter variable, which we will poll in game loop
//X contains the line to interrupt on
setupRasterInt:
  sei

  lda #$7f
  sta CIA.ICR1                //acknowledge pending interrupts from CIA-1
  sta CIA.ICR2                //acknowledge pending interrupts from CIA-2

  lda #<gameIrq               // setup gameIrq which is basically the game loop
  sta $fffe
  lda #>gameIrq
  sta $ffff

  lda #1
  sta VIC.ICR                 // enable raster interrupts

  lda VIC.SCREEN_CR
  and #$7f
  sta VIC.SCREEN_CR           // clear most significant bit of vicii

  stx VIC.RASTER_LINE         //trigger raster interrupt on 00
  cli
  asl VIC.ISR                 // accept current interrupt
  rts