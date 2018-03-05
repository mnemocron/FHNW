;
; ASM_V3_TastenZaehlen.asm
;
; Created: 05.03.2018 13:41:51
; Author : simon
;


.def temp = r16
.def delms = r28
.def zaehler_a4 = r20
.def zaehler_a5 = r21
.def btn_a4 = r24
.def btn_a5 = r25

;==========================
; setup()
init:
	ldi temp, 0b11111111
	out DDRC, temp			; set all outputs
	ldi temp, 0b00000011
	out DDRA, temp			; set 0 & 1 as output
	clr temp
	out PortC, temp
	ldi temp, 0b00110000	; enable pull-up on inputs
	out PortA, temp
	clr zaehler_a4
	clr zaehler_a5

;==========================
; loop()
main:
;	in temp, PinA
;	andi temp, 0b00110000
;	out PortC, temp
;	clr temp
	rcall ausgabe		; ausgabe zu Begin
	in btn_a4, PinA
	andi btn_a4, 0b00010000
	in btn_a5, PinA
	andi btn_a5, 0b00100000
entprellen:
	ldi delms, 10
	rcall delay_milis
btn_a4_check:
	in temp, PinA
	andi temp, 0b00010000
	cp temp, btn_a4		; temp < btn_a4 --> btn pressed
	brlt btn_a4_pressed
	rjmp btn_a5_check
btn_a4_pressed:
	rcall zaehlen_a4
btn_a5_check:
	in temp, PinA
	andi temp, 0b00100000
	cp temp, btn_a5		; temp < btn_a5 --> btn pressed
	brlt btn_a5_pressed
	rjmp both_btn_check
btn_a5_pressed:
	rcall zaehlen_a5
both_btn_check:			; reset erst am Schluss um Glitches zu vermeiden
	in temp, PinA
	andi temp, 0b00110000
	clr r17
	cp r16,r17
	breq reset_zaehler
	rjmp main
reset_zaehler:
	clr zaehler_a4
	clr zaehler_a5
	rjmp main

; Zähler inkrementieren
zaehlen_a4:
	inc zaehler_a4
	ret

; Zähler dekrementieren
zaehlen_a5:
	inc zaehler_a5
	ret

; Ausgabe an Ports
; r1                r0
; . . . . . . 4 4 | 4 4 4 5 5 5 5 5 
; PortA           | PortC
; . . r r . . L L | L L L L L L L L
; r = pull-up / L = LED / 4 = btn A4 / 5 = btn A5
ausgabe:
	clr r0					; to PortC
	clr r1					; to PortA
	ldi r17, 32				; logical shift left by 5 bits
	mov r16, zaehler_a4
	mul r16, r17			; resulting word is in r0, r1
	ldi r16, 0b00000011		; just set the LEDs of Port a
	and r1, r16
	ldi r16, 0b00110000		; don't forget the output pull-ups!
	or r1, r16
	out PortA, r1	; OUT
	mov r16, zaehler_a5
	andi r16, 0b00011111	; clear upper 3 bits which belong to A4
	or r0, r16				; maskt r0 with r16 to set the LEDs on
	out PortC, r0	; OUT
	ret

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
	