
// 10 PRINT CHR$ (205.5 + RND (1)); : GOTO 10
// in assmembly
// SCROLL SCREEN UP WITH UNROLLED COPY CODE

.const SID_VOICE3_LB = $d40e    //voice 3 lowbyte for requence
.const SID_VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
.const SID_WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
.const SID_OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
.const BOTTOM_LINE = $07c0      //memory position for bottom line's first character 
.const SCREEN = $0400           //screen base address

BasicUpstart2(main)

main:
  jsr setupSid4Noise            //setup the voice 3 for noise generation 
loop:
  jsr printMazeLine            // print a line of the maze on the bottom line of the screen
  jsr shiftUp                  // shit the whole screen up one row
  jmp loop                     // loop forever
  rts

//return / if value in a is even and return \ if value in a is odd
getMazeChar:   
  lda SID_OSC3_RO               //load random voice amplitude value into a                 
  and #$1                       // and a with 1, this will return either 0 or 1 depending whether value in a is even or odd
  beq !+                        //if a and 1 == 0 then a = /
  lda #206                      //else a = \
  jmp !++
!:
  lda #205
!:
  rts            

// prints a whole line of the maze on the bottom line on the screen
printMazeLine:
  ldx #$00                  // set the x to 0 
 newChar:
  jsr getMazeChar           // generate a random / or \
  sta BOTTOM_LINE, x        // print the random \ or / on the bottom line on x position x
  inx                       // inc x
  cpx #41                   // is != 41 the getch newChar. As the line is not completely filled yet
  bne newChar
  rts

shiftUp:
  ldx #$00                  // set the character counter (X), for the line to 0
!:

  //unrolled copy of the 25 lines, is this the fastest way? At least faster than indirect addressing
.for(var line=1; line<25; line++){
  lda $0400 + (line * 40), x            //load the character from the source line in A
  sta $0400 + (line * 40) - 40 , x      //store the character on the same x position in previous line (destination line); effectively moving up
}
  inx                       // increment the character counter
  cpx #$28                  // did we copy the 40 chars? Then movie to the next return from subroutine else keep copying
  beq !+                    // keep copying till all 40 chars of all the lines are copied to the line above
  jmp !-                    // we copied all 40 chars for all 24 lines to the line above and thus we can return from subroutine
!:
  rts                       // return from subroutine

//voice 3 is the only voice with noise generator and we enabled it with highest frequency
//in order to get fastest random numbers
setupSid4Noise:                 
  lda #$ff                      // load a with 255, which is highest frequence when put in, voice lb and voice hb       
  sta SID_VOICE3_LB             // set frequence in frequency low byte to 255 (highest frequence)
  sta SID_VOICE3_LB+1           // set frequence in frequency low byte to 255 (highest frequence)
  lda #SID_WAV_NOISE            // load a wuth $80 (128) which is noise wave when store in SID_VOICE3_CTRL
  sta SID_VOICE3_CTRL           // set voice 3 control register to play a noise wave
  rts