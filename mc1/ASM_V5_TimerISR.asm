;
; ASM_V5_TimerISR.asm
;
; Created: 19.03.2018 14:01:04
; Author : simon
;

;---------------------------------------

.def temp = r16
.def tempa = r17
.def tempb = r18
.def stoppuhr = r20

.org 0
	jmp init
.org 0x28	; Auf der Adresse des “Timer1 Overflow Interrupt“ Vectors...
			; Adresse gem. Vektor-Table im ATmega256-Datasheet Kapitels „Interrupt“
	jmp ISR_Timer1_Overflow ; Sprung zu Timer ISR

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

	ldi temp, (1 << CS10) | (1 << CS11) ; Timer1 starten: Register TCCR1B auf Prescaler 64 (vgl. Datasheet S.156/157) 
	sts TCCR1B, temp ; TCCR1B ist ein „extern IO-Register“, weshalb Zugriff per „STS“ erfolgen muss!
	ldi temp, (1 << TOIE1) ; Interrupt-Quelle „Timer1-Overflow“ freigeben - Register TIMSK1, (vgl. S.161)
	sts TIMSK1, r16 ; TIMSK1 ist ebenfalls ein „extern IO-Register“ weshalb Zugriff per „STS“ nötig!
	sei

	jmp main

main:
	jmp main
	
;==========================
; interrupt handler
ISR_Timer1_Overflow:
	cli					; global interrupt disable
	
	in r17, PortA
	ldi r18, (1<<0)
	eor r17, r18		; mit XOR bit 1 invertieren
	clr r18				; r18 = 0
	sbis PinA, 4		; button gedrückt = LOW wird ldi r18 ausgeführt
	ldi r18, (1<<1)		; 
	eor r17, r18
	out PortA, r17

	andi r17, 0b00000010
	cpi r17, 0			; wenn button 4 gedrückt...
	breq nicht_zaehlen
	inc stoppuhr 		; ...stoppuhr inkrementieren
nicht_zaehlen:
	sbis PinA, 5		; wenn button 5 gedrückt...
	ldi stoppuhr, 0		; ...stoppuhr zurücksetzen
	out PortC, stoppuhr
	sei					; global interrupt enable
	reti



