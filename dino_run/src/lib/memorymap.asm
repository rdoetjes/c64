#importonce

VIC: {
    .label SCREEN = $0400
    .label ICR = $d01a
    .label SCREEN_CR = $d011
    .label RASTER_LINE = $d012
    .label ISR = $d019
}

SID: {
    .label VOICE3_LB = $d40e    //voice 3 lowbyte for frequency
    .label VOICE3_HB = $d40f    //voice 4 highbyte for freuency
    .label VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
    .label WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
    .label OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
}

CIA: {
    .label ICR1 = $dc0d
    .label ICR2 = $dd0e  
}