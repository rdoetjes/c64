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

scroll_speed_bg:
  .byte $01, $02, $04

*=$2000
#import "dino_sprite.asm"

*=$3000
#import "charset.asm"

.label SCREEN = $0400
.label SID_VOICE3_LB = $d40e    //voice 3 lowbyte for requence
.label SID_VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
.label SID_WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
.label SID_OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
.label BG_LINE = 11