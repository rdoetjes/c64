#importonce
#import "lib/memorymap.asm"

cactusSprite:
  lda #$81
  sta VIC.SCREEN + $03f9   //load sprite offset
  lda $d015
  ora #2  
  sta $d015   // enable sprite 2

  lda #$9e
  sta $d002
  lda #$e0
  sta $d003   //set initial sprite position

  lda #$05     
  sta $d028   //set sprite color to green
  rts
