/**
  ******************************************************************************
  * @file    main.c
  * @author  (C) 2018 Matthias Meier
  * @brief   Minimal FreeRTOS example for STM32F429 board including LEDs and LCD
  ******************************************************************************
*/

/**
 * Hausaufgabe V3
 *
 * Unklar ob korrekt gelöst, da die semaphore_take_errors Variable nicht inkrementiert wird
 * dies selbst bei hoher Updaterate der Tasks (1ms delay).
 */

#include <stdio.h>
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

SemaphoreHandle_t LCDSemaphore;

int main(void)
{
	SystemInit();
    SystemClockConfig();
    HAL_Init();
	lcd_init();

	// https://www.freertos.org/xSemaphoreCreateBinary.html
    LCDSemaphore = xSemaphoreCreateBinary(); // vor dem Starten des Schedulers
    xSemaphoreGive(LCDSemaphore);

    BSP_LED_Init(LED3);
    BSP_LED_Init(LED4);

	xTaskCreate(CounterTask, "CtrTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 3), NULL);
	xTaskCreate(HeartbeatTask, "HrtBtTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 2), NULL);
	xTaskCreate(WorkerTask, "HrtBtTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 1), NULL);

	vTaskStartScheduler();

	/* the FreeRTOS scheduler never returns to here except on out of memory at creating the idle task */
	for (;;) ;
}

static void WorkerTask(__attribute__ ((unused)) void *pvParameters)
{
	while (1) {
		if(LCDSemaphore != NULL){
			// ask for permission to write to LCD
			if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
				char text[30];
				snprintf(text, sizeof(text), "Hello from Worker Task!");
				BSP_LCD_SetTextColor(LCD_COLOR_BLUE);
				BSP_LCD_DisplayStringAt(0, 10, (uint8_t*) text, LEFT_MODE);

				xSemaphoreGive(LCDSemaphore); // done using LCD resource
			} else {
				// LCD resource is busy
			}
			vTaskDelay(1);
		}
	}
}

static void HeartbeatTask(__attribute__ ((unused)) void *pvParameters)
{
	HAL_GPIO_WritePin(LD_GPIO_PORT, LD4_RED, 0);   // turn off
	int deltime = 60;

	while (1) {
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
		if(LCDSemaphore != NULL){
			// ask for permission to write to LCD
			if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
				char text[20];
				snprintf(text, sizeof(text), "Counter = %d", n++);
				BSP_LCD_SetTextColor(LCD_COLOR_RED);
				BSP_LCD_DisplayStringAt(0,BSP_LCD_GetYSize() / 2, (uint8_t*) text, CENTER_MODE);

				snprintf(text, sizeof(text), "                 ");
				BSP_LCD_DisplayStringAt(0,BSP_LCD_GetYSize() / 2 + 20, (uint8_t*) text, CENTER_MODE);
				snprintf(text, sizeof(text), "Free = %d bytes", (int)uxHighWaterMark*4 );
				BSP_LCD_DisplayStringAt(0,BSP_LCD_GetYSize() / 2 + 20, (uint8_t*) text, CENTER_MODE);
				snprintf(text, sizeof(text), "SemErr = %d", semaphore_take_errors );
				BSP_LCD_DisplayStringAt(0,BSP_LCD_GetYSize() / 2 + 40, (uint8_t*) text, CENTER_MODE);

				uxHighWaterMark = uxTaskGetStackHighWaterMark( NULL );
				xSemaphoreGive(LCDSemaphore); // done using LCD resource
			} else {
				// LCD resource is busy
				semaphore_take_errors++;
			}
			HAL_GPIO_TogglePin(LD_GPIO_PORT, LD3_GREEN);
			vTaskDelay(1);  // short delay to provoke errors
		}
	}
}

