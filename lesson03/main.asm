.const SCREEN = $0400

.macro push_all(){
  //save regs 
  pha   //save a
  tya //save y
  pha
  txa //save x
  pha
}

.macro pop_all(){
  //restore
  pla   //restore x
  tax
  pla   //restore y
  tay
  pla   //restore a
}

* = $01000

BasicUpstart2(main)

main:
  lda #1      
  ldx #2
  ldy #3
  jsr cls         //jump to subroutine cls
  sta SCREEN
  stx SCREEN + 1
  sty SCREEN + 2
  rts             //return to basic

cls:
  push_all()

  //A accumulator, X and Y index registers
  lda #32         //load a with value 32 (space)
  ldx #0          //load x with value 0 (is our counter)
  ldy #66         //for demonstartion purposes set y to 66

cls_loop:         //fill screen memory with 1000 spaces
  //screen size is 40x25 = 1000
  sta SCREEN, X           //store value in a to screen  x
  sta SCREEN + $0100, X   //store value in a to screen + $100 x
  sta SCREEN + $0200, X   //store value in a to screen + $200 x
  sta SCREEN + $02e8, X   //store value in a to screen + $300 x
  dex                     //subtract one from x
  bne cls_loop            // jump to cls_loop when x is not 0

  pop_all()

  rts     //return from subroutine (back to basic)
