
.macro setup_raster_irq(irq_handler, line){
  sei
  // set the low byte of our interrupt handler routine in $0314, when banking out basic and kernal, the should be $fffe
  lda #<irq_handler
  sta $0314
  // set the high byte of our interrupt handler routine in $0314, when banking out basic and kernal, the should be $ffff
  lda #>irq_handler
  sta $0315

  // switch off interupts from CIAs
  lda #$7f                //this is the magic number, quick and easy compared to doing the bitwise operation
  sta $dc0d

  // clear most significant bit of VIC's raster register
  lda #$7f   // this can be omitted since it is still $7f
  and $D011            
  sta $D011

  // ONLY ENABLE Raster Interrupts, sprite collision interrupts are disabled.
  //Perform a bitwise OR if you want to keep sprite collisions enable
  lda #1
  sta $d01a

  // trigger the raster interrupt on line 00
  lda #line
  sta $d012

  asl $d019                   // most efficient way to accept current interrupt
  cli
  rts
}

BasicUpstart2(main)

main:
  jsr setup
  jmp *         // loop for ever and let the IRQ do the work

setup:
  //set screen to black
  lda #$00
  sta $d020
  sta $d021

  // run macro to setup a raster interrupt on line 128 ($7f)
  //then we wait until $7f is drawn and we do our actual work on ine $80
  setup_raster_irq(irq1, $7f)
  rts

irq1:
  // because get triggered somewhere wilst drawing the raster line, we wait until that line is drawn
  lda $d012 // load the current raster line in a
  cmp $d012 // compare what is in a with what the current raster line is, as long as it's the same jmp back to cmp statement
  beq *-3

  lda #$05
  sta $d020
  sta $d021

  lda $d012 // load the current raster line in a
  cmp $d012 // compare what is in a with what the current raster line is, as long as it's the same jmp back to cmp statement
  beq *-3

  lda #$00
  sta $d020
  sta $d021

  asl $d019 //ack current interrupt so the next one can be triggered

  // the OS has pushed all registers so we need to pop them (when you run without OS you should push and pop them)
  pla                     
  tay
  pla
  tax
  pla
  
  rti