#include <stdlib.h>    // system()
#include <stdio.h>     // printf
#include <unistd.h>    // gethostname



void on(void);
void off(void);
void init_led(void);
void deinit_led(void);
void init_button(void);

int main() {
	printf("Blink");
	init_led();
	for(int i=0; i<10; i++){
		on();
		usleep(200000);
		off();
		usleep(200000);
		system("cat /sys/class/gpio/gpio191/value");
	}
	deinit_led();
}


void on(void)
{
	system("echo '1' > /sys/class/gpio/gpio200/value");
}

void off(void)
{
	system("echo '0' > /sys/class/gpio/gpio200/value");
}

void init_led(void)
{
	system("echo '200' > /sys/class/gpio/export");
	system("echo 'out' > /sys/class/gpio/gpio200/direction");
	system("echo '0' > /sys/class/gpio/gpio200/value");
}

void deinit_led(void)
{
	system("echo '200' > /sys/class/gpio/unexport");
}

void init_button(void)
{
	system("echo '191' > /sys/class/gpio/export");
	system("echo 'in' > /sys/class/gpio/gpio191");
}

