;
; ASM_V4_ExternalInterrupt.asm
;
; Created: 12.03.2018 14:15:25
; Author : simon
;

.def temp = r16
.def isrtemp = r17
.def delms = r25

.org 0
	jmp init
.org 0x04
	jmp ISR_INT1

;==========================
; setup()
init:
	; Init Stackpointer
	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp, low(RAMEND)
	out SPL, temp

	; Init I/Os
	ldi temp, 0b11111111	; PORT C (leds)
	out DDRC, temp			; set all outputs
	clr temp
	out PortC, temp

	ldi temp, 0b00000011	; PORT A (buttons + leds)
	out DDRA, temp			; set 0 & 1 as output
	ldi temp, 0b00110000	; enable pull-up on inputs
	out PortA, temp

	ldi temp, 0b00000010	; PORT D (interrupt)
	out DDRD, temp
	out PortD, temp			; enable pull-up on input

	ldi temp, (1 << ISC11)	; falling edge interrupt on INT1
	sts EICRA, temp

	in  temp, EIMSK			; enable INT1
	ori temp, (1 << INT1)
	out EIMSK, temp

	sei

	ldi delms, 250


;==========================
; loop()
main:
	; Race Condition simmulieren:
	; im main wird PortC eingelesen, abgewartet, 
	; inkrementiert und wieder ausgegeben.
	; Das selbe geschieht auch beim Betätigen des Buttons.
	; Wenn man den Button betätigt, während im main gewartet wird,
	; so wird zwei mal der gleich Wert in PortC inkrementiert 
	; und ausgegeben.
	in temp, PortC
	rcall delay_ms
	rcall delay_ms
	rcall delay_ms
	rcall delay_ms
	inc temp
	out PortC, temp

	rjmp main

;==========================
; interrupt handler
ISR_INT1:
	cli					; global interrupt disable
	in isrtemp, PortC
	inc isrtemp			; PortC inkrementieren
	out Portc, isrtemp
	sei					; global interrupt enable
	reti	




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
delay_one_ms:
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
delay_ms:
	rcall delay_one_ms
	dec delms
	brne delay_ms
	ret
	