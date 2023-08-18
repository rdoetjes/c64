		
		BasicUpstart2(main)

main:
    //set sprite pointer index
   	//this, multiplied by $40, is the address
  	//in this case, the address is $2000
    //$80 * $40 = $2000
    lda #$80
    sta $07f8						//this is screen ram + 1016 default screen ram is at 1024+1016 = 2040

    //set x and y position to $80
    lda #$80
    sta $d000
    sta $d001

    //enable sprite 0
    lda #$01
    sta $d015

loop:    
    inc $d000   				// move sprite to the left by incrementging x pos

wait_line:
    //quick and dirty for demo
    //let's wait for screen line in the polling way (check lesson 10 for line interrupts)
    lda #255
    cmp $d012
    bne *-3

    jmp loop

	* = $02000
sprite1:
	//Single color mode, BG color: 0, Sprite color: 1
	.byte   0,   0,   0
	.byte   0, 126,   0
	.byte   1, 255, 128
	.byte   3, 255, 192
	.byte   7, 249, 224
	.byte   7, 252, 224
	.byte  15, 254, 240
	.byte  15, 254, 240
	.byte  31, 255, 248
	.byte  31, 255, 248
	.byte  31, 255, 248
	.byte  31, 255, 248
	.byte  31, 255, 248
	.byte  15, 255, 240
	.byte  15, 255, 240
	.byte   7, 255, 224
	.byte   7, 255, 224
	.byte   3, 255, 192
	.byte   1, 255, 128
	.byte   0, 126,   0
	.byte   0,   0,   0

