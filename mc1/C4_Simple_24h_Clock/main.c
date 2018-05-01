/*
 * C4_Simple_24h_Clock.c
 *
 * Created: 30.04.2018 14:44:21
 * Author : simon
 */ 

#include <avr/io.h>
#include <util/delay.h>		// F_CPU=16000000UL
#include <stdio.h>
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
volatile int tics = 0;
volatile int8_t hours = 23;
volatile int8_t minutes = 59;
volatile int8_t seconds = 50;
volatile char display = 0;
volatile char previous_key = KEY_NONE;

volatile char selected_time = SEL_HOUR;

static void set_time(void);
static void init_timer(void);
static void init_adc(void);
static uint16_t read_adc(void);
static uint8_t get_key_press(void);
static void process_keys(uint8_t);

/************************************************************************/
/* Zeit einstellen */
/************************************************************************/
void set_time(void){
	if(tics > 124){
		tics = 0;
		seconds ++;
		display = 1;
	}
	if(seconds > 59){
		seconds = 0;
		minutes ++;
	}
	if(minutes > 59){
		minutes = 0;
		hours ++;
	}
	if(hours > 23){
		hours = 0;
	}
}

/************************************************************************/
/* Timer 0 ISR Interrupt Handler */
/************************************************************************/
ISR(TIMER0_COMPA_vect){
	cli();
	tics ++;
	sei();
	return;
}

ISR(TIMER1_COMPA_vect){
	cli();
	tics ++;
	set_time();
	uint8_t key = get_key_press();
	if(key != KEY_NONE){
		process_keys(key);
	} else {
		previous_key = KEY_NONE;
	}
	sei();
	return;
}

/************************************************************************/
/* Timer 0 Initialisieren                                                   */
/************************************************************************/
static void init_timer(void){
	
	//cli();          // disable global interrupts
	//TCCR0A = 0;     // set entire TCCR0A register to 0
	//TCCR0B = 0;     // same for TCCR0B
	//OCR0A = 125;	// set compare match register to desired timer count
	//OCR0B = (125L - OCR0A) >> 8;
	//TCCR0B |= (1 << WGM02);		// turn on CTC mode
	////TCCR0B |= (1 << CS00);		// :256 prescaler
	//TCCR0B |= (1 << CS02);
	//TIMSK0 |= (1 << OCIE0A);	// enable timer compare interrupt
	
	/* es isch jetz eifach mou so 21:49 und i ha ke Bock me uf dä blöd Timer0
	 * weisch.. es geit ja sogar mit em Timer1, aber Nei,
	 * "Hoi, ig heisse Timer0 und i bi es Stück scheisse :D " */
	
	cli();          // disable global interrupts
	TCCR1A = 0;     // set entire TCCR1A register to 0
	TCCR1B = 0;     // same for TCCR1B
	OCR1A = 125;	// set compare match register to desired timer count
	// 16 MHz / 1024 = 15.625 kHz
	// 15.625 kHz / 125 = 125 per second
	// 1/125 = 8ms period
	TCCR1B |= (1 << WGM12);		// turn on CTC mode
	TCCR1B |= (1 << CS10);		// Set CS10 and CS12 bits for 1024 prescaler
	TCCR1B |= (1 << CS12);
	TIMSK1 |= (1 << OCIE1A);	// enable timer compare interrupt
	sei();
}

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

/************************************************************************/
/* Tasten des Keypads auslesen                                          */
/************************************************************************/
static void process_keys(uint8_t key){
	if(key != previous_key){
		
		if(key == KEY_RIGHT){
			selected_time ++;
		}
		if(key == KEY_LEFT){
			selected_time --;
		}
		if(selected_time < 0){
			selected_time = 2;
		}
		if(selected_time > 2){
			selected_time = 2;
		}
		
		lcd_gotoXY(0, 1);
		switch (selected_time){
			case SEL_HOUR:
				printf("HH      ");
				if(key == KEY_UP){
					hours ++;
				}
				if(key == KEY_DN){
					hours --;
				}
				break;
			case SEL_MINUTE:
				printf("   MM   ");
				if(key == KEY_UP){
					minutes ++;
				}
				if(key == KEY_DN){
					minutes --;
				}
				break;
			case SEL_SECOND:
				printf("      SS");
				if(key == KEY_UP){
					seconds ++;
				}
				if(key == KEY_DN){
					seconds --;
				}
				break;
			default:
				break;
				
		}
		
		if(hours > 23){
			hours = hours%24;
		}
		if(hours < 0){
			hours = 24 + hours;
		}
		if(minutes > 59){
			minutes = minutes%60;
		}
		if(minutes < 0){
			minutes = 60 + minutes;
		}
		if(seconds > 59){
			seconds = seconds%60;
		}
		if(seconds < 0){
			seconds = 60 + seconds;
		}
		display = 1;
	}
	previous_key = key;
}

int main(void)
{
	static FILE lcd_fd = FDEV_SETUP_STREAM(lcd_putchar, NULL, _FDEV_SETUP_WRITE);
	stdout = &lcd_fd;	// set stdout to lcd stream initalized above

	init_lcd();
	init_adc();
	init_timer();
	cli();
	
	int a = OCR0A;
	int b = OCR0B;
	printf("Hello %d %d\r", a, b);
	//printf("World!\n");
	
	_delay_ms(500);
	
	sei();
	
    while (1) 
    {
		while(display == 0){
			_delay_ms(1);
		}
		lcd_gotoXY(0,0);
		printf("%02d:%02d:%02d   ", hours, minutes, seconds);
		display = 0;
    }
}

