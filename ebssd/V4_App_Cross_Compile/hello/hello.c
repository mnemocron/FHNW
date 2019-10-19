
#include <stdio.h>     // printf
#include <unistd.h>    // gethostname



int main() {
	char host[30];
	gethostname(host, sizeof(host)/sizeof(char));
	printf("%s\n", host);
}




