/*
 * C6_Drehimpulsgeber.c
 *
 * Created: 14.05.2018 13:37:47
 * Author : simon
 */ 

#include <avr/io.h>

#include <avr/io.h>
#include <util/delay.h>		// F_CPU=16000000UL
#include <stdio.h>
#include <string.h>
#include <avr/interrupt.h>
#include "../../lcd_keypad_m2560/lcd_keypad_m2560.h"

enum Keys{KEY_NONE=0, KEY_RIGHT, KEY_UP, KEY_DN, KEY_LEFT, KEY_SELECT};

const int ADC_KEY_VALUES[7]= { 1023, 0, 143, 328, 504, 740, -1 };

/************************************************************************/
/* ADC Initialisieren                                                   */
/************************************************************************/
static void init_adc(void){
	ADMUX  |= (1 << REFS0);	// Set ADC reference to AVCC
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);			// Set ADC prescaler to 128 - 125KHz sample rate @ 16MHz
	ADCSRA |= (1 << ADEN);  // Enable ADC
}

/************************************************************************/
/* ADC auslesen                                                         */
/************************************************************************/
static uint16_t read_adc(void){
	ADCSRA |= (1 << ADSC);
	while(ADCSRA & (1 << ADSC));
	return ADC;
}

/************************************************************************/
/* I/O für Rotary Encoder                                               */
/************************************************************************/
void init_IO(void){
	DDRA = 0xff & ~((1 << PA0)|(1 << PA1));	// PA0 / PA1
	PORTA |= ((1 << PA0)|(1 << PA1));
}

/************************************************************************/
/* STATE MACHINE für Rotary Encoder                                     */
/************************************************************************/
enum ROT_STATE{AnBn, ABn, AB, AnB};
volatile int counter = 0;
volatile int rot_state = AnBn;

static void read_rotary(void){
	char buttons = (~PINA) & ((1<<PA1)|(1<<PA0));
	char btA = (buttons & (1<<PA1));
	char btB = (buttons & (1<<PA0));
	
	switch(rot_state){
		case AnBn:
			if(btA && !btB){
				rot_state = ABn;
				counter ++;
			}
			if(!btA && btB){
				rot_state = AnB;
				counter --;
			}
			break;
		case ABn:
			if(btA && btB){
				rot_state = AB;
				counter ++;
			}
			if(!btA && !btB){
				rot_state = AnBn;
				counter --;
			}
			break;
		case AB:
			if(!btA && btB){
				rot_state = AnB;
				counter ++;
			}
			if(btA && !btB){
				rot_state = ABn;
				counter --;
			}
			break;
		case AnB:
			if(!btA && !btB){
				rot_state = AnBn;
				counter ++;
			}
			if(btA && btB){
				rot_state = AB;
				counter --;
			}
			break;
	}
}


int main(void)
{
	static FILE lcd_fd = FDEV_SETUP_STREAM(lcd_putchar, NULL, _FDEV_SETUP_WRITE);
	stdout = &lcd_fd;	// set stdout to lcd stream initalized above
	
	init_IO();
	init_adc();
	init_lcd();
	
	// TODO
	// Initialwert setzen, ist aber nicht schlimm, weil
	// sich der State automatisch setzt. Die ersten 2 Schritte beim Drehen
	// sind unter Umständen unbemerkt
	rot_state = AnBn; 
	
    while (1) {
		read_rotary();
		lcd_gotoXY(0,0);
		printf("%d   ", counter);
		//_delay_ms(10);
    }
}

