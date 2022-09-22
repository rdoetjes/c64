.macro setup_raster_irq(irq_handler, line){
  sei                           //disable interrupts during setup

  lda #<irq_handler             //load low byte of interrupt handler routine
  sta $0314                     //store low byte in $0314 the address where raster interrupt vector is stored, $fffe when you bank out kernal and basic
  lda #>irq_handler             //load high byte of interrupt handler routine
  sta $0315                     //store low byte in $0315 the address where raster interrupt vector is stored, $ffff when you bank out kernal and basic

  //disable CIA interrupts
  lda #$7f
  sta $dc0d

  // ack CIA interrupts
  lda $dc0d
  lda $dd0d

  // enable only the raster interrupt (disable sprite collisions, if you want to keep sprite collisions user an OR with value #1)
  lda #$7f
  and $d011
  sta $d011

  // enable raster interrupts
  lda #$01
  sta $d01a

  // the line where you want the interrupt to happen
  lda #line
  sta $d012

  cli
}

//load the sid tune into a KickAssembler variable (used for easy playback)
 .var music = LoadSid("80s_Ad.sid")

BasicUpstart2(main)

main:
  // call the init routine
  jsr music.init

  lda #$00
  sta $d020
  sta $d021

  setup_raster_irq(myirq, $7f)
  jmp *

myirq:
  // increment the chracter in the upper left corner to demonstrate we get raster interrupts
  inc $0400

  // wait for the raster line to be drawn, in case it was already partially drawn -- that's why we trigger one line before
  lda $d012
  cmp $d012
  beq *-3

  //set the background and border to green
  lda #$05
  sta $d020
  sta $d021

  // wait until the line is drawn (effectively drawing a simple green line)
  lda $d012
  cmp $d012
  beq *-3

  // set everything below the raster line to black, so we just have a single line
  lda #$00
  sta $d020
  sta $d021

  // demon stration that we can manipulate where we want the interrupt to happen which causes the line to move
  dec $d012

  // play the music routine.
  jsr music.play 

  // ackknowledge the raster interrupt
  asl $d019

  // pop the data off the stack that was put their automatically by kernel
  // when you disable kernel you will need to push everything on the stack first yourself!!!
  pla
  tya
  pla
  txa
  pla

  rti

// load the SID tune in the required location
*=music.location "Music"
.fill music.size, music.getData(i)