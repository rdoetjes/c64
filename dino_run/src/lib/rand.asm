#importonce

// low byte in a (most random) high byte in y (less random)
rand:
    jsr rand64k       //Factors of 65535: 3 5 17 257
    jsr rand32k       //Factors of 32767: 7 31 151 are independent and can be combined
    lda sr1+1         //can be left out 
    eor sr2+1         //if you dont use
    tay               //y as suggested
    lda sr1           //mix up lowbytes of SR1
    eor sr2           //and SR2 to combine both 
    rts
 
rand64k:
    lda sr1+1
    asl
    asl
    eor sr1+1
    asl
    eor sr1+1
    asl
    asl
    eor sr1+1
    asl
    rol sr1  
    rol sr1+1
    rts
 
 rand32k:
    lda sr2+1
    asl
    eor sr2+1
    asl
    asl
    ror sr2        
    rol sr2+1
    rts
 
//feel free to set seeds as wished, if put in zeropage some speed-boost is 
//the result. For example sr1=$5c sr2=5e would fit
sr1:	.word $a55a
sr2:	.word $7653