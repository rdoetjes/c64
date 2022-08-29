
// 10 PRINT CHR$ (205.5 + RND (1)); : GOTO 10
// in assmembly
// SCROLL SCREEN UP USING INDEXED ADRESSING

.const SID_VOICE3_LB = $d40e    //voice 3 lowbyte for requence
.const SID_VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
.const SID_WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
.const SID_OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
.const BOTTOM_LINE = $07c0      //memory position for bottom line's first character 
.const SCREEN = $0400           //screen base address
.const SCREEN_LINE2 = $0428     //memory position for the second line's first character (we start copying from 2nd line upwards in order to scroll the screen up)

BasicUpstart2(main)

main:
  ldx #$00
  stx $ff
  jsr setupSid4Noise            //setup the voice 3 for noise generation 
loop:
  jsr printMazeLine             // generate a line of the maze on the bottom line
  jsr shiftUp                   // shift up the whole screen using indrect adressing
  jmp loop                      // loop forever
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

//moves the scontents on the screen up one whole line
shiftUp:
  lda #<SCREEN              // load low byte ($00) of SCREEN in to a 
  sta $fb                   // store low byte in $fb for usage of indirect adressing that requires pointer in zero page
  lda #>SCREEN              // load high byte ($04) of SCREEN in to a 
  sta $fc                   // store high byte in $fc for usage of indirect adressing that requires pointer in zero page

  lda #<SCREEN_LINE2        // load low byte ($28) of SCREEN in to a 
  sta $fd                   // store low byte in $fd for usage of indirect adressing that requires pointer in zero page
  lda #>SCREEN_LINE2        // load high byte ($04) of SCREEN in to a 
  sta $fe                   // store high byte in $fe for usage of indirect adressing that requires pointer in zero page
  
  ldx #24                   //number of lines to move up (moving up means copying from the line below to the line above)
!:
  ldy #$00                  //characters per line. The Y is the index register that is MANDATORY for indirect adressing
!:
  lda ($fd), y              // load the character of the next line ($fd),y point to the source memory address of screen mem
  sta ($fb), y              // store the character to the previous line ($fb),y point to the destination memory address of screen mem
  iny                       // increment the y, so we can copy the next character on the line to the line above
  cpy #$28                  // did we copt $28 (40) chars? no then continue yes then add 40 to the source and dest screen memory
  bne !-

  clc                       // clear the carry (we are going to add with carry so it needs to be cleared)
  lda $fb                   // load the low byte from $fb (dest)
  adc #40                   // add 40 to it, to "move to the next line" (basically doing line * 40)
  sta $fb                   // store back the new low byte offset
  lda $fc                   // load the high byte offset
  adc #0                    // if the low byte overran (large than 255) then carry is set to 1 and the carry will be added to A
  sta $fc                   // store the potentially incremented high byte to fc

  clc                       // clear the carry (we are going to add with carry so it needs to be cleared)
  lda $fd                   // load the low byte from $fb (dest)
  adc #40                   // add 40 to it, to "move to the next line" (basically doing line * 40)
  sta $fd                   // store back the new low byte offset
  lda $fe                   // load the high byte offset
  adc #0                    // if the low byte overran (large than 255) then carry is set to 1 and the carry will be added to A
  sta $fe                   // store the potentially incremented high byte to fc
  dex                       // decrement the row counter (x)
  cpx #00                   // if row count (x) is 00 then we are done moving the screen up
  bne !--                   // cpx not 0? Then continue copying the screen upwards
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