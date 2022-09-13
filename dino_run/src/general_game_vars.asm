#importonce

//flag to allow to exit the game
quit_game:
  .byte $00

// score in BCD
score:
  .byte $00, $00, $00, $00, $00

// frame counter
frame_counter:
  .byte $00

scroll_speed_layer:
  .byte $03, $03, $03

scroll_position_layer:
  .byte $07, $07, $07

.label sfx1_ptr = $73
.label sfx2_ptr = $75