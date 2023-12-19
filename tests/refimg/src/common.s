wait_ready:
	ld	a, 20h
	out	(IO_ADDR), a
wait_ready_:
	in	a, (IO_DATA)
	or	a
	jp	m, wait_ready_
	ret

IO_ADDR:	equ 8fh
IO_DATA:	equ 0cfh

R_IND_ROM:	equ 0h
R_IND_TGS:	equ 1h
R_IND_MAT:	equ 2h
R_IND_PAT:	equ 3h
R_IND_DOR:	equ 4h
R_IND_ROR:	equ 7h

R_X:		equ 7h
R_Y:		equ 6h

CMD_IND:	equ 80h
CMD_KRF:	equ 00h
CMD_OCT:	equ 30h
CMD_INY:	equ 0b0h
CMD_NOP:	equ 91h

XQR:		equ 8h

