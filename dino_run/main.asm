
BasicUpstart2(main)

main:
  jsr setup
  lda #128
  sta $0402
  jsr game
  rts

#import "src/init.asm"
#import "src/game.asm"