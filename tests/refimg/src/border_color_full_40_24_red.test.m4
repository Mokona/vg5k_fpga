include(`common.m4')
	org	0

	ld      hl, 8000h
        ld      sp, hl

NOP

IND(`R_IND_TGS', `00h')
IND(`R_IND_MAT', `01h')
IND(`R_IND_PAT', `00h')
IND(`R_IND_ROR', `00h')

halt:
	halt
	jp	halt

include 'common.s'
