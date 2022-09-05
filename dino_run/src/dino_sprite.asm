dino_0_4:
	.fill (64 * 4),0

enemy_0_3:
	.fill (64 * 4),0

dino_w_src:
	.byte $00, $03, $F8
	.byte $00, $06, $FC
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $C0
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $20, $7F, $80
	.byte $60, $FF, $E0
	.byte $61, $FF, $A0
	.byte $73, $FF, $80
	.byte $7F, $9F, $00
	.byte $3F, $7F, $00
	.byte $1F, $7E, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $B0, $00
	.byte $01, $18, $00
	.byte $00

	.byte $00, $03, $F8
	.byte $00, $06, $FC
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $80
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $00, $7F, $E0
	.byte $20, $FF, $90
	.byte $61, $FF, $80
	.byte $73, $CF, $80
	.byte $7F, $B7, $00
	.byte $3F, $FF, $00
	.byte $1F, $FE, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $60, $00
	.byte $00, $30, $00
	.byte $00

	.byte $00, $03, $F8
	.byte $00, $07, $7C
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $80
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $20, $7F, $80
	.byte $60, $FF, $E0
	.byte $61, $FF, $A0
	.byte $73, $FF, $80
	.byte $7F, $CF, $00
	.byte $3F, $F7, $00
	.byte $1F, $F6, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $28, $00
	.byte $00, $46, $00
	.byte $00

	.byte $00, $03, $F8
	.byte $00, $07, $7C
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $C0
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $00, $7F, $80
	.byte $20, $FF, $E0
	.byte $61, $FF, $90
	.byte $73, $CF, $80
	.byte $7F, $B7, $00
	.byte $3F, $FF, $00
	.byte $1F, $FE, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $60, $00
	.byte $00, $30, $00
	.byte $00

dino_d_src:
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $7E
	.byte $80, $00, $DF
	.byte $C0, $00, $FF
	.byte $FF, $FF, $FF
	.byte $7F, $9F, $F0
	.byte $3F, $6F, $78
	.byte $1F, $FE, $00
	.byte $0F, $FE, $00
	.byte $01, $FA, $00
	.byte $00, $B2, $00
	.byte $01, $18, $00
	.byte $00

	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $40, $00, $7E
	.byte $C0, $00, $DF
	.byte $C0, $00, $FF
	.byte $FF, $FF, $FF
	.byte $7F, $9F, $F0
	.byte $3F, $7F, $78
	.byte $1F, $FE, $00
	.byte $0F, $FE, $00
	.byte $01, $FB, $00
	.byte $00, $40, $00
	.byte $00, $60, $00
	.byte $00

	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $80, $00, $7E
	.byte $80, $00, $DF
	.byte $C0, $00, $FF
	.byte $FF, $FF, $FF
	.byte $7F, $9F, $F0
	.byte $3F, $6F, $78
	.byte $1F, $FE, $00
	.byte $0F, $FF, $80
	.byte $01, $F8, $00
	.byte $00, $A0, $00
	.byte $01, $18, $00
	.byte $00

	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $40, $00, $7E
	.byte $C0, $00, $DF
	.byte $C0, $00, $FF
	.byte $FF, $FF, $FF
	.byte $7F, $9F, $E0
	.byte $3F, $EF, $78
	.byte $1F, $FE, $00
	.byte $0F, $FE, $00
	.byte $01, $FB, $00
	.byte $00, $60, $00
	.byte $00, $30, $00
	.byte $00


dino_j_src:
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $40, $00, $7E
	.byte $C0, $00, $DF
	.byte $C0, $00, $FF
	.byte $FF, $FF, $FF
	.byte $7F, $9F, $E0
	.byte $3F, $EF, $78
	.byte $1F, $FE, $00
	.byte $0F, $FE, $00
	.byte $01, $FB, $00
	.byte $00, $60, $00
	.byte $00, $30, $00
	.byte $00

	.byte $00, $03, $F8
	.byte $00, $07, $7C
	.byte $00, $0F, $7E
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $E0
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $00, $7F, $90
	.byte $20, $FF, $E0
	.byte $61, $FF, $80
	.byte $73, $CF, $80
	.byte $7F, $B7, $00
	.byte $3F, $FF, $00
	.byte $1F, $FE, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $70, $00
	.byte $00, $D8, $00
	.byte $00

	.byte $00, $03, $F8
	.byte $00, $07, $7C
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $E0
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $00, $7F, $90
	.byte $20, $FF, $E0
	.byte $61, $FF, $80
	.byte $73, $CF, $80
	.byte $7F, $B7, $00
	.byte $3F, $FF, $00
	.byte $1F, $FE, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $28, $00
	.byte $00, $28, $00
	.byte $00

	.byte $00, $03, $F8
	.byte $00, $07, $7C
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $E0
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $00, $7F, $90
	.byte $20, $FF, $E0
	.byte $61, $FF, $80
	.byte $73, $CF, $80
	.byte $7F, $B7, $00
	.byte $3F, $FF, $00
	.byte $1F, $FE, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $28, $00
	.byte $00, $28, $00
	.byte $00

	.byte $00, $03, $F8
	.byte $00, $07, $7C
	.byte $00, $0F, $7E
	.byte $00, $0F, $FE
	.byte $00, $0F, $FE
	.byte $00, $0F, $E0
	.byte $00, $0F, $F0
	.byte $00, $0F, $00
	.byte $00, $1F, $80
	.byte $00, $3F, $80
	.byte $00, $7F, $90
	.byte $20, $FF, $F0
	.byte $61, $FF, $80
	.byte $73, $CF, $80
	.byte $7F, $B7, $00
	.byte $3F, $FF, $00
	.byte $1F, $FE, $00
	.byte $0F, $FC, $00
	.byte $01, $F8, $00
	.byte $00, $28, $00
	.byte $00, $28, $00
	.byte $00