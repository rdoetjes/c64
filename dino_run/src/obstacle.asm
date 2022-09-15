#importonce
#import "lib/memorymap.asm"
#import "general_game_vars.asm"

OBSTACLCE: {
  .label SPRITE_CACTUS_OFFSET = $8c
  .label SPRITE_CACTI_OFFSET = $8d
  .label SPRITE_VERN_OFFSET = $8c
}

obstacleSprites:
  lda #$8e
  sta VIC.SPRITE_1_PTR   //load sprite offset
  lda VIC.SPRITE_ENABLE
  and #%11111101  
  sta VIC.SPRITE_ENABLE   // disable sprite 2

  lda #$60
  sta VIC.SPRITE_1_X
  lda VIC.SPRITE_XCOORDINATE
  ora #$02
  sta VIC.SPRITE_XCOORDINATE

  lda #$e0
  sta VIC.SPRITE_1_Y   //set initial sprite position

  lda #$05     
  sta VIC.SPRITE_1_COLOR  //set sprite color to green

  lda #$8e
  sta VIC.SPRITE_1_PTR  //load sprite offset
  lda VIC.SPRITE_ENABLE
  ora #2  
  sta VIC.SPRITE_ENABLE   // enable sprite 2

  lda $d01e
  lda $d01f
  rts

moveObstacles:
  lda VIC.SPRITE_1_X
  sec
  sbc scroll_speed_layer
  bcc !+  
  sta VIC.SPRITE_1_X
  rts
!:
  lda VIC.SPRITE_XCOORDINATE
  eor #%00000010
  sta VIC.SPRITE_XCOORDINATE
  lda #$fe
  sta VIC.SPRITE_1_X
  rts

// Each obstacle sprite gets a frame offset in relation
// to the previous obstacle sprite
// This value is generated randomly after and instance is "spawned"
// and these values will be decremented each frame
// and when $00 is hit the sprite will be set to the end of the
// screen and allowed to run from right to left
obstacles:
    .byte $00, $00, $00, $00 
    