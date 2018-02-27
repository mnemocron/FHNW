;
; ASM_V2_Lauflicht.asm
;
; Created: 27.02.2018 08:02:09
; Author : simon
;

.def temp = r16
.def delms = r28

;==========================
; setup()
init:
	ldi temp, 0b11111111
	out DDRC, r16			; set all outputs
	ldi temp, 0b00000011
	out DDRA, r16			; set 0 & 1 as output
	clr temp
	out PortC, temp
	out PortA, temp

;==========================
; loop()
main:

;======== blink all LEDs ==
;	ldi temp, 0b10101010	; turn all outputs on
;	out PortC, temp
;	ldi temp, 0b00000010	; turn output 0 & 1 on
;	out PortA, temp

;	ldi delms, 255
;	rcall delay_milis

;	ldi temp, 0b01010101	; turn all outputs on
;	out PortC, temp
;	ldi temp, 0b00000001	; turn output 0 & 1 on
;	out PortA, temp

;	ldi delms, 255
;	rcall delay_milis

;========= Lauflicht =======
lauflicht:
	ldi r16, 0b00000001	; starting point
	ldi r17, 0x00
	ldi r18, 0x02	; left shift compare value (> PortA)
rotate_left:
	out PortC, r16
	out PortA, r17
	ldi delms, 100	; 100ms delay
	rcall delay_milis
	clc				; clear carry so nothing shifts in from at the bottom
	rol r16			; rotate r16 first
	rol r17			; shift into r17
	cp r17, r18		; if r17 < 0000 0010
	brlt rotate_left
	ldi r18, 1		; end of leftshift, set compare value for right shift
rotate_right:
	out PortC, r16
	out PortA, r17
	ldi delms, 100
	rcall delay_milis
	clc				; clear carry so nothing shifts in at the top
	ror r17			; rotate r17 first
	ror r16			; shift into r16
	cp r16, r18
	breq main		; would be more beautiful if there was a brneq command
	rjmp rotate_right

	rjmp main


; DELAY
; 1/16MHz = 62.5ns
; --> 16 cycles per us

; Delay [us] - delay for 1 us
delay_us:
	ldi r31, 2
delay_us_loop:
	dec r31               ; 1 cycle
	brne delay_us_loop    ; 2 cycles
	nop
	ret

; Delay [ms] - delay for 1ms
delay_ms:
	ldi r29, 4
	ldi r30, 72
delay_ms_loop:
	rcall delay_us
	dec r30
	brne delay_ms_loop
	dec r29
	brne delay_ms_loop
	rcall delay_us
	ret

; Delay for custom ammount of miliseconds, write ms into r28
delay_milis:
	rcall delay_ms
	dec delms
	brne delay_milis
	ret
	