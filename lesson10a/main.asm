.macro setup_raster_irq(irq_handler, line){
  sei

  lda #<irq_handler
  sta $0314     //$fffe
  lda #>irq_handler
  sta $0315     //$ffff

  lda #$7f
  sta $dc0d

  // ack cia interrupts
  lda $dc0d
  lda $dd0d

  lda #$7f
  and $d011
  sta $d011

  lda #$01
  sta $d01a

  lda #line
  sta $d012

  cli
}

 .var music = LoadSid("80s_Ad.sid")

BasicUpstart2(main)

main:
  lda #music.startSong-1
  jsr music.init

  lda #$00
  sta $d020
  sta $d021

  setup_raster_irq(myirq, $7f)
  jmp *

myirq:
  inc $0400

  lda $d012
  cmp $d012
  beq *-3

  lda #$05
  sta $d020
  sta $d021

  lda $d012
  cmp $d012
  beq *-3

  lda #$00
  sta $d020
  sta $d021

  dec $d012
  jsr music.play 

  asl $d019

  pla
  tya
  pla
  txa
  pla

  rti

*=music.location "Music"
.fill music.size, music.getData(i)