#import "macros.asm"

gameLoop:
  jsr readInput
  jsr gameLogic
  jsr draw

  lda frame_counter
!:
  cmp frame_counter
  beq !-                  //sync to the frame (frame counter is incremented by raster interrupt)
  jmp gameLoop

draw:
  jsr dinoAnim
  rts

moveCharacter:
  lda playerState
  sta $0405

  lda $ff         // copy of joystick
  and #$02
  beq !dug+
  
  lda $ff         // left
  and #$04
  beq !left+

  lda $ff         // left
  and #$08
  beq !right+

  lda $ff 
  and #$80
  sta $0401
  beq !walk+
  
  lda $ff 
  and #$01
  sta $0401
  beq !jump_up+

  lda $ff 
  and #$10
  beq !jump_up+
  rts

  !left:
    lda #25
    cmp $d000
    bne !move+
    rts
  !move:
    dec $d000
    rts

  !right:
    lda #$ff
    cmp $d000
    bne !move+
    rts
  !move:
    inc $d000
    rts

  !walk:
    lda #$00
    cmp playerState
    bne !changeState+
    rts
    !changeState:
      copy4Sprites(dino_w_src, dino_0_4)
      lda #$00
      sta playerState
      rts

  !dug:
    lda #$01
    cmp playerState
    bne !changeState+
    rts
    !changeState:
      copy4Sprites(dino_d_src, dino_0_4)
      lda #$01
      sta playerState
      rts

  !jump_up:
    lda #$02
    cmp playerState
    bne !changeState+
    rts
    !changeState:
      lda #$02
      sta playerState
      copy4Sprites(dino_j_src, dino_0_4)
      rts

gameLogic:
  jsr moveCharacter   //move character based on joystick input
  rts
  
readInput:
  lda $dc00
  sta $ff
  rts

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

game:
  jsr gameStart
  jmp gameLoop
  rts

rasterInt1:
  inc frame_counter
  lda frame_counter
  sta $0400
  asl $d019       // ack interrupt
  jmp $EA31 
  rti

quit_game:
  .byte $00

score:
  .byte $00, $00, $00, $00, $00

frame_counter:
  .byte $00

dino_anim_count:
  .byte 00

playerState:
  .byte 00

*=$2000
#import "dino_sprite.asm"