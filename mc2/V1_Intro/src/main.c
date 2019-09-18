/**
  ******************************************************************************
  * @file    main.c
  * @author  Ac6
  * @version V1.0
  * @date    01-December-2013
  * @brief   Default main function.
  ******************************************************************************
*/


#include "stm32f4xx.h"
#include "stm32f429i_discovery.h"
			
#define LD3 GPIO_PIN_13
#define LD4 GPIO_PIN_14
#define LD_PORT GPIOG

int main(void)
{
	SystemInit();
	HAL_Init();
	BSP_LED_Init(LED3);
	BSP_LED_Init(LED4);

	uint8_t t_delay = 50;

	while(1){
		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD3);
		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD3);

		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD3);
		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD3);

		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD4);
		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD4);

		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD4);
		HAL_Delay(t_delay);
		HAL_GPIO_TogglePin(LD_PORT, LD4);
	}
}

/**
 * Aufgabe 5 "Entschlacken" der Build Konfiguration
 *
 * C:\Users\simon..main.c:22: undefined reference to `HAL_Init'
 * - Doppelklick auf HAL_Init
 * - im file Rechtsklick auf HAL_Init();
 * - Open Declaration F3
 * - stm32f4xx_hal.c wird geöffnet
 * - jetzt weiss man, dass stm32f4xx_hal.c beim Build nicht ausgeschlossen werden darf
 *
 */
