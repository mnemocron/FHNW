// Simon Burkhardt

/**
  ******************************************************************************
  * @file    main.c
  * @author  Simon Burkhardt
  * @brief 	 mc2 HS19 Test
  ******************************************************************************
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
#include "stdlib.h"

#define LD3_GREEN GPIO_PIN_13
#define LD4_RED GPIO_PIN_14
#define LD_GPIO_PORT GPIOG

#define LCD_OFFSET 30   // obere LCD Zeilen leer lassen (12 Zeilen reichen aber nicht aus)

typedef struct Pos_t {
	int16_t x;
	int16_t y;
} Pos_t;

typedef struct LineParams_t {
	int taskNr;
	uint32_t color;
} LineParams_t;

TaskHandle_t hControlTask;  // Handle zum Beenden von Control Task (könnte man weglassen)
QueueHandle_t LineTaskQueue;

SemaphoreHandle_t LCDSemaphore;

enum { POS_VALID=0, BOUNCE_TOP, BOUNCE_BOTTOM, BOUNCE_LEFT, BOUNCE_RIGHT }; // für boundry check

int PositionIsValid(Pos_t pos);
uint32_t rand_col(void);
Pos_t rand_pos(void);
Pos_t rand_dir(void);
static void ControlTask(void *pvParameters);
static void LineTask(void *pvParameters);

// wegen allign verschiebt sich die Parameter Kontrolle durch den Compiler von index 3,4 auf 4,5
static int lcd_yprintf(int line, int color, int allign, const char *fmt, ...)
	__attribute__((__format__(__printf__,4,5)));

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

	LineTaskQueue = xQueueCreate(16, sizeof(LineParams_t));  // könnte mit Pointer gemacht werden

    BSP_LED_Init(LED3);
    BSP_LED_Init(LED4);
    BSP_PB_Init(BUTTON_KEY, BUTTON_MODE_GPIO);

	xTaskCreate(ControlTask, "CtrlTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 3), hControlTask);

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

static void ControlTask(__attribute__ ((unused)) void *pvParameters)
{
	BaseType_t ret;
	LineParams_t newLin;
	int newTaskNr = 0;
	int runningTasks = 0;
	while (1) {
		// vTaskDelay(900);
		// wait for new element
		if ( xQueueReceive(LineTaskQueue, &newLin, 900) == pdPASS ){
			// new element read
			BSP_LED_On(LED4);
			vTaskDelay(100);
			BSP_LED_Off(LED4);
			runningTasks --;
			lcd_yprintf(0, LCD_COLOR_GRAY, LEFT_MODE, "T%d", newLin.taskNr);  // in GRAY weil nicht anders spezifiziert
		}

		ret = xTaskCreate(LineTask, "LinTask", (configMINIMAL_STACK_SIZE + 80), (void *) newTaskNr, (tskIDLE_PRIORITY + 1), NULL);
		if(ret != pdPASS){
			BSP_LED_On(LED4);
			lcd_yprintf(0, LCD_COLOR_RED, RIGHT_MODE, "OOM #%d", newTaskNr);
			vTaskDelete(&hControlTask);
		} else {
			runningTasks ++;
			BSP_LED_On(LED3);
			vTaskDelay(100);
			BSP_LED_Off(LED3);
			newTaskNr ++;
		}
		lcd_yprintf(0, LCD_COLOR_GREEN, CENTER_MODE, "   %d   ", runningTasks);
	}
}

static void LineTask(__attribute__ ((unused)) void *pvParameters)
{
	uint32_t color = rand_col();

	Pos_t start = rand_pos();
	Pos_t dPos = rand_dir();
	int myTaskNr = (int) pvParameters;  // Tasknummer. Ohne cast weil schon nicht als pointer übergeben. Hacky but works. -\{:)_/-
	int retry = 0;

	while (1) {
		vTaskDelay(10);
		if ( (PositionIsValid(start) == POS_VALID) && (( BSP_LCD_ReadPixel(start.x, start.y) & 0x00ffffff) == 0xffffff) ){
				// pixel is white
				BSP_LCD_DrawPixel(start.x, start.y, color);
		} else {
			if(retry > 14){
				LineParams_t params;
				params.color = color;
				params.taskNr = myTaskNr;
				xQueueSend(LineTaskQueue, (void *) &params, 10);
				vTaskDelete(NULL);
			} else {
				dPos = rand_dir();
				retry ++;
			}
		}
		start.x += dPos.x;
		start.y += dPos.y;
	}
}

/**
 * get random uint32_t RGBA color with max alpha = 0xff
 */
uint32_t rand_col(void){
	unsigned int seed = xTaskGetTickCount();
	return (rand_r(&seed)) | 0xff000000;
}


/**
 * get random position on LCD
 */
Pos_t rand_pos(void){
	unsigned int seed = xTaskGetTickCount();
	Pos_t pos;
	pos.x = (rand_r(&seed) % (BSP_LCD_GetXSize()-1) );  seed++;
	pos.y = (rand_r(&seed) % (BSP_LCD_GetYSize()-1) ) + LCD_OFFSET;
	return pos;
}

/**
 * get random direction in 45° steps
 */
Pos_t rand_dir(void){
	unsigned int seed = xTaskGetTickCount();
	Pos_t pos;
	pos.x = (rand_r(&seed) % (3) -1 );  seed++;
	pos.y = (rand_r(&seed) % (3) -1 );
	return pos;
}


/**
 * do a Boundry Check of position on LCD
 */
int PositionIsValid(Pos_t pos){
	if ( (pos.x) < 0 )
		return BOUNCE_LEFT;
	if ( (pos.y - LCD_OFFSET) < 0 )
		return BOUNCE_TOP;
	if ( (pos.x) > (BSP_LCD_GetXSize()-1) )
		return BOUNCE_RIGHT;
	if ( (pos.y) > (BSP_LCD_GetYSize()-1) )
		return BOUNCE_BOTTOM;
	return POS_VALID;
}





