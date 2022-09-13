#importonce 

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