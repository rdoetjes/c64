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
  lda #255
  jsr printHex
  lda hex_result
  sta SCREEN
  lda hex_result + 1
  sta SCREEN + 1
rts

printHex:
  jmp !+
  hex:           .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' 
  hex_result:    .byte '0', '0'
!:
  sta hex_result  //temporary so we don't need to hassle with the stack
  txa 
  pha
  lda hex_result
  pha

  and #15
  tax
  lda hex, x
  sta hex_result + 1

  pla
  and #240
  lsr
  lsr
  lsr
  lsr

  tax
  lda hex, x
  sta hex_result 
  pla
  tax

  rts