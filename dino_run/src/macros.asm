
.macro copy4Sprites(src_offset, target){
  ldx #0
  !:
    lda src_offset, x
    sta target, x
    dex
    bne !-
}
