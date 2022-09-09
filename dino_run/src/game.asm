#import "macros.asm"

// raster interrupt 1 that counts the frames
gameIrq:
  pushall()
  inc frame_counter
  lda frame_counter
  sta $0402
  jsr gameCycle
  popall()
  // bit $dc0d   	          // reading the interrupt control registers 
  // bit $dd0d	              // clears them
  asl $d019               // ack interrupt
  rti

gameLoop:
  // game is driven by IRQ 1 defined in init.
  jmp gameLoop

// draw the new state
gameCycle:
  jsr readInput           // process the input from the user
  jsr gameLogic           // collision detection 
  jsr draw                // draw bg and user and enemy
!:
  rts

gameLogic:
  jsr movePlayerCharacter   //move character based on joystick input
  jsr scrollBgLogic
  rts

draw:
  jsr Background
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

jump_up:    // 4 sprite (0-3) jump cycle, we prevent reloading when we don't need to hence the playerState
  lda #$02
  cmp dino_animation_state
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
  jsr jumpSound
  rts

jump_down:
  lda jump_height
  cmp #$00
  beq !+
  dec jump_height
  inc $d001
  rts
  !: 
  lda #$00
  sta playerState       // change state back to normal walk
  copy4Sprites(dino_w_src, dino_0_4)
  lda #$00
  sta dino_animation_state
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
  lda #30
  cmp $d000
  bne !+
  rts
  !:
  sec
  lda $d000
  sbc scroll_speed_layer+2
  cmp #MAX_LEFT_POS
  bcc !+
  sta $d000
  jmp !++
  !:
  lda #MAX_LEFT_POS
  sta $d000
  !:
  rts

right:         // move the player sprite to the right but not use the high bit, we don't want the player to be too close to the spwaning enemy
  lda #MAX_RIGHT_POS
  cmp $d000
  bne !+
  rts
  !:
  clc
  lda $d000
  adc scroll_speed_layer+2
  bcs !+
  sta $d000
  jmp !++
  !:
  lda #MAX_RIGHT_POS
  sta $d000
  !:
  rts

// the game logic goes here
gameInput:
    jsr readInput           // read the joystick input
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
  beq !+  // when the player is jumping (falling down from jump), then no input will be registered until the player is back down

  joystick2State($80, $00) // joystick neutral position go to walk state
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

scrollBgLogic:
  ldx #$02
!:
  lda scroll_position_layer, x
  sec
  sbc scroll_speed_layer, x
  bcs !+
  lda #$07
!:
  sta scroll_position_layer, x
  dex
  bpl !--
  rts

Background:
  ldx #$02
!:
  lda scroll_position_layer, x
  cmp #$07
  bne !+
  jsr HardScroll
  lda #$07
!:
  sta $d016
  dex
  bpl !-
  rts

HardScroll:
  ldx #1
  !:
  lda SCREEN + (BG_LINE * 40), x
  sta SCREEN + (BG_LINE * 40) - 1, x
  lda SCREEN + ((BG_LINE+1) * 40), x
  sta SCREEN + ((BG_LINE+1) * 40) - 1, x
  inx
  cpx #40 
  bne !-
  lda SID_OSC3_RO
  and #15
  adc #63
  sta SCREEN + (BG_LINE * 40) + 39
  lda SID_OSC3_RO
  and #15
  adc #79
  sta SCREEN + ((BG_LINE+1) * 40) + 39
  rts

// initialize the game, entry point from main
game:
  jmp gameLoop
  rts

jumpSound:
  lda #$ff
  sta $d406
  
  lda #$80
  sta $d400
  sta $d401
  
  lda #%00100000
  sta $d404

  lda #$0f
  sta $d406
  
  lda #$05
  sta $d418 
  rts

  #import "vars.asm"
