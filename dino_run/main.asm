
BasicUpstart2(main)

main:
  jsr setup
  jsr game
  jsr cleanup
  rts

#import "src/game.asm"
#import "src/setup.asm"

.label SCREEN = $0400