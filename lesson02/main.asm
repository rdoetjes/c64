.const BRCOLOR = $d020
.const BGCOLOR = $d021

BasicUpstart2(main)

main:

//BASIC
//10 poke 53280,peek(53280)-1
//20 poke 53281,peek(53281)-1
//30 goto 10

  dec BGCOLOR
  dec BRCOLOR
  jmp main
  rts