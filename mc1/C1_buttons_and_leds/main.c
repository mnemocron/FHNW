/*
 * C1_buttons_and_leds.c
 *
 * Created: 09.04.2018 14:05:24
 * Author : simon
 */ 

#include <avr/io.h>
#include <util/delay.h>

#define BTNa (1 << 4)
#define BTNb (1 << 5)
#define BUTTONS_A (BTNa | BTNb)

unsigned char read_buttons(void){
	
	unsigned char buttons = PINA;
	buttons = ~buttons;
	buttons &= BUTTONS_A;
	return buttons;
	
	// return ( (~ (PINA)) & BUTTONS_A );  // does not work
}

void initIO(void)
{
	DDRC = 0xff;
	DDRA = 0xff & ~(BTNa | BTNb);
	PORTA |= BUTTONS_A;		// enable pull-ups
}

int main(void)
{
	volatile uint8_t LD9on = 0;             // LED 9 toggle value
	volatile uint8_t counter = 0;           // PORTC counter
	volatile unsigned char btn_prev = 0;    // holds the previous button values for edge detection
	
	initIO();
	
	for(;;)
	{
		
		if(  (read_buttons() & BTNa)  >  (btn_prev & BTNa)  )
			LD9on = !LD9on;     // toggle LED 9
			
		if(  (read_buttons() & BTNb)  >  (btn_prev & BTNb)  ) 
			counter ++ ;        // increment counter
		
		LD9on ? (PORTA |= 0x02) : (PORTA &= 0b11111101);
		PORTC = counter;
		
		btn_prev = read_buttons();
		_delay_ms(10);          // debounce
		
	}
}