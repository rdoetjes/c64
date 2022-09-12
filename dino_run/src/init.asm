#importonce

#import "macros.asm"

cls:
  ldx #250
  lda #32
!:
  sta SCREEN, x
  sta SCREEN + 250, x
  sta SCREEN + 500, x
  sta SCREEN + 750, x
  dex
  bne !-
  rts

screenColor:
  lda #00
  sta $d020
  sta $d021
  rts

// initialize the game and setup a raster interrupt that counts the frame_counter variable, which we will poll in game loop
setupRasterInt:
  lda #$7f
  sta $dc0d                   //acknowledge pending interrupts from CIA-1
  sta $dd0e                   //acknowledge pending interrupts from CIA-2

  lda #<gameIrq               // setup gameIrq which is basically the game loop
  sta $fffe
  lda #>gameIrq
  sta $ffff

  lda #1
  sta $d01a                   // enable raster interrupts

	lda $d011
  and #$7f
  sta $d011                   // clear most significant bit of vicii
  
  lda #$b0
  sta $d012                   //trigger raster interrupt on 00

  asl $d019                   // accept current interrupt
  rts

setupSid4Noise:                 
  lda #$ff                      // load a with 255, which is highest frequence when put in, voice lb and voice hb       
  sta SID_VOICE3_LB             // set frequence in frequency low byte to 255 (highest frequence)
  sta SID_VOICE3_LB+1           // set frequence in frequency low byte to 255 (highest frequence)
  lda #SID_WAV_NOISE            // load a wuth $80 (128) which is noise wave when store in SID_VOICE3_CTRL
  sta SID_VOICE3_CTRL           // set voice 3 control register to play a noise wave
  rts

setupCharset:
  lda $d018
  // Table of lower nibble and the corresponding character ram address  
  // $D018 = %xxxx000x -> charmem is at $0000
  // $D018 = %xxxx001x -> charmem is at $0800
  // $D018 = %xxxx010x -> charmem is at $1000
  // $D018 = %xxxx011x -> charmem is at $1800
  // $D018 = %xxxx100x -> charmem is at $2000
  // $D018 = %xxxx101x -> charmem is at $2800
  // $D018 = %xxxx110x -> charmem is at $3000
  // $D018 = %xxxx111x -> charmem is at $3800
  and #240              // keep the upper 4 bits, so that screen RAM points to 0400
  ora #12               // set to $1800
  sta $d018             // sta the configuration of screen ram and character ram offsets to VIC
  rts

// sets up the screen, interrupts and the sprites
setup:
  sei                         // disable interrupts
  
  lda #$35                    // disabel kernal and basic
	sta $01
  jsr setupRasterInt


  lda #$00
  jsr screenColor

  jsr cls
  jsr setupSid4Noise
  jsr setupCharset
  jsr dinoSprite
  jsr cactusSprite
  copy4Sprites(dino_w_src, dino_0_4)  //initialize dino walk sprites (0-3)
  jsr createLandscape

  cli                           // enable interrupts

  rts