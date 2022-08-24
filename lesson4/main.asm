.const SCREEN = $0400

* = $01000

BasicUpstart2(main)

main:
  lda #242                    //number to turn into hex
  jsr printHex                //call the hex conversion (result will be in printHex_result)
  lda printHex_result         //get first hex character
  sta SCREEN                  //print that hex character on position 0
  lda printHex_result + 1     //get the second hex character
  sta SCREEN + 1              //print that hex character on position 1
rts

printHex:
  jmp !+          //jump over the data in this sub routine
  // array fro translating values 0-15 to the right hexadecimal character
  printHex_hextable:           .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' 
  // the calculated result is stored (self modifying code, so we can easily use it where and how we want)
  printHex_result:    .byte '0', '0'
!:
  //we need to save the a (that holds the value to print) as we need to txa to save x
  //so let's store it in the result, saves a byte and doesn't require complex stack handling
  sta printHex_result

  //safe the x register on the stack, because we will be changing it's contents
  txa        
  pha

  //get the A value again, that is the number to print in printHex_hextable
  lda printHex_result
  // we need to save a copy of a on the stack, because we will and it and globber it
  pha
  //And let's set it back to 0 char (we are decent and careful people, especially when it comes to self modifying code)
  ldx #'0'
  stx printHex_result

  // and the lower nibble
  and #15
  //set the result from the and in x
  tax
  //lookup in the printHex_hextable array the right printHex_hextable character for index in x register
  lda printHex_hextable, x
  //store that in the result + 1 position (lowest of the two printHex_hextable nibble)
  sta printHex_result + 1

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
  // get the correct printHex_hextable chracter for index x
  lda printHex_hextable, x
  //store that printHex_hextable character into printHex_result (the highest nibble)
  sta printHex_result 

  // restore x
  pla
  tax

  rts