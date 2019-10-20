#include <stdint.h>

#ifndef __UART_H
#define __UART_H

void HAL_UART_MspInit(UART_HandleTypeDef *);
void InitUart(void);
void USART1_IRQHandler(void);

#endif // __UART_H
