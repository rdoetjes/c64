#importonce 

.macro copy4Sprites(src_offset, target){
  ldx #0
  !:
    lda src_offset, x
    sta target, x
    dex
    bne !-
}

.macro joystick2State(mask, state){
  lda $ff         // up, jump
  and #mask
  bne !+
  lda #state
  sta playerState
  !:
}

.macro pushall(){
  pha
  txa
  pha
  tya
  pha
}

.macro popall(){
  pla
  tay
  pla
  tax
  pla
}