
BasicUpstart2(main)

main:
  jsr setup
  jsr game
  rts

#import "src/init.asm"
#import "src/game.asm"
