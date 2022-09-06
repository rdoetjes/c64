#import "macros.asm"

gameLoop:
  jsr readInput           // read the joystick input
  jsr gameLogic           // process through the input and collision detection etc
  jsr draw                // draw the new state

  lda frame_counter       
  cmp frame_counter
  beq *-3                  //sync to the frame (frame counter is incremented by raster interrupt)
  jmp gameLoop

// draw the new state
draw:
  jsr dinoAnim            // change the dino sprites depending on the joystick input
  rts

//takes care of loading the right animation cycle and moving the player sprite
movePlayerCharacter:  
  lda playerState
  sta $0401

  cmp #0        //state jump coming down 
  beq !walk+
  cmp #1        //state jump coming down 
  beq !dug+
  cmp #2        //state jump up
  beq !jump_up+
  cmp #3        //state jump coming down 
  beq !jump_down+
  cmp #4        //move left
  beq !left+
  cmp #5        //move left
  beq !right+

  !walk:
    jsr walk
    rts
  !dug:
    jsr dug
    rts
  !jump_up:
    jsr jump_up
    rts
  !jump_down:
    jsr jump_down
    rts
  !left:
    jsr left
    rts
  !right:
    jsr right
    rts
  rts

jump_up:    // 4 sprite (0-3) jump cycle, we prevent reloading when we don't need to hence the playerState
  lda #$02
  cmp playerState
  bne !++
  lda jump_height
  cmp #25
  bcs !+
  inc jump_height
  dec $d001
  rts
  !: 
  lda #$03
  sta playerState
  rts
  !:
  copy4Sprites(dino_j_src, dino_0_4)
  lda #$02
  sta dino_animation_state
  rts

jump_down:
  lda jump_height
  cmp #$80
  bcs !+
  dec jump_height
  inc $d001
  rts
  !: 
  lda #$00
  sta playerState       // change state back to normal walk
  rts

walk:          // 4 sprite (0-3) walk cycle, we prevent reloading when we don't need to hence the playerState
  lda #$00
  cmp dino_animation_state
  bne !+
  rts
  !:
  copy4Sprites(dino_w_src, dino_0_4)
  lda #$00
  sta dino_animation_state
  rts

dug:         // 4 sprite (0-3) dug cycle, we prevent reloading when we don't need to hence the playerState
  lda #$01
  cmp dino_animation_state
  bne !+
  rts
  !:
  copy4Sprites(dino_d_src, dino_0_4)
  lda #$01
  sta dino_animation_state
  rts

left:
  lda #25
  cmp $d000
  bne !+
  rts
  !:
  dec $d000
  rts

right:         // move the player sprite to the right but not use the high bit, we don't want the player to be too close to the spwaning enemy
  lda #$ff
  cmp $d000
  bne !+
  rts
  !:
  inc $d000
  rts

// the game logic goes here
gameLogic:
  jsr movePlayerCharacter   //move character based on joystick input
  rts

// read the joy stick and store it's value in zero page ff (saves 2 cycles for each position evaluation) 
readInput:
  lda $dc00
  sta $ff
  
  lda playerState
  cmp #2
  beq !+  // when the player is jumping, then no input will be registered until the player is back down
  
  lda playerState
  cmp #3
  beq !+  // when the player is jumping up, then no input will be registered until the player is back down

  joystick2State($80, $00) // neutral is walk
  joystick2State($01, $02) // up  go to state jump
  joystick2State($10, $02) // button go to state jump
  joystick2State($02, $01) // down  go to dug
  joystick2State($04, $04) // left go to state left
  joystick2State($08, $05) // right go to state right

  !:
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

// initialize the game, entry point from main
game:
  jmp gameLoop
  rts

jump_height:
  .byte $00

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

dino_animation_state:
  .byte 00

*=$2000
#import "dino_sprite.asm"