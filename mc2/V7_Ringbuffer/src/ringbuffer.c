

#include "ringbuffer.h"
// Wie im Beispiel V5_IST (Timer)
#include "FreeRTOS.h"
#include "semphr.h"

Ringbuf_t ringbuf;

SemaphoreHandle_t UartSemaphore;

void rb_put(char ch)
{
	ringbuf.buf[ringbuf.put_ix] = ch;
	ringbuf.put_ix = (ringbuf.put_ix +1) % (sizeof(ringbuf.buf)/sizeof(char));
	ringbuf.n = ringbuf.n +1;

	if(ch == '\r'){
		portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
		if (UartSemaphore != NULL)
			xSemaphoreGiveFromISR(UartSemaphore, &higherPriorityTaskWoken);
		/* If xHigherPriorityTaskWoken was set to true you
		we should yield.  The actual macro used here is
		port specific.
		https://www.freertos.org/a00124.html */
		portYIELD_FROM_ISR( higherPriorityTaskWoken );  // YEET!
		/* This also reduces the latency from ISR to IST from <1ms to ~10us	 */
	}
}

char rb_get(void)
{
	char a;
	a = ringbuf.buf[ringbuf.get_ix];
	ringbuf.get_ix = (ringbuf.get_ix +1) % (sizeof(ringbuf.buf)/sizeof(char));
	ringbuf.n = ringbuf.n -1;
	return a;
}

int8_t rb_status(void)
{
	if(ringbuf.n > (sizeof(ringbuf.buf)/sizeof(char))){
		rb_clear();
		return -1;
	}
	return ringbuf.n;
}

void rb_clear(void)
{
	uint8_t len = (sizeof(ringbuf.buf)/sizeof(char));
	ringbuf.n = 0;
	ringbuf.put_ix = 0;
	ringbuf.get_ix = 0;
	for(uint8_t i = 0; i<len; i++){
		ringbuf.buf[i] = 0;
	}
}

void rb_init(void)
{
	UartSemaphore = xSemaphoreCreateBinary();   // ISRs do not use Mutex !!!
	// xSemaphoreGive(UartSemaphore);  // do not give --> nothing received yet
	rb_clear();
}
