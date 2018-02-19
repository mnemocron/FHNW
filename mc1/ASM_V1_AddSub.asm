;
; ASM_V1_AddSub.asm
;
; Created: 19.02.2018 14:44:23
; Author : simon
;


; Replace with your application code
start:
; 2.2
;   START SINGLE BYTE ADDITION
	ldi	r16, 0x05
	ldi r17, 0x07
	ldi r18, 0x00
	add r18, r16
	add r18, r17
;	END SINGLE BYTE ADDITION

; 2.3.1 Addition
;   START DUAL BYTE ADDITION
	ldi r17, 0xa0	; MSB 1
	ldi r18, 0xb1	; LSB 1
	ldi r19, 0xc2	; MSB 2
	ldi r20, 0xd3	; LSB 2
	add r18, r20	; LSB addieren
	adc r17, r19    ; MSB addieren inkl. carry
	adc r16, r31	; neuse MSB, falls overflow
	; result in r16 r17 r18 (BIG ENDIAN)
	; 01 63 84 (hex)
;	END DUAL BYTE ADDITION

; START DUAL BYTE ADDITION w/ adiw
;	ldi r20, 0xa0
;	ldi r21, 0xb1
;	ldi r22, 0xc2
;	ldi r23, 0xd3
;	adiw r21:20, 0xc2d3   ; only works for values <64
; END DUAL BYTE ADDITION w/ adiw

; 2.3.2 Subtraktion
;   START DUAL BYTE SUBTRACTION
	ldi r17, 0xa0	; 0xA0
	ldi r18, 0xb1	;     B1
	ldi r19, 0xc2	; 0xC2
	ldi r20, 0xd3	;     D3
	add r18, r20	; r18 = r18+r20
	adc r17, r19    ; including carry bit from before
	adc r16, r31
	; result in r16 r17 r18 (BIG ENDIAN)
	; 01 63 84 (hex)
	ldi r19, 0xe4
	ldi r20, 0xf5
	sub r18, r20
	sbc r17, r19
	sbc r16, r31
	; result in r16 r17 r18 (BIG ENDIAN)
	; 00 7e 8f (hex)
;	END DUAL BYTE SUBTRACTION


; 2.3.3 Wie kann ein (16-Bit-) Überlauf / Unterlauf des Gesamtergebnisses 
; programmtechnisch erkannt werden?
; - mit Befehl BRCS

end:
	nop
	rjmp end

