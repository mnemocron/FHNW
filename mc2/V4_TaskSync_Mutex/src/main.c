/**
  ******************************************************************************
  * @file    main.c
  * @author  (C) 2018 Matthias Meier
  * @brief   Minimal FreeRTOS example for STM32F429 board including LEDs and LCD
  ******************************************************************************
*/

/**
 * Hausaufgabe V4
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

#define LD3_GREEN GPIO_PIN_13
#define LD4_RED GPIO_PIN_14
#define LD_GPIO_PORT GPIOG

static void CounterTask(void *pvParameters);
static void HeartbeatTask(void *pvParameters);
static void WorkerTask(void *pvParameters);

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

	xTaskCreate(CounterTask, "CtrTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 3), NULL);
	xTaskCreate(HeartbeatTask, "HrtBtTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 2), NULL);
	xTaskCreate(WorkerTask, "HrtBtTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 1), NULL);

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

static void WorkerTask(__attribute__ ((unused)) void *pvParameters)
{
	while (1) {
		lcd_yprintf(0, LCD_COLOR_BLUE, LEFT_MODE, "Hello from worker task!");
		vTaskDelay(1);
	}
}

static void HeartbeatTask(__attribute__ ((unused)) void *pvParameters)
{
	HAL_GPIO_WritePin(LD_GPIO_PORT, LD4_RED, 0);   // turn off
	int deltime = 60;

	while (1) {
		// provoke task priority inversion by not entering the task "blocked" state by reaching vTaskDelay
		while(BSP_PB_GetState(BUTTON_KEY) != 0){
			asm("nop");
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

static void CounterTask(__attribute__ ((unused)) void *pvParameters)
{
	UBaseType_t uxHighWaterMark;
	/* Inspect our own high water mark on entering the task. */
	uxHighWaterMark = uxTaskGetStackHighWaterMark( NULL );

	int n=0;
	int semaphore_take_errors = 0;

	while (1) {
		semaphore_take_errors += lcd_yprintf(4, LCD_COLOR_DARKBLUE, CENTER_MODE, "Counter = %d", n++);
		semaphore_take_errors += lcd_yprintf(5, LCD_COLOR_GRAY, LEFT_MODE, "Free = %d bytes   ", (int)uxHighWaterMark*4 );
		semaphore_take_errors += lcd_yprintf(6, LCD_COLOR_RED, LEFT_MODE, "SemErr = %d", semaphore_take_errors);
		uxHighWaterMark = uxTaskGetStackHighWaterMark( NULL );

		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD3_GREEN);
		vTaskDelay(1);  // short delay to provoke errors
	}
}

