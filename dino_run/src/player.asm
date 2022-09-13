#importonce
#import "game_states.asm"
#import "lib/memorymap.asm"

PLAYER: {
  .label MAX_LEFT_POS = 40
  .label MAX_RIGHT_POS = 230
}


dinoSprite:
  lda #$80
  sta VIC.SCREEN + $03f8   //load sprite offset (sprites always start 3f8 after the sceen)
  lda VIC.SPRITE_ENABLE
  ora #1  
  sta VIC.SPRITE_ENABLE   // enable sprite 1

  lda #$80                //set initial sprite position
  sta VIC.SPRITE_0_X
  lda #$e0
  sta VIC.SPRITE_0_Y   

  lda #$05     
  sta VIC.SPRITE_0_COLOR   //set sprite color to green
  rts

//takes care of loading the right animation cycle and moving the player sprite
movePlayerCharacter:  
  lda playerState
  sta VIC.SCREEN + 1

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
  cmp VIC.SPRITE_0_X
  bne !+
  rts
  !:
  sec
  lda VIC.SPRITE_0_X
  sbc scroll_speed_layer+2
  cmp #PLAYER.MAX_LEFT_POS
  bcc !+
  sta VIC.SPRITE_0_X
  jmp !++
  !:
  lda #PLAYER.MAX_LEFT_POS
  sta VIC.SPRITE_0_X
  !:
  rts

right:         // move the player sprite to the right but not use the high bit, we don't want the player to be too close to the spwaning enemy
  lda #PLAYER.MAX_RIGHT_POS
  cmp VIC.SPRITE_0_X
  bne !+
  rts
  !:
  clc
  lda VIC.SPRITE_0_X
  adc scroll_speed_layer+2
  cmp #PLAYER.MAX_RIGHT_POS
  bcs !+
  sta VIC.SPRITE_0_X
  jmp !++
  !:
  lda #PLAYER.MAX_RIGHT_POS
  sta VIC.SPRITE_0_X
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
    lda VIC.SPRITE_0_PTR
    cmp #$83
    beq !reset_sprite+
    inc VIC.SPRITE_0_PTR
    rts
  !reset_sprite:
    lda #$80
    sta VIC.SPRITE_0_PTR
    rts

jumpSound:
  lda #$ff
  sta SID.VOICE1_SUSTAIN_RELEASE
  
  lda #$10
  sta SID.VOICE2_FREQ_LB
  sta SID.VOICE2_FREQ_HB
  
  lda #%10100001  //noise plus saw tooth and gate on
  sta SID.VOICE1_CTRL

  lda #$f8
  sta SID.VOICE1_SUSTAIN_RELEASE
  
  lda #$0f
  sta SID.VOLUME_FILTER

  lda #%00100000
  sta SID.VOICE1_CTRL
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

