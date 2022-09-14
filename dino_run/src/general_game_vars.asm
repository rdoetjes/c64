#importonce

.label gameOverCountDown = $32

//flag to allow to exit the game
quit_game:
  .byte $00

// score in BCD
score:
  .byte $00, $00, $00

// frame counter
frame_counter:
  .byte $00

scroll_speed_layer:
  .byte $03, $03, $02

scroll_position_layer:
  .byte $07, $07, $07

gameOverFrameCountDown:
  .byte gameOverCountDown

gameOverString: 
  .text "game over"
  .byte $00

presStartString: 
  .text "button to start"
  .byte $00