/**
  ******************************************************************************
  * @file    main.c
  * @author  Ac6
  * @version V1.0
  * @date    01-December-2013
  * @brief   Default main function.
  ******************************************************************************
*/

#include <stdio.h>
#include <stdarg.h>
#include "stm32f4xx.h"
#include "stm32f429i_discovery.h"

extern "C" {
	#include "lcd_and_clock_init.h"
	#include "lcd_log.h"
}
#include "stack.hpp"

static int lcd_yprintf(int line, int color, Text_AlignModeTypdef allign, const char *fmt, ...)
	__attribute__((__format__(__printf__,4,5)));

int main(void)
{
	SystemInit();
	SystemClockConfig();
	HAL_Init();
	lcd_init();

	// new returns a pointer --> https://stackoverflow.com/a/8036863
	// Stack stack = *new Stack(10);
	Stack stack = *new Stack(7);

	lcd_yprintf(0, LCD_COLOR_BLUE, LEFT_MODE, "Hello C++!");
	for(uint8_t i=0; i<10; i++){
		lcd_yprintf(2, LCD_COLOR_BLUE, LEFT_MODE, "Pushing: %d", i);
		stack.Push(i);
		int k = stack.Pop();
		lcd_yprintf(3, LCD_COLOR_BROWN, LEFT_MODE, "Popped: %d", k);
		HAL_Delay(1000);
	}
	delete &stack;
	lcd_yprintf(5, LCD_COLOR_DARKGREEN, LEFT_MODE, "Stack deleted.");

	for(;;);
}


static int lcd_yprintf(int line, int color, Text_AlignModeTypdef allign, const char *fmt, ...)
{
	va_list ap;
	char text[30];
	va_start(ap, fmt);  // set ap pointer to start of fmt list
	vsnprintf(text, sizeof(text), fmt, ap);
	va_end(ap);         // free unused memory

	BSP_LCD_SetTextColor(color);
	BSP_LCD_DisplayStringAt(0, (10 +line*20), (uint8_t*) text, allign);
	return 0;
}

