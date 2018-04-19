/*
 * C3_ADC_LCDKeypad.c
 *
 * Created: 16.04.2018 12:56:43
 * Author : Simon Burkhardt
 */ 

#include <avr/io.h>
#include <util/delay.h>		// F_CPU=16000000UL
#include <stdio.h>
#include "../../lcd_keypad_m2560/lcd_keypad_m2560.h"

const int ADC_KEY_VALUES[7]= { 1023, 0, 143, 328, 504, 740, -1 };

/************************************************************************/
/* ADC Initialisieren                                                   */
/************************************************************************/
void init_adc(){
	ADMUX  |= (1 << REFS0);	// Set ADC reference to AVCC
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);			// Set ADC prescaler to 128 - 125KHz sample rate @ 16MHz
	ADCSRA |= (1 << ADEN);  // Enable ADC
}

/************************************************************************/
/* ADC auslesen                                                         */
/************************************************************************/
uint16_t read_adc(){
	ADCSRA |= (1 << ADSC);
	while(ADCSRA & (1 << ADSC));
	return ADC;
}

/************************************************************************/
/* Tasten des Keypads auslesen                                          */
/************************************************************************/
uint8_t get_key_press(){
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
		button = 1;			// Right 
	}
	if(val <= (145+tolerance) && val >= (145-tolerance) ){
		button = 2;			// Up
	}
	if(val <= (329+tolerance) && val >= (329-tolerance) ){
		button = 3;			// Down
	}
	if(val <= (505+tolerance) && val >= (505-tolerance) ){
		button = 4;			// Left
	}
	if(val <= (740+tolerance) && val >= (740-tolerance) ){
		button = 5;			// Select
	}
	return button;
}

/************************************************************************/
/* MAIN                                                                 */
/************************************************************************/
int main(void)
{
	static FILE lcd_fd = FDEV_SETUP_STREAM(lcd_putchar, NULL, _FDEV_SETUP_WRITE);
	stdout = &lcd_fd;	// set stdout to lcd stream initalized above

	init_lcd();
	init_adc();
	
	printf("Hello...\r");
	printf("World!\n");
    /* Replace with your application code */
    while (1) 
    {
		uint16_t val = read_adc();
		uint16_t voltagemv = ((50000 / 1024) * val)/10;
		
		uint16_t dvolt = voltagemv/1000;				// Spannungswert vor dem Komma
		uint16_t dmv = (voltagemv - (dvolt*1000))/10;   // Spannungswert Nachkommastellen
		
		printf("%d: %d mV\r", val, voltagemv);							// Analogwert
//		printf("%d mV\n", voltagemv);					// Spannung in mV
//		printf("%d.%02d V\n", dvolt, dmv);				// Spannung in x.xx V
		
		uint8_t button = get_key_press();
		switch(button){
			case 1:
				printf("Right\n");
				break;
			case 2:
				printf("Up\n");
				break;
			case 3:
				printf("Down\n");
				break;
			case 4:
				printf("Left\n");
				break;
			case 5:
				printf("Select\n");
				break;
			default:
				printf("None\n");
		}
		
		_delay_ms(50);
    }
}

