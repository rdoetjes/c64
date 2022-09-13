#import "game_states.asm"
#importonce


PLAYER: {
  .label MAX_LEFT_POS = 40
  .label MAX_RIGHT_POS = 230
}


dinoSprite:
  lda #$80
  sta SCREEN + $03f8   //load sprite offset (sprites always start 3f8 after the sceen)
  lda $d015
  ora #1  
  sta $d015   // enable sprite 1

  lda #$80
  sta $d000
  lda #$e0
  sta $d001   //set initial sprite position

  lda #$05     
  sta $d027   //set sprite color to green
  rts

//takes care of loading the right animation cycle and moving the player sprite
movePlayerCharacter:  
  lda playerState
  sta $0401

  cmp #STATE.WALK             //state jump coming down 
  beq !walk+
  cmp #STATE.DUG              //state dug
  beq !dug+
  cmp #STATE.JUMP_UP          //state jump up
  beq !jump_up+
  cmp #STATE.JUMP_DOWN        //state jump coming down 
  beq !jump_down+
  cmp #STATE.MOVE_LEFT        //move left
  beq !left+
  cmp #STATE.MOVE_RIGHT       //move left
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
  lda #STATE.JUMP_UP
  cmp dino_animation_state
  bne !++
  lda jump_height
  cmp #25
  bcs !+
  inc jump_height
  dec $d001
  rts
  !: 
  lda #STATE.JUMP_DOWN
  sta playerState
  rts
  !:
  copy4Sprites(dino_j_src, dino_0_4)
  lda #STATE.JUMP_UP
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
  lda #STATE.WALK
  sta playerState       // change state back to normal walk
  sta dino_animation_state
  copy4Sprites(dino_w_src, dino_0_4)
  rts

walk:          // 4 sprite (0-3) walk cycle, we prevent reloading when we don't need to hence the playerState
  lda #STATE.WALK
  cmp dino_animation_state
  bne !+
  rts
  !:
  copy4Sprites(dino_w_src, dino_0_4)
  lda #STATE.WALK
  sta dino_animation_state
  rts

dug:         // 4 sprite (0-3) dug cycle, we prevent reloading when we don't need to hence the playerState
  lda #STATE.DUG
  cmp dino_animation_state
  bne !+
  rts
  !:
  copy4Sprites(dino_d_src, dino_0_4)
  lda #STATE.DUG
  sta dino_animation_state
  rts

left:
  lda #PLAYER.MAX_LEFT_POS
  cmp $d000
  bne !+
  rts
  !:
  sec
  lda $d000
  sbc scroll_speed_layer+2
  cmp #PLAYER.MAX_LEFT_POS
  bcc !+
  sta $d000
  jmp !++
  !:
  lda #PLAYER.MAX_LEFT_POS
  sta $d000
  !:
  rts

right:         // move the player sprite to the right but not use the high bit, we don't want the player to be too close to the spwaning enemy
  lda #PLAYER.MAX_RIGHT_POS
  cmp $d000
  bne !+
  rts
  !:
  clc
  lda $d000
  adc scroll_speed_layer+2
  cmp #PLAYER.MAX_RIGHT_POS
  bcs !+
  sta $d000
  jmp !++
  !:
  lda #PLAYER.MAX_RIGHT_POS
  sta $d000
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

jumpSound:
  lda #$ff
  sta $d406
  
  lda #$10
  sta $d400
  sta $d401
  
  lda #%10100001
  sta $d404

  lda #$f8
  sta $d406
  
  lda #$0f
  sta $d418 

  lda #%00100000
  sta $d404
  rts

  // dino sprite counter, each dino sprite has 4 animation steps (0-3)
dino_anim_count:
  .byte 00

// the current state the player is in (allows for more efficient processing and handling events that take several frames, such as jump)
playerState:
  .byte 00

dino_animation_state:
  .byte 00

jump_height:
  .byte $00

