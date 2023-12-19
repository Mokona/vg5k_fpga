include(`common.m4')
	org	0

	ld      hl, 8000h
        ld      sp, hl

NOP

IND(`R_IND_TGS', `00h')
IND(`R_IND_MAT', `0Eh')
IND(`R_IND_PAT', `37h')
IND(`R_IND_ROR', `08h')
IND(`R_IND_DOR', `20h')

WRITE(`R_Y', `20h')
WRITE(`R_X', `0')

	ld	hl, grid
	ld	b, (hl)
	inc	hl
	ld	c, IO_DATA
WRITE(`0', `CMD_OCT | 1')
	ld	a, 20h | XQR | 1
	out	(IO_ADDR), a
loop:	outi
	jr	nz, loop

WRITE(`R_Y', `0')
WRITE(`R_X', `0')
	ld	b, 1
	call	line

WRITE(`R_Y', `8')
WRITE(`R_X', `0')
	ld	b, 25
bulk:
	call	line
INY
	dec	b
	jr	nz, bulk

halt:
	halt
	jp	halt

line:
KRFI(`0', `0a0h', `07h')
	ld 	a, 20h
	out	(IO_ADDR), a
	in	a, (IO_DATA)
	and	20h
	jr	z, line
	ret

include 'common.s'

grid:
	db	grid_end - grid
	db	0xaa, 0x00, 0x00, 0x00
	db	0x55, 0x00, 0x00, 0x00
	db	0xaa, 0x00, 0x00, 0x00
	db	0x55, 0x00, 0x00, 0x00
	db	0xaa, 0x00, 0x00, 0x00
	db	0x55, 0x00, 0x00, 0x00
	db	0xaa, 0x00, 0x00, 0x00
	db	0x55, 0x00, 0x00, 0x00
	db	0xaa, 0x00, 0x00, 0x00
	db	0x55, 0x00, 0x00, 0x00
grid_end:
