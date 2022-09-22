VIC:{
   .label SCREEN = $0400
   
   .label MEMORY_SETUP = $D018

   .label COLOR_RAM = $d800

   .label BORDER_COLOR = $d020
   .label SCREEN_COLOR = $d021

   .label RASTER_LINE = $d012

   .label YSCROLL = $d017
   .label XSCROLL = $d016
}

SID:{
   .label VOICE3_LSB_FREQ = $d40e
   .label VOICE3_MSB_FREQ = $d40f
   .label VOICE3_CONTROL_REG = $d412
   .label VOICE3_VALUE = $d41b
}