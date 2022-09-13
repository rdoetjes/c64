#import "memorymap.asm"

#importonce


backoutKernalAndBasic:
    sei
    lda #$7f
    sta CIA.ICR1                //acknowledge pending interrupts from CIA-1
    sta CIA.ICR2                //acknowledge pending interrupts from CIA-2

    lda #$35                    // disable kernal and basic
    sta $01
    cli
    rts