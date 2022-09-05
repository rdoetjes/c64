
BasicUpstart2(main)

main:
  jsr setup
  jsr game
  rts

*=$1000
#import "src/game.asm"
#import "src/setup.asm"

.label SCREEN = $0400