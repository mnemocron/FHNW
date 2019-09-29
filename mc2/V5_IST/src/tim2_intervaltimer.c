/**
  ******************************************************************************
  * @file:   tim2_intervaltimer.c (Vorlage)
  * @author  (c) 2018, Matthias Meier
  * @brief   Template for Interrupt Service Thread
  *
  *          Initialisation of 32bit Timer TIM2 for generating periodic interrupts 
  *          remark: loosly derived from Cube HAL stm32f4xx_hal_timebase_tim_template.c
  *    
  ******************************************************************************
  */

#include "stm32f4xx_hal.h"

#include "FreeRTOS.h"
#include "semphr.h"

#define LD4_RED GPIO_PIN_14
#define LD_GPIO_PORT GPIOG

#define TIM_PERIOD_US  254321	// ca. 1/4 sec, but intentionally not exactly!

SemaphoreHandle_t TimerSemaphore;

int TimerCountAtISR;
uint64_t ClockfreqTIM2 = 0;

/** 
 *  TIM2_InitTimer() -- initialize TIM2 for generating periodic interrupts 
 */
HAL_StatusTypeDef TIM2_InitTimer(uint32_t IrqPriority)
{
  TimerSemaphore = xSemaphoreCreateBinary();   // ISRs do not use Mutex !!!
  xSemaphoreGive(TimerSemaphore);
  TimerCountAtISR = 0;

  TIM_HandleTypeDef        TimHandle={};
  RCC_ClkInitTypeDef    clkconfig;
  uint32_t              uwAPB1Prescaler = 0U;
  uint32_t              pFLatency;

  /*Configure the TIMER IRQ priority */
  HAL_NVIC_SetPriority(TIM2_IRQn, IrqPriority ,0U);
  
  /* Enable the TIMER global Interrupt */
  HAL_NVIC_EnableIRQ(TIM2_IRQn);
  
  /* Enable TIMER clock */
  __HAL_RCC_TIM2_CLK_ENABLE();
  
  /* Get clock configuration */
  HAL_RCC_GetClockConfig(&clkconfig, &pFLatency);
  
  /* Get APB1 prescaler */
  uwAPB1Prescaler = clkconfig.APB1CLKDivider;
  
  /* Compute TIMER clock */
  if (uwAPB1Prescaler == RCC_HCLK_DIV1) 
  {
    ClockfreqTIM2 = HAL_RCC_GetPCLK1Freq();
  }
  else
  {
    ClockfreqTIM2 = 2*HAL_RCC_GetPCLK1Freq();
  }
  
  /* Initialize TIMER */
  TimHandle.Instance = TIM2;
  
  /* Initialize TIMx peripheral as follow:
  + Prescaler = 0 -> full speed (no prescaling)
  + ClockDivision = 0
  + Counter direction = Up
  + Period = according TIM_PERIOD_US (microseconds) defined at top
  */
  TimHandle.Init.Prescaler = 0;
  TimHandle.Init.Period = ClockfreqTIM2/1000000U * TIM_PERIOD_US - 1;
  TimHandle.Init.ClockDivision = 0U;
  TimHandle.Init.CounterMode = TIM_COUNTERMODE_UP;


  if(HAL_TIM_Base_Init(&TimHandle) == HAL_OK)
  {
    /* Start the TIM time Base generation in interrupt mode */
    return HAL_TIM_Base_Start_IT(&TimHandle);
  }
  
  /* Return function status */
  return HAL_ERROR;
}


/**
 * TIM2_IRQHandler() -- referenced in the vector table of file startup/startup_stm32f429xx.s
 */
void TIM2_IRQHandler(void)
{
	TimerCountAtISR = TIM2->CNT;  // measure time of ISR event
	// toggle red LED
	HAL_GPIO_TogglePin(LD_GPIO_PORT, LD4_RED);

	portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
	if (TimerSemaphore != NULL)
		xSemaphoreGiveFromISR(TimerSemaphore, &higherPriorityTaskWoken);

	/* If xHigherPriorityTaskWoken was set to true you
	we should yield.  The actual macro used here is
	port specific.
	https://www.freertos.org/a00124.html */
	portYIELD_FROM_ISR( higherPriorityTaskWoken );  // YEET!
	/* This also reduces the latency from ISR to IST from <1ms to ~10us	 */

	// Clear TIMER Update Event Flag (otherweise the interrupt will occure again and again...)
	TIM2->SR = ~TIM_IT_UPDATE;
	asm("nop; nop; nop");
}

/*** END OF FILE ***/
