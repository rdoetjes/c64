#import "macros.asm"

gameLoop:
  jsr readInput           // read the joystick input
  jsr gameLogic           // process through the input and collision detection etc
  jsr draw                // draw the new state

  lda frame_counter       
  cmp frame_counter
  beq *-3                  //sync to the frame (frame counter is incremented by raster interrupt)
  jmp gameLoop

draw:
  jsr dinoAnim            // change the dino sprites depending on the joystick input
  rts

//takes care of loading the right animation cycle and moving the player sprite
moveCharacter:  
  lda playerState
  sta $0405

  lda $ff         // up, jump
  and #$01
  beq !jump_up+ 

  lda $ff         // fire button is also jump
  and #$10
  beq !jump_up+

  lda $ff         // down is dug
  and #$02
  beq !dug+
  
  lda $ff         // left
  and #$04
  beq !left+

  lda $ff         // right
  and #$08
  beq !right+

  lda $ff         // neutral position (always moving)
  and #$80
  sta $0401
  beq !walk+

  rts

  !jump_up:    // 4 sprite (0-3) jump cycle, we prevent reloading when we don't need to hence the playerState
    lda #$02
    cmp playerState
    bne !changeState+
    rts
    !changeState:
      copy4Sprites(dino_j_src, dino_0_4)
      lda #$02
      sta playerState
      rts

  !left:          // move the player sprite to the left but not off screen!
    lda #25
    cmp $d000
    bne !move+
    rts
  !move:
    dec $d000
    rts

  !right:         // move the player sprite to the right but not use the high bit, we don't want the player to be too close to the spwaning enemy
    lda #$ff
    cmp $d000
    bne !move+
    rts
  !move:
    inc $d000
    rts

  !walk:          // 4 sprite (0-3) walk cycle, we prevent reloading when we don't need to hence the playerState
    lda #$00
    cmp playerState
    bne !changeState+
    rts
    !changeState:
      copy4Sprites(dino_w_src, dino_0_4)
      lda #$00
      sta playerState
      rts

  !dug:         // 4 sprite (0-3) dug cycle, we prevent reloading when we don't need to hence the playerState
    lda #$01
    cmp playerState
    bne !changeState+
    rts
    !changeState:
      copy4Sprites(dino_d_src, dino_0_4)
      lda #$01
      sta playerState
      rts

// the game logic goes here
gameLogic:
  jsr moveCharacter   //move character based on joystick input
  rts

 // read the joy stick and store it's value in zero page ff (saves 2 cycles for each position evaluation) 
readInput:
  lda $dc00
  sta $ff
  rts

// play the 4 step player animation sprites
dinoAnim:
  inc dino_anim_count
  lda dino_anim_count
  cmp #$8
  beq !move_sprite+
  rts
  !move_sprite:
    lda #$00
    sta dino_anim_count
    lda $07f8
    cmp #$83
    beq !reset_sprite+
    inc $07f8
    rts
  !reset_sprite:
    lda #$80
    sta $07f8
    rts

// initialize the game and setup a raster interrupt that counts the frame_counter variable, which we will poll in game loop
gameStart:
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

// initialize the game, entry point from main
game:
  jsr gameStart
  jmp gameLoop
  rts

// raster interrupt 1 that counts the frames
rasterInt1:
  inc frame_counter
  lda frame_counter
  sta $0400
  asl $d019       // ack interrupt
  jmp $EA31 
  rti

//flag to allow to exit the game
quit_game:
  .byte $00

// score in BCD
score:
  .byte $00, $00, $00, $00, $00

// frame counter
frame_counter:
  .byte $00

// dino sprite counter, each dino sprite has 4 animation steps (0-3)
dino_anim_count:
  .byte 00

// the current state the player is in (allows for more efficient processing and handling events that take several frames, such as jump)
playerState:
  .byte 00

*=$2000
#import "dino_sprite.asm"