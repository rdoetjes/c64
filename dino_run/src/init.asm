#importonce

#import "macros.asm"
#import "lib/screen.asm"
#import "lib/memorymap.asm"
#import "lib/system.asm"

screenColor:
  lda #00
  sta $d020
  sta $d021
  rts


setupSid4Noise:                 
  lda #$ff                      // load a with 255, which is highest frequence when put in, voice lb and voice hb       
  sta SID.VOICE3_FREQ_LB             // set frequence in frequency low byte to 255 (highest frequence)
  sta SID.VOICE3_FREQ_HB             // set frequence in frequency low byte to 255 (highest frequence)
  lda #SID.WAV_NOISE            // load a wuth $80 (128) which is noise wave when store in SID_VOICE3_CTRL
  sta SID.VOICE3_CTRL           // set voice 3 control register to play a noise wave
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
  jsr backoutKernalAndBasic

  lda #$00
  jsr screenColor

  jsr cls
  jsr setupSid4Noise
  jsr setupCharset
  jsr dinoSprite
  jsr cactusSprite
  jsr createLandscape

  // setup gameIrq which is basically the game loop trigger raster interrupt on line ff
  ldx #$0a
  lda #<gameIrq               
  sta $fffe
  lda #>gameIrq
  sta $ffff
  jsr setupRasterInt

  cli
  rts