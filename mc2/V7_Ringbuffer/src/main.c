/**
  ******************************************************************************
  * @file    main.c
  * @author  (C) 2018 Matthias Meier
  * @brief   Minimal FreeRTOS example for STM32F429 board including LEDs and LCD
  ******************************************************************************
*/

/**
 * Hausaufgabe V5
 *
 */

#include <stdio.h>
#include <stdarg.h>
#include "stm32f4xx.h"
#include "stm32f429i_discovery.h"
#include "lcd_and_clock_init.h"
#include "lcd_log.h"
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "uart.h"
#include "ringbuffer.h"

#define LD3_GREEN GPIO_PIN_13
#define LD4_RED GPIO_PIN_14
#define LD_GPIO_PORT GPIOG

static void UartRxServiceTask(void *pvParameters);
static void HeartbeatTask(void *pvParameters);

// von Aufgabestellung abweichend weil:
// @param allign nicht gefordert ist
// darum verschiebt sich die Parameter Kontrolle durch den Compiler von index 3,4 auf 4,5
static int lcd_yprintf(int line, int color, int allign, const char *fmt, ...)
	__attribute__((__format__(__printf__,4,5)));

SemaphoreHandle_t LCDSemaphore;

int main(void)
{
	SystemInit();
    SystemClockConfig();
    HAL_Init();
	lcd_init();

	// https://www.freertos.org/xSemaphoreCreateBinary.html
    // LCDSemaphore = xSemaphoreCreateBinary(); // vor dem Starten des Schedulers
	LCDSemaphore = xSemaphoreCreateMutex();
	xSemaphoreGive(LCDSemaphore);

    BSP_LED_Init(LED3);
    BSP_LED_Init(LED4);
    BSP_PB_Init(BUTTON_KEY, BUTTON_MODE_GPIO);

    // TIM2_InitTimer(6);

	xTaskCreate(UartRxServiceTask, "UartIST", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 3), NULL);
	xTaskCreate(HeartbeatTask, "HrtBtTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 2), NULL);
	// xTaskCreate(WorkerTask, "WorkerTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 1), NULL);

	vTaskStartScheduler();
	/* the FreeRTOS scheduler never returns to here except on out of memory at creating the idle task */
	for (;;) ;
}

/**
 * @return     0 on success, 1 if LCD resource is busy
 */
static int lcd_yprintf(int line, int color, int allign, const char *fmt, ...)
{
	va_list ap;
	char text[30];
	va_start(ap, fmt);  // set ap pointer to start of fmt list
	vsnprintf(text, sizeof(text), fmt, ap);
	va_end(ap);         // free unused memory

	if(LCDSemaphore != NULL){
		// ask for permission to write to LCD
		if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
			BSP_LCD_SetTextColor(color);
			BSP_LCD_DisplayStringAt(0, (10 +line*20), (uint8_t*) text, allign);
			xSemaphoreGive(LCDSemaphore);
		} else {
			// LCD resource is busy
			return 1;
		}
	} else {
		return -1;
	}
	return 0;
}

static void HeartbeatTask(__attribute__ ((unused)) void *pvParameters)
{
	HAL_GPIO_WritePin(LD_GPIO_PORT, LD4_RED, 0);   // turn off
	int deltime = 60;

	while (1) {
		// provoke task priority inversion by not entering the task "blocked" state by reaching vTaskDelay
		while(BSP_PB_GetState(BUTTON_KEY) != 0){
			asm("nop;");
		}

		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD4_RED);
		vTaskDelay(deltime);
		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD4_RED);
		vTaskDelay(deltime);
		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD4_RED);
		vTaskDelay(deltime);
		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD4_RED);
		vTaskDelay(1000 - 3*deltime);
	}
}

static void UartRxServiceTask(__attribute__ ((unused)) void *pvParameters)
{
	extern SemaphoreHandle_t UartSemaphore;

	rb_init();
	InitUart();

	char text[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};

	while (1) {
		while(xSemaphoreTake(UartSemaphore, (TickType_t)1) != pdTRUE ){
			asm("nop;");
		}
		// do not give UartSemaphore --> wait for ISR to do this
		char ch = '\0';
		int8_t stat = 0;
		// clear text string
		uint8_t idx = 0;
		for(idx=0; idx<16; idx++)
			text[idx] = ch;

		idx = '\0';
		do{
			stat = rb_status();
			ch = rb_get();
			text[idx++] = ch;
		}while(stat > 0);

		text[idx] = '\0';  // replace <cr> with Null-terminator
		/*
		 * Du aber jetzt mal, das funktioniert immer noch nicht schön
		 * Input:  "hello, world!"
		 * Output: "hello, world!p"  <-- p ist ein Artefakt auf dem LCD
		 * Ohne Null-terminator wirds nur noch hässlicher
		 */

		lcd_yprintf(4, LCD_COLOR_WHITE, CENTER_MODE, "                ");
		lcd_yprintf(4, LCD_COLOR_DARKBLUE, CENTER_MODE, "%s", text);

		lcd_yprintf(5, LCD_COLOR_DARKBLUE, CENTER_MODE, "status: %d", stat);
		if(stat <0)  // overflow occurred
			rb_clear();

		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD3_GREEN);
		vTaskDelay(10);
	}
}

