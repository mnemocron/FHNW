/* (c) Matthias Meier, 2018
 *  Template for mc2 V6 Ringbuffer:
 *  Setup and prepare UART1 to handle receive interrupts.
 *
 *  Remark:
 *  The STLink-v2 debug interface adapter on the stm32f429-disc1 board
 *  supports beside the JTAG/SWD Debug interface a async serial UART interface
 *  which is wired on the board to UART1 of the stm32f429 microcontroller.
 *  The STLink-v2 adapter converts the async serial interface data
 *  to a USB CDC serial device class interface which appears on the PC as a
 *  Virtual COM Port (VCP).
 */

#include "stm32f4xx_hal.h"
#include "stm32f4xx_hal_uart.h"
#include "stm32f429i_discovery.h"
#include "ringbuffer.h"

/* Following #defines are taken from the stm32f429 uart example project */
/* Definition for USARTx Pins */
#define USARTx                           USART1
#define USARTx_TX_PIN                    GPIO_PIN_9
#define USARTx_TX_GPIO_PORT              GPIOA
#define USARTx_TX_AF                     GPIO_AF7_USART1
#define USARTx_RX_PIN                    GPIO_PIN_10
#define USARTx_RX_GPIO_PORT              GPIOA
#define USARTx_RX_AF                     GPIO_AF7_USART1

/* Definition for USARTx clock resources */
#define USARTx_CLK_ENABLE()              __HAL_RCC_USART1_CLK_ENABLE();
#define USARTx_RX_GPIO_CLK_ENABLE()      __HAL_RCC_GPIOA_CLK_ENABLE()
#define USARTx_TX_GPIO_CLK_ENABLE()      __HAL_RCC_GPIOA_CLK_ENABLE()

#define USARTx_FORCE_RESET()             __HAL_RCC_USART1_FORCE_RESET()
#define USARTx_RELEASE_RESET()           __HAL_RCC_USART1_RELEASE_RESET()

/* Definition for USARTx's NVIC */
#define USARTx_IRQn                      USART1_IRQn
#define USARTx_IRQHandler                USART1_IRQHandler

UART_HandleTypeDef UsartHandle;

/* Following function HAL_UART_MspInit() initializes the corresponding
 * GPIO Ports & Pins used for the UART.
 * The function is called by HAL_UART_Init() in stm32f4xx_hal_uart.c
 * (Msp means "MCU Support Package" --> pin allocation, enabling of clocks, etc.)
 */
void HAL_UART_MspInit(UART_HandleTypeDef *huart)
{
	UNUSED(huart);
	GPIO_InitTypeDef  GPIO_InitStruct;

	/* the GPIO ports on which the TX/RX GPIOs are have to be clocked... */
	USARTx_TX_GPIO_CLK_ENABLE();
	USARTx_RX_GPIO_CLK_ENABLE();

	/* ... and the TX/RX GPIO pins configured accordingly */
	/* UART TX GPIO pin configuration  */
	GPIO_InitStruct.Pin       = USARTx_TX_PIN;
	GPIO_InitStruct.Mode      = GPIO_MODE_AF_PP;
	GPIO_InitStruct.Pull      = GPIO_NOPULL;
	GPIO_InitStruct.Speed     = GPIO_SPEED_FAST;
	GPIO_InitStruct.Alternate = USARTx_TX_AF;

	HAL_GPIO_Init(USARTx_TX_GPIO_PORT, &GPIO_InitStruct);

	/* UART RX GPIO pin configuration  */
	GPIO_InitStruct.Pin = USARTx_RX_PIN;
	GPIO_InitStruct.Alternate = USARTx_RX_AF;

	HAL_GPIO_Init(USARTx_RX_GPIO_PORT, &GPIO_InitStruct);

	/* Enable USART clock */
	USARTx_CLK_ENABLE();

}

/* Initialization and activation of UART1
 * This function must be called in main() initialization.
 */
void InitUart(void)
{
	UsartHandle.Instance = USARTx;
	UsartHandle.Init.BaudRate     = 115200;
	UsartHandle.Init.WordLength   = UART_WORDLENGTH_8B;
	UsartHandle.Init.StopBits     = UART_STOPBITS_1;
	UsartHandle.Init.Parity       = UART_PARITY_NONE;
	UsartHandle.Init.HwFlowCtl    = UART_HWCONTROL_NONE;
	UsartHandle.Init.Mode         = UART_MODE_TX_RX;
	UsartHandle.Init.OverSampling = UART_OVERSAMPLING_16;

	/* HAL_UART_Init() sets above USART parameters and calls HAL_UART_MspInit() */
	// stm32f4xx_hal_uart.c MUSS IM VOM BUILD INCLUDED SEIN !!
	HAL_UART_Init(&UsartHandle);

	/* Enable RX not empty interrupt */
	__HAL_USART_ENABLE_IT(&UsartHandle, USART_IT_RXNE);

	/*Configure the USART1 IRQ priority */
	HAL_NVIC_SetPriority(USARTx_IRQn, 0x0f ,0U);

	/* Enable the USART1 global Interrupt */
	HAL_NVIC_EnableIRQ(USARTx_IRQn);

}


void USART1_IRQHandler(void)
{
	BSP_LED_Toggle(LED3);
	if (UsartHandle.Instance->SR & USART_SR_RXNE) {
		char ch = (uint8_t)(UsartHandle.Instance->DR);
		/* send back echo (via TxD line) */
		UsartHandle.Instance->DR = ch;
		rb_put(ch);
	}
}

