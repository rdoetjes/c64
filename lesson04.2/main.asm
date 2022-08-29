
// 10 PRINT CHR$ (205.5 + RND (1)); : GOTO 10
// in assmebly

.const SID_VOICE3_LB = $d40e    //voice 3 lowbyte for requence
.const SID_VOICE3_CTRL = $d412  //voice 3 control register (to select wave type)
.const SID_WAV_NOISE = $80      //128 dec, when put in voice3 control register it will select noise wave type
.const SID_OSC3_RO = $d41b      //this will contain the amplitude value of the noise at moment of reading (because wave is noise it's random)
.const KERNAL_CHROUT = $ffd2    //print chrout kernal call
.const BOTTOM_LINE = $07c0
.const SCREEN = $0400
.const SCREEN_LINE2 = $0428

BasicUpstart2(main)

main:
  ldx #$00
  stx $ff
  jsr setupSid4Noise            //setup the voice 3 for noise generation 
loop:
  jsr printMazeLine
  jsr shiftUp
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

printMazeLine:
  ldx $ff

 newChar:
  jsr getMazeChar
  sta BOTTOM_LINE, x
  inx 
  cpx #41
  bne newChar

  ldx #$00
  stx $ff
  rts

shiftUp:
  lda #<SCREEN
  sta $fb
  lda #>SCREEN
  sta $fc

  lda #<SCREEN_LINE2
  sta $fd
  lda #>SCREEN_LINE2
  sta $fe
  
  ldx #24   //nuber of lines to move up
!:
  ldy #$00  //characters per line. This is the index register
!:
  lda ($fd), y
  sta ($fb), y
  iny
  cpy #$28
  bne !-

  clc
  lda $fb
  adc #40
  sta $fb
  lda $fc
  adc #0
  sta $fc

  clc
  lda $fd
  adc #40
  sta $fd
  lda $fe
  adc #0
  sta $fe
  dex
  cpx #00
  bne !--
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