define(`WRITE', `dnl
	  ; `$2->$1'
	    ld  a, 0x20 | `$1'
	    out (IO_ADDR), a
	    ld  a, `$2'
	    out (IO_DATA), a'dnl
)dnl
define(`IND', `dnl
	; `$2->$1'
WRITE(`0', `CMD_IND | $1')
WRITE(`1 | XQR', `$2')
	  call  wait_ready'dnl
)dnl
define(`KRFI', `dnl
	; `KRFI C=$1 B=$2 A=$3'
WRITE(`1', `$1')
WRITE(`2', `$2')
WRITE(`3', `$3')
WRITE(`0 | XQR', `CMD_KRF | 1')
	  call  wait_ready'dnl
)dnl
define(`OCTI', `dnl
	; `OCTI D=$1'
WRITE(`0', `CMD_OCT | 1')
WRITE(`1 | XQR', `$1')
	  call	wait_ready'dnl
)dnl
define(`INY', `dnl
	; `INY'
WRITE(`0 | XQR', `CMD_INY')
	  call  wait_ready'dnl
)dnl
define(`NOP', `dnl
	; `NOP'
WRITE(`0 | XQR', `CMD_NOP')
	  call  wait_ready'dnl
)dnl
