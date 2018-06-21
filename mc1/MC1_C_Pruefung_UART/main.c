/*
 * MC1_C_Pruefung_Burkhardt_Simon.c
 *
 * Created: 11.06.2018 12:15:53
 * Author : burkhardt simon
 */ 

#include <avr/io.h>
#include <util/delay.h>		// F_CPU=16000000UL
#include <stdio.h>
#include <string.h>
#include <avr/interrupt.h>
#include "../../lcd_keypad_m2560/lcd_keypad_m2560.h"

#define RxD (1 << PA7)
#define ERR_Sta (1 << PA0)
#define ERR_Stp (1 << PA1)

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

#define _ERR_START_ON (PORTA |= ERR_Sta)
#define _ERR_STOP_ON (PORTA |= ERR_Stp)
#define _ERR_START_OFF (PORTA &= ~ (ERR_Sta))
#define _ERR_STOP_OFF (PORTA &= ~ (ERR_Stp))
#define _READ_RXD (PINA & RxD)?1:0
#define _RXD_IS_LOW (PINA & RxD)?0:1

typedef enum {SIdle, SStart, SData, N_States} state_t;
typedef state_t state_func_t(void);

volatile state_t state_now;
volatile uint8_t tic = 0;
volatile uint8_t bitcount = 0;
volatile uint8_t databyte = 0;
volatile char datavalid = TRUE;

static void init_IO(void){
	DDRA = 0xff & ~( RxD );
	PORTA |= ( RxD );   // pull-up
}

/************************************************************************/
/* State Machine                                                        */
/************************************************************************/

static state_t state_func_idle(void){
	if(_RXD_IS_LOW){
		tic = 0;
		return SStart;
	}
	return SIdle;
}

static state_t state_func_start(void){
	if(!_RXD_IS_LOW){
		_ERR_START_ON;
		PORTA &= 0b11101111;
		return SIdle;
	}
	if(tic == 3 && _RXD_IS_LOW){
		tic = 0;
		bitcount = 0;
		return SData;
	}
	tic ++;
	return SStart;
}

static state_t state_func_data(void){
	if(tic == 7 && bitcount == 8 && !_RXD_IS_LOW){
		datavalid = TRUE;
		_ERR_START_OFF;
		_ERR_STOP_OFF;
		return SIdle;
	}
	if(tic == 7 && bitcount == 8 && _RXD_IS_LOW){
		datavalid = TRUE;
		_ERR_STOP_ON;
		return SIdle;
	}
	if(tic == 7 && bitcount < 8){
		tic = 0;
		bitcount ++;
		databyte = (databyte*2) + _READ_RXD;
		return SData;
	}
	tic ++;
	return SData;
}

/* State Table */
state_func_t* const state_table[ N_States ] = {
	state_func_idle,
	state_func_start,
	state_func_data
};

/* State Machine ausführen */

state_t run_state(state_t state_now){
	return state_table[ state_now ]();    // Pointer conversation Error
};

/************************************************************************/
/* Timer 0 Initialisieren                                               */
/************************************************************************/
static void init_timer(void)
{
	// init 8 Bit Timer0
	TCCR0A = 1<<WGM01; // CTC Mode
	TCCR0B = 1<<CS00;  // start with no prescaler
	TIMSK0 = 1<<OCIE0A; // enable Compare A interrupt
	OCR0A = 208-1;	   // interrupt intervall 16MHz/208 = 76923 Hz
	sei();
	return;
}

ISR(TIMER0_COMPA_vect)
{
	state_now = run_state(state_now);
	return;
}

/************************************************************************/
/* USART1 Initialisieren                                                */
/************************************************************************/
static void init_usart(void)
{
	UBRR1 = 103;
	UCSR1B |= (1 << TXEN1);
	return;
}

static void usart_write(char b){
	while( ! (UCSR1A & (1<<UDRE1)) );
	UDR1 = b;
	return;
}
/************************************************************************/


int main(void)
{
    static FILE lcd_fd = FDEV_SETUP_STREAM(lcd_putchar, NULL, _FDEV_SETUP_WRITE);
    stdout = &lcd_fd;	// set stdout to lcd stream initalized above
	
	init_IO();
    init_lcd();
	init_timer();
	init_usart();
    
    lcd_gotoXY(0,0);
	
	state_now = SIdle;
	
	char wow[] = "wow";
	
	for(int i=0; i<strlen(wow); i++){
		while(!datavalid);
		usart_write(wow[i]);
		printf("%c (%x) ", databyte, databyte);  // %c for character %x for hex 
		databyte = 0;
		datavalid = FALSE;
	}
    
    while (1) {
    }
}

