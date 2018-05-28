/*
 * C7_Wischer_StateMachine.c
 *
 * Created: 28.05.2018 17:58:42
 * Author : simon
 */ 

#include <avr/io.h>
#include <util/delay.h>		// F_CPU=16000000UL
#include <stdio.h>
#include <string.h>
#include <avr/interrupt.h>
#include "../../lcd_keypad_m2560/lcd_keypad_m2560.h"

volatile int timer_counter = 0;
volatile int interval_time = 0;

/************************************************************************/
/* I/O für Buttons                                                      */
/************************************************************************/
#define BTN_Ein (1 << PA0)
#define BTN_Aus (1 << PA1)
#define _btn_Ein_isPressed (PINA & BTN_Ein)?0:1
#define _btn_Aus_isPressed (PINA & BTN_Aus)?0:1

#define OUT_Wischer (1 << PC0)
#define _wischer_ein (PORTC |= OUT_Wischer)
#define _wischer_aus (PORTC &= ~(OUT_Wischer))

static void init_IO(void){
	DDRA = 0xff & ~( BTN_Ein | BTN_Aus );	// PA0 / PA1
	PORTA |= ( BTN_Ein | BTN_Aus );
	DDRC = 0xff;
	PORTC = 0x00;
}

/************************************************************************/
/* State Machine                                                        */
/* https://stackoverflow.com/questions/133214/is-there-a-typical-state-machine-implementation-pattern */
/************************************************************************/
/* mögliche States */
typedef enum {S_Aus, S_Ein, S_Messen, S_Warten, N_States} state_t;

/*  */
typedef state_t state_func_t(void);

state_t state_func_Aus(void){
	lcd_gotoXY(0,0);
	printf("Aus");
	if(_btn_Ein_isPressed){
		_wischer_ein;
		return S_Ein;
	}
	return S_Aus;
}

state_t state_func_Ein(void){
	lcd_gotoXY(0,0);
	printf("Ein");
	if(_btn_Aus_isPressed){
		_wischer_aus;
		return S_Messen;
	}
	_wischer_ein;
	return S_Ein;
}

#define TIMER_MAXIMUM 100
state_t state_func_IntervalMeasure(void){
	lcd_gotoXY(0,0);
	printf("Maes");
	if(_btn_Ein_isPressed){
		interval_time = timer_counter;
		_wischer_ein;
		timer_counter = 0;
		return S_Warten;
	}
	if(timer_counter > TIMER_MAXIMUM){
		timer_counter = 0;
		return S_Aus;
	}
	timer_counter ++;
	_wischer_aus;
	return S_Messen;
}

state_t state_func_IntervalWait(void){
	lcd_gotoXY(0,0);
	printf("Wait");
	if(_btn_Aus_isPressed){
		timer_counter = 0;
		_wischer_ein;
		return S_Messen;
	}
	if(timer_counter == interval_time){
		timer_counter = 0;
		_wischer_ein;
		return S_Warten;
	}
	timer_counter ++;
	_wischer_aus;
	return S_Warten;
}

/* State Table */
state_func_t* const state_table[ N_States ] = {
	state_func_Aus,
	state_func_Ein,
	state_func_IntervalMeasure,
	state_func_IntervalWait
};

/* State Machine asuführen */
/*
state_t run_state(state_t state_now){
	return state_table[ state_now ];    // Pointer conversation Error
};
*/
state_t run_state_machine(state_t state_now){
	switch(state_now){
		case S_Aus:
			return state_func_Aus();
		case S_Ein:
			return state_func_Ein();
		case S_Messen:
			return state_func_IntervalMeasure();
		case S_Warten:
			return state_func_IntervalWait();
		default:
			return S_Aus;
	}
}

/************************************************************************/
/* Main                                                                 */
/************************************************************************/
int main(void)
{
	static FILE lcd_fd = FDEV_SETUP_STREAM(lcd_putchar, NULL, _FDEV_SETUP_WRITE);
	stdout = &lcd_fd;	// set stdout to lcd stream initalized above
	
	init_IO();
	init_lcd();
	
	state_t state = S_Aus;
	lcd_gotoXY(0,0);
	// printf("hello");
	
    while (1) {
		// state = run_state(state);      // Funktioniert nicht
		state = run_state_machine(state);
		_delay_ms(100);
    }
}

