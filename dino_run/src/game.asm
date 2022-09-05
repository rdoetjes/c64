gameLoop:
  lda frame_counter
!:
  // quit the game when quit_game is not 0
  //lda quit_game
  //bne quit
  jmp gameLoop 
quit:
  rts

rasterIntSetup:
  sei                         // disable interrupts

  lda #<rasterInt1            // setup rasterInt1
  sta $0314
  lda #>rasterInt1
  sta $0315

  lda #$7f
  sta $dc0d                   //acknowledge pending interrupts from CIA-1
  sta $dd0d                   //acknowledge pending interrupts from CIA-2

  and $d011            
  sta $d011                   // clear most significant bit of vicii
  
  lda #1
  sta $d01a                   // enable raster interrupts

  lda #210
  sta $d012                   //trigger raster interrupt on 7f

  asl $d019                   // accept current interrupt
  cli

  rts

game:
  jsr rasterIntSetup
  jsr gameLoop
  rts

rasterInt1:
  inc frame_counter
  lda frame_counter
  sta SCREEN + 4
  asl $d019       // ack interrupt
  jmp $EA31 
  rti

quit_game:
  .byte $00

score:
  .byte $00, $00, $00, $00, $00

frame_counter:
  .byte $00