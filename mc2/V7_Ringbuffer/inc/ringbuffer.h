
#include <stdint.h>

#ifndef __RINGBUF_H
#define __RINGBUF_H

typedef struct Ringbuf_t {
	char buf[16];
	uint8_t put_ix;
	uint8_t get_ix;
	uint8_t n;
} Ringbuf_t;


void rb_put(char);
char rb_get(void);
int8_t rb_status(void); // signed because: -1 = overflow
void rb_clear(void);
void rb_init(void);

#endif // __RINGBUF_H

