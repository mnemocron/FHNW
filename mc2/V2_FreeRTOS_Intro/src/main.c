/**
  ******************************************************************************
  * @file    main.c
  * @author  (C) 2018 Matthias Meier
  * @brief   Minimal FreeRTOS example for STM32F429 board including LEDs and LCD
  ******************************************************************************
*/

#include <stdio.h>
#include "stm32f4xx.h"
#include "stm32f429i_discovery.h"
#include "lcd_and_clock_init.h"
#include "lcd_log.h"
#include "FreeRTOS.h"
#include "task.h"
//#include "queue.h"
//#include "semphr.h"

#define INCLUDE_uxTaskGetStackHighWaterMark

#define LD3_GREEN GPIO_PIN_13
#define LD4_RED GPIO_PIN_14
#define LD_GPIO_PORT GPIOG

/* OpenOCD supports GDB task context display with FreeRTOS by adding config option "$_TARGETNAME configure -rtos auto"
 * When using SW4STM32 this could be done by setting the "Debug Configuration" to a "user defined" OpenOCD config script,
 * then appending "$_TARGETNAME configure -rtos auto" at the end of the (previously) auto-generated config script (*.cfg).
 * Now OpenOCD expects a variable 'xTopReadyPriority' which unfortunately was removed in newer FreeRTOS releases,
 * but the variable might easily be addeding following variable:
 *   const int __attribute__((used)) uxTopUsedPriority = configMAX_PRIORITIES-1;
 * But by doing this, unfortunately OpenOCD no more allows breakpoints before FreeRTOS is running, so the initial
 * breakpoint at entry of 'main()' has to be disabled in the "Debug Configuration", otherwise the debugger hangs forever!
 */

static void CounterTask(void *pvParameters);
static void HeartbeatTask(void *pvParameters);
static void WorkerTask(void *pvParameters);

int main(void)
{
	SystemInit();
    SystemClockConfig();
    HAL_Init();

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
	lcd_init();
	BSP_LCD_SetTextColor(LCD_COLOR_BLUE);

	while (1) {
		char text[30];
		snprintf(text, sizeof(text), "Hello from Worker Task!");
		BSP_LCD_DisplayStringAt(0, 10, (uint8_t*) text, LEFT_MODE);
		vTaskDelay(1000);
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
	lcd_init();
	BSP_LCD_SetTextColor(LCD_COLOR_MAGENTA);

	while (1) {
		char text[20];
		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD3_GREEN);
		vTaskDelay(500);
		snprintf(text, sizeof(text), "Counter = %d", n++);
		BSP_LCD_DisplayStringAt(0,BSP_LCD_GetYSize() / 2, (uint8_t*) text, CENTER_MODE);

		snprintf(text, sizeof(text), "                 ");
		BSP_LCD_DisplayStringAt(0,BSP_LCD_GetYSize() / 2 + 20, (uint8_t*) text, CENTER_MODE);
		snprintf(text, sizeof(text), "Free = %d bytes", (int)uxHighWaterMark*4 );
		BSP_LCD_DisplayStringAt(0,BSP_LCD_GetYSize() / 2 + 20, (uint8_t*) text, CENTER_MODE);
		uxHighWaterMark = uxTaskGetStackHighWaterMark( NULL );
	}
}

