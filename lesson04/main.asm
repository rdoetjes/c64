
// 10 PRINT CHR$ (205.5 + RND (1)); : GOTO 10
// in assmebly

.const SID_VOICE3_LB = $d40e    //voice 3 lowbyte for requence
.const SID_VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
.const SID_WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
.const SID_OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
.const KERNAL_CHROUT = $ffd2    //print chrout kernal call

BasicUpstart2(main)

main:
  jsr setupSid4Noise            //setup the voice 3 for noise generation 
loop:
  lda SID_OSC3_RO               //load random voice amplitude value into a
  jsr getMazeChar               // depending if random value is odd or even we return in a / or \
  jsr KERNAL_CHROUT             // print char in a to the screen
  jmp loop                      // loop forever

//return / if value in a is even and return \ if value in a is odd
getMazeChar:                    
  and #$1                       // and a with 1, this will return either 0 or 1 depending whether value in a is even or odd
  beq !+                        //if a and 1 == 0 then a = /
  lda #109                      //else a = \
  jmp !++
!:
  lda #110
!:
  rts       

//voice 3 is the only voice with noise generator and we enabled it with highest frequency
//in order to get fastest random numbers
setupSid4Noise:                 
  lda #$ff                      // load a with 255, which is highest frequence when put in, voice lb and voice hb       
  sta SID_VOICE3_LB             // set frequence in frequency low byte to 255 (highest frequence)
  sta SID_VOICE3_LB+1           // set frequence in frequency low byte to 255 (highest frequence)
  lda #SID_WAV_NOISE            // load a wuth $80 (128) which is noise wave when store in SID_VOICE3_CTRL
  sta SID_VOICE3_CTRL           // set voice 3 control register to play a noise wave
  rts