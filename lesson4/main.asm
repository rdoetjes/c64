.const SCREEN = $0400

* = $01000

BasicUpstart2(main)

main:

  lda #242
  jsr printHex
  lda hex_result
  sta SCREEN
  lda hex_result + 1
  sta SCREEN + 1
  stx SCREEN + 2
rts

printHex:
  jmp !+          //jump over the data in this sub routine
  // array fro translating values 0-15 to the right hexadecimal character
  hex:           .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' 
  // the calculated result is stored (self modifying code, so we can easily use it where and how we want)
  hex_result:    .byte '0', '0'
!:
  //we need to save the a (that holds the value to print) as we need to txa to save x
  //so let's store it in the result, saves a byte and doesn't require complex stack handling
  sta hex_result

  //safe the x variabel on the stack, because we will be changing it's contents
  txa        
  pha

  //get the A value again, that is the number to print in hex
  lda hex_result
  // we need to save a copy of a on the stack, because we will and it and globber it
  pha
  //And let's set it back to 0 char (we are decent people)
  ldx #'0'
  stx hex_result

  // and the lower nibble
  and #15
  //set the result from the and in x
  tax
  //lookup in the hex array the right hex character for index in x register
  lda hex, x
  //store that in the result + 1 position (lowest of the two hex nibble)
  sta hex_result + 1

  // pop the a so we have the actual number again in a
  pla
  // and the high nibble
  and #240
  //shift that result 4 times to the right, into the lower nibble
  lsr
  lsr
  lsr
  lsr

  // transfer that nibble from a into x
  tax
  // get the correct hex chracter for index x
  lda hex, x
  //store that hex character into hex_result (the highest nibble)
  sta hex_result 

  // restore x
  pla
  tax

  rts