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

#define LD3_GREEN GPIO_PIN_13
#define LD4_RED GPIO_PIN_14
#define LD_GPIO_PORT GPIOG

#define ANIM_FPS 30

#define ELEVATOR_TOP_FLOOR 3
#define ELEVATOR_GROUND_FLOOR -1
#define ELEVATOR_FLOORS ((ELEVATOR_TOP_FLOOR - ELEVATOR_GROUND_FLOOR)+1)

static void ElevatorTask(void *pvParameters);
static void ButtonTask(void *pvParameters);
static void AnimationTask(void *pvParameters);

float easeInOutCubic(float t, float b, float c, float d);

static int lcd_yprintf(int line, int color, int allign, const char *fmt, ...)
	__attribute__((__format__(__printf__,4,5)));

typedef struct ElevatorTask_t {
	int dest;
	int src;
} ElevatorTask_t;

ElevatorTask_t *elevatorTask;

SemaphoreHandle_t LCDSemaphore;

QueueHandle_t elevatorQueue;
QueueHandle_t animQueue;

int elevator_location = 0;


/***********************************************************************************************************
 * ANIMATION
 *
 * Framerate is 30 fps
 *
 * it is assumed, that the elevator takes ~1 second to get from one floor to the other
 * hence the animation taking 1 second or 30 frames
 *
 * the elevator task waits in the vTaskDelay() until the animation is completed
 */

/***********************************************************************************************************
 *
 */
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

    /* Create a queue capable of containing 10 pointers to ElevatorTask_t structures. */
    elevatorQueue = xQueueCreate(10, sizeof(ElevatorTask_t));
    animQueue = xQueueCreate(2, sizeof(ElevatorTask_t));   // hold only 1 element

    TIM2_InitTimer(6);

    // this is the spot where the elevator would get it's actual position from at boot
    // eg. after power outage or turned off state
    elevator_location = 0;

	xTaskCreate(ElevatorTask, "ElvTask",  (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 3), NULL);
	xTaskCreate(ButtonTask, "BtnTask",  (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 2), NULL);
	xTaskCreate(AnimationTask, "AnimTask",  (configMINIMAL_STACK_SIZE + 256), NULL, (tskIDLE_PRIORITY + 4), NULL);

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

/***********************************************************************************************************
 *
 */
static void AnimationTask(__attribute__ ((unused)) void *pvParameters)
{
	// this task is called with an update rate of 30 Hz from TIM2 --> 30 fps

	extern SemaphoreHandle_t TimerSemaphore;
	ElevatorTask_t newAnimTask;
	newAnimTask.src = 0;
	newAnimTask.dest = 0;

	int lcdx = BSP_LCD_GetXSize();
	int lcdy = BSP_LCD_GetYSize();
	char text[5];

	int elv_xpos = lcdx - (lcdx/4);
	int elv_width = (lcdx/4)-30;
	int elv_height = (lcdy/ELEVATOR_FLOORS)-10;
	int elv_ydist = ELEVATOR_TOP_FLOOR*(lcdy/ELEVATOR_FLOORS);

	// animation variables
	int frm_distance = 0;
	int busy = 0;

	while (1) {
		while(xSemaphoreTake(TimerSemaphore, (TickType_t)1) != pdTRUE ){
			vTaskDelay(1); // wait for new frame
		}

		lcd_yprintf(0, LCD_COLOR_LIGHTGRAY, CENTER_MODE, "Elevator");

		if(LCDSemaphore != NULL){
			// ask for permission to write to LCD
			if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){

				// draw lift
				BSP_LCD_SetTextColor(LCD_COLOR_LIGHTGRAY);
				BSP_LCD_FillRect(elv_xpos, 5+elevator_location+elv_ydist, elv_width, elv_height );

				BSP_LCD_SetTextColor(LCD_COLOR_GRAY);
				// draw floor lines and add floor numbers
				BSP_LCD_DrawHLine(lcdx - lcdx/4, 1, lcdx/4);
				for(int i=0; i<ELEVATOR_FLOORS; i++){
					BSP_LCD_DrawHLine(lcdx - lcdx/4, lcdy/ELEVATOR_FLOORS*i , lcdx/4);
					snprintf(text, sizeof(text), "%d", ELEVATOR_TOP_FLOOR-i);
					BSP_LCD_DisplayStringAt(0, (10 +lcdy/ELEVATOR_FLOORS*i), text, RIGHT_MODE);
				}

				//
				if(animQueue != 0){
					// render next frame
					// Receive an item from a queue without removing the item from the queue.
					if(busy == 0){
						xQueuePeek(elevatorQueue, &( newAnimTask ), ( TickType_t ) 10 );
						busy = 1;
						frm_distance;
						// TODO
						/**
						 * calculate distance,
						 * use x seconds and 30 fps as 0 - 100% to convert animation time to progress
						 * enter grogress along with distance into easing function
						 * animate lift
						 *
						 * at the end uptade elevator_position to new position
						 * and clear the animQueue
						 */
					}

				}

				xSemaphoreGive(LCDSemaphore);
			} else {
				// LCD resource is busy
			}
		}

		HAL_GPIO_TogglePin(LD_GPIO_PORT, LD4_RED);
		vTaskDelay(1);
	}

}

