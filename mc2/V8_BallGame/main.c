// Simon Burkhardt

/**
  ******************************************************************************
  * @file    main.c
  * @author  Simon Burkhardt
  ******************************************************************************
*/

/**
 * 
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
#include "stdlib.h"
#include "stm32f429i_discovery_ts.h"

#define LD3_GREEN GPIO_PIN_13
#define LD4_RED GPIO_PIN_14
#define LD_GPIO_PORT GPIOG

#define BALL_RADIUS 10

typedef struct Pos_t {
	int16_t x;
	int16_t y;
} Pos_t;

enum { POS_VALID=0, BOUNCE_TOP, BOUNCE_BOTTOM, BOUNCE_LEFT, BOUNCE_RIGHT };

static void BallTask(void *pvParameters);
static void TouchTask(void *pvParameters);
int PositionIsValid(Pos_t pos);

// von Aufgabestellung abweichend weil:
// @param allign nicht gefordert ist
// darum verschiebt sich die Parameter Kontrolle durch den Compiler von index 3,4 auf 4,5
static int lcd_yprintf(int line, int color, int allign, const char *fmt, ...)
	__attribute__((__format__(__printf__,4,5)));

SemaphoreHandle_t LCDSemaphore;
SemaphoreHandle_t BallHitSemaphore;

QueueHandle_t BallPosQueue;

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
	BallHitSemaphore = xSemaphoreCreateBinary();
	xSemaphoreGive(BallHitSemaphore);  // initiales Setzen um Ball freizugeben

	BallPosQueue = xQueueCreate(2, sizeof(Pos_t));

    BSP_LED_Init(LED3);
    BSP_LED_Init(LED4);
    BSP_PB_Init(BUTTON_KEY, BUTTON_MODE_GPIO);

    TIM2_InitTimer(6);

	xTaskCreate(BallTask, "BallTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 2), NULL);
	xTaskCreate(TouchTask, "TouchTask", (configMINIMAL_STACK_SIZE + 80), NULL, (tskIDLE_PRIORITY + 3), NULL);

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

static void TouchTask(__attribute__ ((unused)) void *pvParameters)
{
	TS_StateTypeDef ts_state;
	BSP_TS_Init(BSP_LCD_GetXSize(), BSP_LCD_GetYSize());
	Pos_t nowpos;        // Ballposition
	Pos_t OldTouchPos;   // vorherige touch Position
	uint8_t touched = 0; // wenn zu Beginn noch nicht berührt wurde
	int ergebnisvariable = 0;  // HIGHSCORE!

	while (1) {
		xQueueReceive( BallPosQueue, &( nowpos ), ( TickType_t ) 10 );  // Ballposition lesen
		BSP_TS_GetState(&ts_state);   // Touchscreen lesen
		if(touched){  // nur wenn zuvor schon berührt wurde muss...
			// vorherige Position gelöscht werden (weiss)
			if(LCDSemaphore != NULL){
				// ask for permission to write to LCD
				if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
					BSP_LCD_SetTextColor(LCD_COLOR_WHITE);
					BSP_LCD_FillCircle(OldTouchPos.x, OldTouchPos.y, BALL_RADIUS);
					xSemaphoreGive(LCDSemaphore);
				}
			}
		}
		if(ts_state.TouchDetected){   // touch erkannt
			touched = 1;
			OldTouchPos.x = ts_state.X;
			OldTouchPos.y = ts_state.Y;
			// Position validieren, nur für rotes Zeichnungsobjekt, nicht für Treffererkennung
			if(PositionIsValid(OldTouchPos) != POS_VALID){
				if(OldTouchPos.x < BALL_RADIUS)
					OldTouchPos.x = BALL_RADIUS;
				if(OldTouchPos.x > (BSP_LCD_GetXSize()-1) )
					OldTouchPos.x = BSP_LCD_GetXSize()-BALL_RADIUS-1;
				if(OldTouchPos.y < BALL_RADIUS)
					OldTouchPos.y = BALL_RADIUS;
				if(OldTouchPos.y > (BSP_LCD_GetYSize()-1) )
					OldTouchPos.y = BSP_LCD_GetYSize()-BALL_RADIUS-1;
			}
			// neue Position mit rotem Kreis zeichnen
			if(LCDSemaphore != NULL){
				// ask for permission to write to LCD
				if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
					BSP_LCD_SetTextColor(LCD_COLOR_RED);
					BSP_LCD_FillCircle(OldTouchPos.x, OldTouchPos.y, BALL_RADIUS);
					xSemaphoreGive(LCDSemaphore);
				}
			}
			// wurde Ball berührt? (innerhalb von TouchDetected)
			// mit etwas "Unschärfe"
			// Treffererkennung mit den realen Touch Werten
			if ( (ts_state.X < (nowpos.x + BALL_RADIUS/2)) && (ts_state.X > (nowpos.x - BALL_RADIUS/2)) ) {
				if ( (ts_state.Y < (nowpos.y + BALL_RADIUS/2)) && (ts_state.Y > (nowpos.y - BALL_RADIUS/2)) ) {
					ergebnisvariable ++;  // hit !!
					xSemaphoreGive(BallHitSemaphore);  // signal that the Ball has been caught
				}
			}
		}


		lcd_yprintf(0, LCD_COLOR_DARKGREEN, CENTER_MODE, "Hits: %d", ergebnisvariable);
		// lcd_yprintf(1, LCD_COLOR_GRAY, LEFT_MODE, "B.x=%d B.y=%d   ", nowpos.x, nowpos.y);
		// lcd_yprintf(2, LCD_COLOR_GRAY, LEFT_MODE, "T.x=%d T.y=%d   ", ts_state.X, ts_state.Y);

	}
}

static void BallTask(__attribute__ ((unused)) void *pvParameters)
{
	HAL_GPIO_WritePin(LD_GPIO_PORT, LD4_RED, 0);   // turn off
	int seed = TIM2->CNT;
	Pos_t newpos;
	Pos_t dPos;
	newpos.x = 2*BALL_RADIUS;  // Initialwert
	newpos.y = 2*BALL_RADIUS;

	while (1) {
		if(BallHitSemaphore != NULL){
			// ask for permission to write to LCD
			if(xSemaphoreTake(BallHitSemaphore, (TickType_t)20) == pdTRUE ){
				// alte Position löschen (weiss)
				if(LCDSemaphore != NULL){
					// ask for permission to write to LCD
					if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
						BSP_LCD_SetTextColor(LCD_COLOR_WHITE);
						BSP_LCD_FillCircle(newpos.x, newpos.y, BALL_RADIUS);
						xSemaphoreGive(LCDSemaphore);
					}
				}
				// neue Zufallsposition generieren
				seed = (int)TIM2->CNT;
				newpos.x = (rand_r(&seed) % (BSP_LCD_GetXSize()-1-BALL_RADIUS) + BALL_RADIUS);  seed++;
				newpos.y = (rand_r(&seed) % (BSP_LCD_GetYSize()-1-BALL_RADIUS) + BALL_RADIUS);  seed++;
				dPos.x = (rand_r(&seed) % (5) -2);  seed++;
				dPos.y = (rand_r(&seed) % (5) -2);
			}
			// 20ms later...

			// alte Position löschen (weiss)
			// muss nach den 20ms gelöscht werden, da gleich die neue Position in blau gezeichnet wird
			// wird vor dem delay gelöscht, ist dominiert das weiss für die grosse Zeit der 20ms
			if(LCDSemaphore != NULL){
				// ask for permission to write to LCD
				if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
					BSP_LCD_SetTextColor(LCD_COLOR_WHITE);
					BSP_LCD_FillCircle(newpos.x, newpos.y, BALL_RADIUS);
					xSemaphoreGive(LCDSemaphore);
				}
			}

			newpos.x += dPos.x;
			newpos.y += dPos.y;
			int pos_valid = PositionIsValid(newpos);  // Boundry check
			switch(pos_valid){
				case BOUNCE_RIGHT:
				case BOUNCE_LEFT:
					dPos.x = -dPos.x;
					break;
				case BOUNCE_TOP:
				case BOUNCE_BOTTOM:
					dPos.y = -dPos.y;
					break;
				default:
					break;
			}
			// new pos is still not valid, change pos until valid
			while( PositionIsValid(newpos) != POS_VALID ){
				newpos.x += dPos.x;
				newpos.y += dPos.y;
			}
			xQueueSendToBack(BallPosQueue, (void *) &newpos, ( TickType_t) 0);  // jeweils neuste Position an touchTask senden

			if(LCDSemaphore != NULL){
				// ask for permission to write to LCD
				if(xSemaphoreTake(LCDSemaphore, (TickType_t)10) == pdTRUE ){
					BSP_LCD_SetTextColor(LCD_COLOR_BLUE);
					BSP_LCD_FillCircle(newpos.x, newpos.y, BALL_RADIUS);
					xSemaphoreGive(LCDSemaphore);
				}
			}
		}
	}
}

int PositionIsValid(Pos_t pos){
	if ( (pos.x - BALL_RADIUS) < 0 )
		return BOUNCE_LEFT;
	if ( (pos.y - BALL_RADIUS) < 0 )
		return BOUNCE_TOP;
	if ( (pos.x + BALL_RADIUS) > (BSP_LCD_GetXSize()-1) )
		return BOUNCE_RIGHT;
	if ( (pos.y + BALL_RADIUS) > (BSP_LCD_GetYSize()-1) )
		return BOUNCE_BOTTOM;
	return POS_VALID;
}

