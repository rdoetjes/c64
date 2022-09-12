#importonce

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
  cmp #MAX_RIGHT_POS
  bcs !+
  sta $d000
  jmp !++
  !:
  lda #MAX_RIGHT_POS
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