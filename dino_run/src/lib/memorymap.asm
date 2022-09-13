#importonce

VIC: {
    .label SCREEN = $0400
    .label ICR = $d01a
    .label SCREEN_CR = $d011
    .label RASTER_LINE = $d012
    .label ISR = $d019
    .label COLOR_RAM = $d800

    .label SPRITE_ENABLE = $d015

    .label SPRITE_0_PTR = SCREEN + $03f8
    .label SPRITE_0_X = $d000
    .label SPRITE_0_Y = $d001
    .label SPRITE_0_COLOR = $d027
}

SID: {
    .label VOLUME_FILTER = $d418 
    .label WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
    .label WAV_SAW = $20

    .label VOICE2_FREQ_LB = $d400
    .label VOICE2_FREQ_HB = $d401
    .label VOICE1_SUSTAIN_RELEASE = $d406
    .label VOICE1_CTRL = $d404

    .label VOICE3_FREQ_LB = $d40e    //voice 3 lowbyte for frequency
    .label VOICE3_FREQ_HB = $d40f    //voice 4 highbyte for freuency
    .label VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
    .label OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
}

CIA: {
    .label ICR1 = $dc0d
    .label ICR2 = $dd0e  
}