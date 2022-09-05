
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

screenColor:
  lda #00
  sta $d020
  sta $d021
  rts

dinoSprite:
  lda #$80
  sta $07f8   //load sprite offset
  lda $d015
  ora #1  
  sta $d015   // enable sprite 1

  lda #$80
  sta $d000
  sta $d001   //set initial sprite position

  lda #$05     
  sta $d027   //set sprite color to green
  rts

cactusSprite:
  lda #$81
  sta $07f9   //load sprite offset
  lda $d015
  ora #2  
  sta $d015   // enable sprite 2

  lda #$9e
  sta $d002
  lda #$80
  sta $d003   //set initial sprite position

  lda #$05     
  sta $d028   //set sprite color to green
  rts


// initialize the game and setup a raster interrupt that counts the frame_counter variable, which we will poll in game loop
setupRasterInt:
  sei                         // disable interrupts

  lda #<rasterInt1            // setup rasterInt1
  sta $0314
  lda #>rasterInt1
  sta $0315

  lda #$fa
  sta $dc0d                   //acknowledge pending interrupts from CIA-1
  sta $dd0e                   //acknowledge pending interrupts from CIA-2

  and $d011            
  sta $d011                   // clear most significant bit of vicii
  
  lda #1
  sta $d01a                   // enable raster interrupts

  lda #210
  sta $d012                   //trigger raster interrupt on 7f

  asl $d019                   // accept current interrupt

  copy4Sprites(dino_w_src, dino_0_4)  //initialize dino walk sprites (0-3)
  cli
  rts

// raster interrupt 1 that counts the frames
rasterInt1:
  inc frame_counter
  lda frame_counter
  sta $0400
  asl $d019       // ack interrupt
  jmp $EA31 
  rti


// sets up the screen, interrupts and the sprites
setup:
  lda #$00
  jsr screenColor

  jsr cls
  jsr dinoSprite
  jsr cactusSprite
  jsr setupRasterInt
  
  rts

  cleanup:
    lda #54
    sta $01
    rts