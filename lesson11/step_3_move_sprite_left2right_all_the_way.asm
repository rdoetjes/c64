		
		BasicUpstart2(main)

main:
    //set sprite pointer index
   	//this, multiplied by $40, is the address
  	//in this case, the address is $2000
    //$80 * $40 = $2000
    lda #$80
    sta $07f8           //this is screen ram + 1016 default screen ram is at 1024+1016 = 2040

    //enable sprite 0 (this is a bit mask each bit corresponds to of of the 8 sprites)
    lda #$01
    sta $d015

    //set x and y position to $80
    lda #$80
    sta $d000       // pos_x sprite_0
    sta $d001       // pos_y sprite_0

loop:
    clc             // clear the carry, since we will use adc and we want to see when we went over 255, so we can toggle high bit
    lda $d000       // load x_pos sprite_0
    adc #$01        // add to x_pos and this will affect the carry, which we are interested in
    bcs toggle_x_high_bit_sprite_1  // carry is set so we need to toggle the sprite position's high bit
    jmp wait_line   // just wait for the next frame with sprite updates
    
toggle_x_high_bit_sprite_1:    
    inc $d027       // increment sprite_0's color for demonstration purpose
    lda $d010       // load the high byte of sprite location
    eor #%00000001  // toggle bit 1, so we are going over 255
    sta $d010       // store it back

wait_line:        
    sta $d000       // store the position to the sprite_0 x pos

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

