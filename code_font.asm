; 10 SYS2061
*=$0801
	.byte $0B, $08, $0A, $00, $9E, $32, $30, $36, $31, $00, $00, $00

*=$080d
	; set to 25 line text mode and turn on the screen
	lda #$1B
	sta $d011

	; disable SHIFT-Commodore
	lda #$80
	sta $0291

	; set screen memory ($0400) and charset bitmap offset ($2000)
	lda #$18
	sta $d018

	; set border color
	lda #$06
	sta $d020

	; set background color
	lda #$06
	sta $d021

	; set text color
	lda #$0E
	sta $0286
	rts

