#include <stdlib.h>    // system()
#include <stdio.h>     // printf
#include <unistd.h>    // gethostname
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <error.h> 		// generate error output
#include <errno.h>

void on(void);
void off(void);
int init_led(int);
void deinit_led(void);
void set_led(int, int);
void print_html_begin(void);
void print_html_end(void);
int read_led(int);

#define GPIO_LED "/sys/class/gpio/gpio200/value"
#define GPIO_BTN "/sys/class/gpio/gpio191/value"

int fd_led;
int led_state;

int main( int argc, char **argv ) {
	print_html_begin();

	char *data;
	data = getenv("QUERY_STRING");
	int value = 4;
	if(data != NULL){
		// printf("QUERY_STRING=\"%s\"\n", data);
		if(sscanf(data, "val=%d", &value) != 1){

		} else {
			// printf("val = %d\n", value);
			if(value > 0) value = 1;
			fd_led = init_led(O_WRONLY);
			if(fd_led < 0){
				error(-1, errno, "Unable to open LED");
			}
			set_led(fd_led, value);
			/* @bug sh: device or resource busy */
			/* @bug access to sys/class files only works
			 when httpd is started in root as user mode */
			close(fd_led);
		}
	}

	fd_led = init_led(O_RDONLY);
	led_state = 0;
	led_state = read_led(fd_led);
	printf("<p>The LED is: %d</p>\n", led_state); 
	close(fd_led);

	print_html_end();
	close(fd_led);
	deinit_led();
}

void print_html_begin(void)
{
	printf("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n"); 
	printf("<html>\n");
	printf("<head>\n");
	printf("<title>Welcome on the Wandboard webserver!</title>\n");
	printf("</head>\n");
	printf("<body> \n");
	printf("<h1>have fun!</h1>\n");

	printf("<h2>Very simple and very unsecure CGI script</h2> \n");
	printf("<br> \n");
	printf("<form name=\"input\" action=\"/cgi-bin/show-procinfo.cgi\" method=\"get\"> \n");
	printf("<input type=\"radio\" name=\"info\" value=\"cpuinfo\" checked > CPU Info<br> \n");
	printf("<input type=\"radio\" name=\"info\" value=\"cmdline\" > Kernel Command Line<br>\n"); 
	printf("<br> \n");
	printf("<input type=\"submit\" value=\"Show\"> \n");
	printf("</form>\n");

	printf("<hr>\n<h2>LED Control</h2> \n");
}

void print_html_end(void)
{
	printf("<br> \n");
	printf("<form name=\"input\" action=\"/cgi-bin/led.cgi\" method=\"get\"> \n");
	
	if(led_state){
		printf("<input type=\"radio\" name=\"val\" value=\"1\" checked > ON <br> \n");
		printf("<input type=\"radio\" name=\"val\" value=\"0\" > OFF <br> \n");
	} else {
		printf("<input type=\"radio\" name=\"val\" value=\"1\" > ON <br> \n");
		printf("<input type=\"radio\" name=\"val\" value=\"0\" checked > OFF <br> \n");
	}
	printf("<br>\n");
	printf("<input type=\"submit\" value=\"Set\"> \n");
	printf("</form>\n");
	printf("</body>\n");
	printf("</html>\n");
}

void set_led(int fd, int v)
{
	char buf[] = "0\n";
	if(v)
		buf[0] = '1';

	int er;
	er = write(fd, &buf, sizeof(buf)/sizeof(char));
	if(er < 0)
		error(-1, errno, "Unable to write to GPIO 200\n");
}

int read_led(int fd)
{
	char buf[10];
	int er;
	lseek(fd, 0, SEEK_SET); // set file descriptor to start of file
	er = read(fd, &buf, sizeof(buf)/sizeof(char));
	if(er < 0)
		error(-1, errno, "Error reading GPIO 200");

	if(buf[0] == '1')
		return 1;
	else if(buf[0] == '0')
		return 0;
	return -1;
}

int init_led(int mode)
{
	system("echo '200' > /sys/class/gpio/export\n");
	system("echo 'out' > /sys/class/gpio/gpio200/direction\n");
	system("echo '0' > /sys/class/gpio/gpio200/value\n");

	int fd = open(GPIO_LED, mode);
	if(fd_led < 0){
		error(-1, errno, "Unable to open GPIO 200\n");
	}
	return fd;
}

void deinit_led(void)
{
	system("echo '200' > /sys/class/gpio/unexport\n");
}
