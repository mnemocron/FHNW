
obj-m=mod_hrtimer.o

KERNEL_SRC=/lib/modules/$(shell uname -r)/build

all:
	make -C $(KERNEL_SRC) M=$(PWD) modules
	rm -rf *.o *.mod.c modules.order Module.symvers

clean:
	make -C $(KERNEL_SRC) M=$(PWD) clean

# indents in rules about have to be TAB characters!
