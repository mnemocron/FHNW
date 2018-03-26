; Burkhardt Simon

; AssemblerPruefung.asm
;
; Created: 26.03.2018 12:16:37
; Author : simon

; Zeit: 90 min

; Softwaremässige Serielle Übertragung auf PA7
; Baudrate: 19200 -> Delay = 52us
; Bei Betätigen von PA5 wird ein Byte gesendet und
; über die interne USART1 Hardware empfangen
; Die Empfangenen Daten werden an PortC ausgegeben

; Diese Lösung hat auf der Hardware NICHT funktioniert !

.def temp = r16
.def datenOut = r19
.def datenIn = r20
.def tmpDaten = r21
.def tmpMask = r22
.def loop = r23

.org 0
	jmp init

init:
	; Init Stackpointer
	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp, low(RAMEND)
	out SPL, temp

	rcall IOconfig

	ldi datenOut, 0b11101110
	; rcall txDelay           ;  1.81 us
	jmp main				  ; 53.44 us

main:
	sbis PinA, 5			; wenn button 5 gedrückt...
	jmp buttonpressed
	jmp notpressed
buttonpressed:
	rcall serialTransmit
	rcall serialReceive
	inc datenOut			; inkrementieren
notpressed:
	sbis PinA, 5
	jmp notpressed			; wait for button release
	out PortC, datenIn
	rjmp main

IOconfig:
	ldi temp, 0b11111011	; PORT D (RX)
	out DDRD, temp

	ldi temp, 0b11111111	; PORT C (leds)
	out DDRC, temp			; set all outputs
	clr temp
	out PortC, temp

	ldi temp, 0b10000011	; PORT A (buttons + leds)
	out DDRA, temp			; set 0 & 1 as output
	ldi temp, 0b10100000	; enable pull-up on inputs, PA7 Ruhezustand
	out PortA, temp

	ldi temp, 51
	sts UBRR1L, temp
	clr temp
	ldi temp, (1 << RXEN1)
	ret

serialTransmit:
	ldi temp, PortA				; transmission start anzeigen
	ori temp, 0b00000010
	out PortA, temp

	mov r21, datenOut
	in temp, PortA
	andi temp, 0b01111111		; startbit
	out PortA, temp
	rcall txDelay

	ldi loop, 8
transmitLoop:
	in temp, PortA
	andi temp, 0b01111111		; bit 0 setzen
	mov tmpMask, tmpDaten		;
	andi tmpMask, 0b00000001	; nur das lsb
	lsl tmpMask					; shift to PA7
	lsl tmpMask
	lsl tmpMask
	lsl tmpMask
	lsl tmpMask
	lsl tmpMask
	lsl tmpMask
	or temp, tmpMask			; PA7 setzen
	out PortA, temp				; ausgeben

	rcall txDelay
	lsr tmpDaten				; nächstes LSB
	dec loop
	brne transmitloop

	; Stoppbit
	in temp, PortA
	ori temp, 0b10000000		; stopbit
	out PortA, temp
	rcall txDelay

	ldi temp, PortA				; transmission ende anzeigen
	andi temp, 0b11111101
	out PortA, temp
	ret

serialReceive:
	lds temp, UCSR1A
	andi temp, (1 << RXC1)
	cpi temp, 0
	breq rxError
	lds temp, UDR1
	mov datenIn, temp
	in temp, PortA				; kein Error auf PA0 anzeigen
	andi temp, 0b11111110
	out PortA, temp
	ret
rxError:
	ser datenIn
	in temp, PortA				; Error auf PA0 anzeigen
	ori temp, 0b00000001
	out PortA, temp
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

; Delay [ms] - delay for 52us
; 53.44 - 1.81 = 51.63us
txDelay:
	ldi r29, 43
delay_ms_loop:
	rcall delay_us
	dec r29
	brne delay_ms_loop
	ret

