/*
 * C5_Lauftext.c
 *
 * Created: 07.05.2018 13:55:25
 * Author : simon
 */ 

#include <avr/io.h>
#include <util/delay.h>		// F_CPU=16000000UL
#include <stdio.h>
#include <string.h>
#include <avr/interrupt.h>
#include "../../lcd_keypad_m2560/lcd_keypad_m2560.h"

#define KEY_NONE   0
#define KEY_UP     2
#define KEY_DN     3
#define KEY_LEFT   4
#define KEY_RIGHT  1
#define KEY_SELECT 5

#define SEL_HOUR   0
#define SEL_MINUTE 1
#define SEL_SECOND 2

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
/* Tasten des Keypads auslesen                                          */
/************************************************************************/
static uint8_t get_key_press(){
	/*Spannungen
	*   Right   -   0 V     0
	*   Up      - 0.7 V   145
	*   Down    - 1.6 V   329
	*   Left    - 2.4 V   505
	*   Select  - 3.623V  740
	*/
	uint8_t tolerance = 10;
	uint16_t val = read_adc();
	uint8_t button = 0;		// None
	
	if(val <= 0+tolerance){
		button = KEY_RIGHT;			// Right 
	}
	if(val <= (145+tolerance) && val >= (145-tolerance) ){
		button = KEY_UP;			// Up
	}
	if(val <= (329+tolerance) && val >= (329-tolerance) ){
		button = KEY_DN;			// Down
	}
	if(val <= (505+tolerance) && val >= (505-tolerance) ){
		button = KEY_LEFT;			// Left
	}
	if(val <= (740+tolerance) && val >= (740-tolerance) ){
		button = KEY_SELECT;			// Select
	}
	return button;
}

static void lauftext(char s[]){
	lcd_gotoXY(0,0);
	for(int i=0; (i<16) && (i<strlen(s)); i++){
		lcd_putchar(s[i], stdout);
		_delay_ms(333);
	}
	while(1){
		int i=0;
		while(s[i++]){
			lcd_gotoXY(0,0);
			for (int k=0; (k<16) && (k<strlen(s)); k++){
				if((k+i) < strlen(s)){
					lcd_putchar(s[(k+i)], stdout);
				} else if((k+i)<(strlen(s)+1)){
					lcd_putchar(' ', stdout);
				} else {
					lcd_putchar(s[(k+i)%16], stdout);
				}
			}
			_delay_ms(333);
		}
	}
}

int main(void)
{
	static FILE lcd_fd = FDEV_SETUP_STREAM(lcd_putchar, NULL, _FDEV_SETUP_WRITE);
	stdout = &lcd_fd;	// set stdout to lcd stream initalized above

	init_lcd();
	init_adc();
	char werbung[] = "Hier konnte ihr String laufen.";
	
    while (1) 
    {
		lauftext(werbung);
    }
}

