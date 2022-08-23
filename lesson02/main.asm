.const BRCOLOR = $d020
.const BGCOLOR = $d021

BasicUpstart2(main)

main:
  inc BGCOLOR
  inc BRCOLOR
  jmp main
  rts