
CC=arm-linux-gnueabihf-gcc
CFLAGS=-mthumb -march=armv7-a
CFLATS+= -g -Wall

APP=tcp_server

all:$(APP)

$(APP): $(APP).c
	$(CC) $(CFLAGS) -o $(APP) $(APP).c

.PHONY: clean
clean:
	rm -f $(APP)


.PHONY: install
install:
	scp ./$(APP) root@192.168.254.254:/usr/bin/$(APP)

