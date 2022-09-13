#importonce
#import "lib/memorymap.asm"
#import "general_game_vars.asm"

OBSTACLCE: {
  .label SPRITE_CACTUS_OFFSET = $8c
  .label SPRITE_CACTI_OFFSET = $8d
  .label SPRITE_VERN_OFFSET = $8c
}

cactusSprite:
  lda #$8e
  sta VIC.SCREEN + $03f9   //load sprite offset
  lda VIC.SPRITE_ENABLE
  ora #2  
  sta VIC.SPRITE_ENABLE   // enable sprite 2

  lda #$60
  sta VIC.SPRITE_1_X
  lda VIC.XCOORDINATE
  ora #$02
  sta VIC.XCOORDINATE

  lda #$e0
  sta VIC.SPRITE_1_Y   //set initial sprite position

  lda #$05     
  sta VIC.SPRITE_1_COLOR  //set sprite color to green
  rts

  moveObstacle1:
    lda VIC.SPRITE_1_X
    sbc scroll_speed_layer + 1
    bcc !+
    sta VIC.SPRITE_1_X
    rts
  !:
    lda #%11111101
    and VIC.XCOORDINATE
    sta VIC.XCOORDINATE
    lda #$ff
    sta VIC.SPRITE_1_X
    rts