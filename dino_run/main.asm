BasicUpstart2(main)

#import "src/init.asm"
#import "src/macros.asm"

main:
  jsr setup
  jsr game
  rts


// load all this after the basic upstart and make it easily relocatable.
*=$2000 "sprites"
#import "src/assets/sprites/dino_sprite.asm"

*=$3000 "charset"
#import "src/assets/charset/charset.asm"

* = $8000 "Gamecode"
#import "src/vars.asm"         // game loop vars.
#import "src/game.asm"
#import "src/background.asm"
#import "src/player.asm"
#import "src/obstacle.asm"