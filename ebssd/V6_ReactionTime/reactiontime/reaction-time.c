#include <stdlib.h>    // system()
#include <stdio.h>     // printf
#include <unistd.h>    // gethostname
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <error.h> 		// generate error output
#include <errno.h>
#include <time.h>		// read time
#include <sys/time.h>	
#include <signal.h> 	// sigint handling
#include <poll.h>		// gpio polling

void on(void);
void off(void);
void init_led(void);
void deinit_led(void);
void init_btn(void);
void deinit_btn(void);
int read_btn(int);
void set_led(int, int);
void sigintHandler(int);

#define GPIO_LED "/sys/class/gpio/gpio200/value"
#define GPIO_BTN "/sys/class/gpio/gpio191/value"

int fd_led, fd_btn;  // global for sigintHandler

int main( int argc, char **argv ) {
	printf("Reaction Time Game\n\n");
	init_led();
	init_btn();
	signal(SIGINT, sigintHandler);

	// open LED pseudo file
	fd_led = open(GPIO_LED, O_WRONLY);
	if(fd_led < 0){
		error(-1, errno, "Unable to open GPIO 200");
	}
	// open BTN pseudo file
	fd_btn = open(GPIO_BTN, O_RDONLY);
	if(fd_btn < 0){
		error(-1, errno, "Unable to open GPIO 191");
	}

	struct timeval t_seed;
	int seed = 0;
	struct timespec t_start, t_stop;
	double accum;
	int btn_state = 1;
	int t_delay;
	struct pollfd fd_poll;
	fd_poll.fd = fd_btn;
	fd_poll.events = POLLPRI;
	fd_poll.revents = 0;

	struct timezone tz_dummy;
	tz_dummy.tz_minuteswest = 0;  // only relative time is important
	tz_dummy.tz_dsttime = 0;

	do{
		set_led(fd_led, 0);   // turn off

		// wait for 1..3 seconds
		gettimeofday(&t_seed, &tz_dummy);
		int sec = (int)t_seed.tv_sec;
		t_delay = rand_r(&sec)%2000000 + 1000000;
		usleep(t_delay);

		set_led(fd_led, 1);  	// turn on

		// get time of turn on
		clock_gettime(CLOCK_MONOTONIC, &t_start);

		/*
		// wait for button press
		btn_state = 1;
		while(btn_state == 1){
			usleep(1);
			btn_state = read_btn(fd_btn);
		}
		*/

		/* @bug: detects an edge when poll() is called for the first time */
		int rc = poll(&fd_poll, 1, 10000); // wait for max. 10s
		if(rc < 0)
			error(-1, errno, "Failed to poll GPIO 191");
		read_btn(fd_btn); // muss nochmal gelesen werden (?)


		// get time of button press
		clock_gettime(CLOCK_MONOTONIC, &t_stop);

		accum = ( t_stop.tv_sec - t_start.tv_sec ) * 1000000000.0f
		      + ( t_stop.tv_nsec - t_start.tv_nsec );
		accum /= 1000000000.0f;

		printf("Reaction Time: %.3f s\n", accum);
		
	}while(1);

	close(fd_led);
	close(fd_btn);

	deinit_led();
	deinit_btn();
}

/* on CTRL+C abort --> uninit led and button */
void sigintHandler(int sig_num)
{
	signal(SIGINT, sigintHandler);

	set_led(fd_led, 0);
	close(fd_led);
	close(fd_btn);
	deinit_led();
	deinit_btn();

	printf("\nThanks for playing :)\n");
	fflush(stdout);
	exit(0);
}

int read_btn(int fd)
{
	char buf[10];
	int er;
	lseek(fd, 0, SEEK_SET); // set file descriptor to start of file
	er = read(fd, &buf, sizeof(buf)/sizeof(char));
	if(er < 0)
		error(-1, errno, "Error reading GPIO 191");

	if(buf[0] == '1')
		return 1;
	else if(buf[0] == '0')
		return 0;
	return -1;
}

void set_led(int fd, int v)
{
	char buf[] = "0\n";
	if(v)
		buf[0] = '1';

	int er;
	er = write(fd, &buf, sizeof(buf)/sizeof(char));
	if(er < 0)
		error(-1, errno, "Unable to write to GPIO 200");
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

void init_btn(void)
{
	system("echo '191' > /sys/class/gpio/export");
	system("echo 'in' > /sys/class/gpio/gpio191/direction");
	system("echo 'falling' > /sys/class/gpio/gpio191/edge"); // enable falling edge interrupts
}

void deinit_btn(void)
{
	system("echo 'none' > /sys/class/gpio/gpio191/edge");
	system("echo '191' > /sys/class/gpio/unexport");
}