/***********************************************************************************************************
 *
 */
static void ElevatorTask(__attribute__ ((unused)) void *pvParameters)
{
	ElevatorTask_t currentTask;
	ElevatorTask_t animTask;

	while (1) {
		if(elevatorQueue != 0){
			// Receive a message on the created queue.  Block for 10 ticks if a
			// message is not immediately available.
			if( xQueueReceive( elevatorQueue, &( currentTask ), ( TickType_t ) 10 ) )
			{
				if(animQueue != 0){
					lcd_yprintf(1, LCD_COLOR_BLUE, LEFT_MODE, "animation   ", currentTask.src, currentTask.dest);
				} else {
					if(currentTask.src != elevator_location){
						// elevator is not at source yet, create new task to first bring elevator to source floor
						animTask.src = elevator_location;
						animTask.dest = currentTask.src;
						xQueueSendToBack(animQueue,  ( void * ) &animTask, ( TickType_t ) 0);
						lcd_yprintf(1, LCD_COLOR_ORANGE, LEFT_MODE, "(%d)-->(%d)  ", animTask.src, animTask.dest);
					} else {
						// elevator is in floor of event origin.. execute actual task
						animTask.src = elevator_location;
						animTask.dest = currentTask.src;
						xQueueSendToBack(animQueue,  ( void * ) &animTask, ( TickType_t ) 0);
						lcd_yprintf(1, LCD_COLOR_BLUE, LEFT_MODE, "(%d)-->(%d)  ", animTask.src, animTask.dest);
					}
				}

			} else {
				lcd_yprintf(1, LCD_COLOR_BLACK, LEFT_MODE, "standby... ");
			}
		}
		BSP_LED_Toggle(LD3_GREEN);
		vTaskDelay(1);
	}
}


/***********************************************************************************************************
 *
 */
float easeInOutCubic(float t, float b, float c, float d) {
	t /= d/2;
	if (t < 1) return c/2*t*t*t + b;
	t -= 2;
	return c/2*(t*t*t + 2) + b;
}


/***********************************************************************************************************
 *
 */
static void ButtonTask(__attribute__ ((unused)) void *pvParameters)
{
	uint8_t btn_old = 0, btn_new = 0;
	int seed = TIM2->CNT;

	while (1) {
		btn_new = BSP_PB_GetState(BUTTON_KEY);
		if(btn_new > btn_old){
			// button pressed
			/* Send a struct object.  Don't block if the queue is already full. */
			seed = (int)TIM2->CNT;
			ElevatorTask_t newTask;
			newTask.dest = (rand_r(&seed) % (ELEVATOR_FLOORS)) + ELEVATOR_GROUND_FLOOR;  seed++;
			newTask.src = (rand_r(&seed) % (ELEVATOR_FLOORS)) + ELEVATOR_GROUND_FLOOR;

			xQueueSendToBack(elevatorQueue, ( void * ) &newTask, ( TickType_t ) 0);
		}
		vTaskDelay(10);
		btn_old = btn_new;
	}
}

