		
		BasicUpstart2(main)

main:
    //set sprite pointer index
    //this, multiplied by $40, is the address
    //in this case, the address is $2000
    //$80 * $40 = $2000
    lda #$80
    sta $07f8           //this is screen ram + 1016 default screen ram is at 1024+1016 = 2040
    sta $07f9           //give sprite_1 the same sprite pointer, so we have two balls

    //set color sprite_0 to green sprite_1 to red
    lda #$05
    sta $d027
    lda #$02
    sta $d028

    //set x and y position to $80 sprite_0
    lda #$80
    sta $d000
    sta $d001

    //set x and y position to $80 sprite_0
    lda #$60
    sta $d002
    sta $d003

    //enable sprite_0 and sprite_1 (this is a bit mask each bit corresponds to of of the 8 sprites)
    lda #$03
    sta $d015

loop:
move_sprite_0:
    clc            // clear carry because we will be using adc and want to see carry change
    lda $d000      // load the current sprite_0 x position
    adc #$01       // by using adc we actually can check the carry flag
    sta $d000      // store the position to the sprite_0 x pos
    bcs toggle_x_high_bit_sprite_0    // when carry is set we wet over x position 255 so we need to toggle the high bit
    jmp move_sprite_1   // is carry not is set we don't need to toggel high bit 
    
toggle_x_high_bit_sprite_0:    
    lda $d010       // load the high byte of sprite location
    eor #%00000001  // toggle bit 1, so we are going over 255
    sta $d010       // store it back

move_sprite_1:
    sec             // set the carry since we are going to the sbc, and we want to see it reset when we go "lower than 0"
    lda $d003       // load current y_pos sprite 1
    sbc #$02        // subtract 2 positions (makes it faster than sprite_0)
    sta $d003       // store the position to the sprite_1 y pos
    bcc toggle_x_high_bit_sprite_1  // when carry is cleared we crossed the y_pos 0, which is not required as 255 is invisible area
    jmp wait_line

// you don't need this for y tough, because when you wrap from 0 to 255 you'll still be in an invisible area
toggle_x_high_bit_sprite_1:    
    lda $d010       // load the high byte of sprite location
    eor #%00000010  // toggle bit 1, so we are going over 255
    sta $d010       // store back the updated high bit

wait_line: 
    // poll for sprite collision
    lda $d01e
    bne increase_sprite_colors

    //quick and dirty for demo
    //let's wait for screen line in the polling way (check lesson 10 for line interrupts)
    lda #255
    cmp $d012
    bne *-3
    jmp loop

increase_sprite_colors:
    inc $d027       // increment color sprite_0
    inc $d028       // increment color sprite_1

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

