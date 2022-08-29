.const SID_VOICE3_LB = $d40e
.const SID_VOICE3_CTRL = $d412
.const SID_WAV_NOISE = $80
.const SID_OSC_3_RO = $d41b
.const KERNAL_CHROUT = $FFD2 
* = $1000

BasicUpstart2(main)

main:
  ldx #$00
  stx $fb
  jsr setupSid4Noise

loop:
  lda SID_OSC_3_RO  // get random value from noise in A
  jsr getMazeChar   // get randomly either a / or \
  jsr KERNAL_CHROUT // use kernal print char to screen (not the fastest way!, but that's not the point of this lesson ;) )
  jmp loop          // loop forever

setupSid4Noise:
  lda #$ff            // highest frequency in low byte and high byte (gives random values faster)
  sta SID_VOICE3_LB   // voice 3 frequency low byte
  sta SID_VOICE3_LB+1 // voice 3 frequency high byte
  lda #SID_WAV_NOISE   // waveform is set to noise
  sta SID_VOICE3_CTRL // set the wave form to 80 (noise)
  rts

getMazeChar:
  //and the random number with 1 if it's 0 then set a to / else \
  and #$01
  beq !+   //if a and 1 == 0 set a to /
  lda #110 //else set a to \
  jmp !++
!:
  lda #109 // set to /
!: 
  rts