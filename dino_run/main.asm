BasicUpstart2(main)

// this goes into basic code, as we use basic upstart and in basic we switch out the BASIC and KERNAL rom
#import "src/init.asm"
#import "src/macros.asm"

main:
  jsr setup
  jsr game
  rts


// load all this after the basic upstart and make it easily relocatable.
* = $2000 "Sprites"
#import "src/assets/sprites/dino_sprite.asm"

* = $3000 "Charset"
#import "src/assets/charset/charset.asm"

* = $3800 "Gamecode"
#import "src/game.asm"
#import "src/background.asm"
#import "src/player.asm"
#import "src/obstacle.asm"