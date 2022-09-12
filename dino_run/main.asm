BasicUpstart2(main)

main:
  jsr setup
  jsr game
  rts

// load all this after the basic upstart and make it easily relocatable.
#import "src/init.asm"
#import "src/game.asm"
#import "src/macros.asm"
#import "src/background.asm"
#import "src/player.asm"