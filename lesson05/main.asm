.const SCREEN = $0400

BasicUpstart2(main)

main:
  lda #16                     //number to turn into hex
  jsr convertToHex            //call the hex conversion (result will be in convertToHex_result)
  lda convertToHex_result      //get first hex character
  sta SCREEN                  //print that hex character on position 0
  lda convertToHex_result + 1  //get the second hex character
  sta SCREEN + 1              //print that hex character on position 1
rts

convertToHex:
  jmp !+                    //jump over the data in this sub routine
  // array fro translating values 0-15 to the right hexadecimal character
  convertToHex_hextable:  .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' 
  // the calculated result is stored (self modifying code, so we can easily use it where and how we want)
  convertToHex_result:    .byte '0', '0'
!:
  sta $fb                   //we need to save the a as we need to txa to save x, so we use zero page for a second
  txa                       //safe the x register on the stack, because we will be changing it's contents 
  pha
  lda $fb                   //get the A value from zero page again

  and #15                   // and the lower nibble, so we know what the lower past of the hex value is
  tax                       //set the result from the and in x
  lda convertToHex_hextable, x  //lookup in the convertToHex_hextable array the right convertToHex_hextable character for index in x register
  sta convertToHex_result + 1   //store that in the result + 1 position (lowest of the two convertToHex_hextable nibble)

  lda $fb                   // restor the a so we have the actual number again in a
  and #240                  // and the high nibble
  
  lsr                       //shift that result 4 times to the right, into the lower nibble
  lsr
  lsr
  lsr

  tax                       // transfer that nibble from a into x
  lda convertToHex_hextable, x  // get the correct convertToHex_hextable chracter for index x
  sta convertToHex_result    //store that convertToHex_hextable character into convertToHex_result (the highest nibble)

  pla                       // restore x
  tax

  rts 