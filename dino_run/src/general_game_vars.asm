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


.label SCREEN = $0400
.label SID_VOICE3_LB = $d40e    //voice 3 lowbyte for requence
.label SID_VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
.label SID_WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
.label SID_OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
.label sfx1_ptr = $73
.label sfx2_ptr = $75