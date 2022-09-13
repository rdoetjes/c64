#importonce

//clears the screen
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


// initialize the game and setup a raster interrupt that counts the frame_counter variable, which we will poll in game loop
//X contains the line to interrupt on
setupRasterInt:
  lda #$7f
  sta $dc0d                   //acknowledge pending interrupts from CIA-1
  sta $dd0e                   //acknowledge pending interrupts from CIA-2

  lda #<gameIrq               // setup gameIrq which is basically the game loop
  sta $fffe
  lda #>gameIrq
  sta $ffff

  lda #1
  sta $d01a                   // enable raster interrupts

	lda $d011
  and #$7f
  sta $d011                   // clear most significant bit of vicii

  stx $d012                   //trigger raster interrupt on 00

  asl $d019                   // accept current interrupt
  rts