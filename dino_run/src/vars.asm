#importonce

jump_height:
  .byte $00

//flag to allow to exit the game
quit_game:
  .byte $00

// score in BCD
score:
  .byte $00, $00, $00, $00, $00

// frame counter
frame_counter:
  .byte $00

// dino sprite counter, each dino sprite has 4 animation steps (0-3)
dino_anim_count:
  .byte 00

// the current state the player is in (allows for more efficient processing and handling events that take several frames, such as jump)
playerState:
  .byte 00

dino_animation_state:
  .byte 00

*=$2000
#import "dino_sprite.asm"

.label SCREEN = $0400