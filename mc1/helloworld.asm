.include "m2560def.inc"

start:
	ldi	r16,	0x80
	out	DDRB,	r16

toggleLed:
	in	r17,	PORTB
	eor	r17,	r16
	out	PORTB,	r17
	rjmp		toggleLed
