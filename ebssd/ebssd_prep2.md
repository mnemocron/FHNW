# ebssd

### Android




---

Kernelmodule with Deviceinterface cannot set permissions on the node

modprobe vs. insmod
modprobe handles dependencies and uses insmod to load .ko files

when using insmod...
Kernel-**Macro** Function `module_init()`

to create Kernel Module
`obj-m=mod_hrtimer.o` from `mod_hrtimer.ko`
`obj-m=xyz.o` from `xyz.ko`

where is the flash translation layer
on the flash device itself as firmware
contains erasing, wear leveling and ECC
FTL in block device driver possible

FTL contains function to erase blocks

best Filesystem for flash?
Log Structured!

no wear leveling necessary?
Log Structured
Journaling FS
FTL

wear leveling most efficient
almost empty partition

### Socket Functions

- int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
  + The argument addr is a pointer to a sockaddr structure. This structure is  filled in with the address of the peer socket, as known to the communications layer.
  + The addrlen argument is a value-result argument:
- int **listen**(int sockfd, int backlog);
  + The backlog argument defines the **maximum length** to which the queue of pending **connections** for sockfd may grow.
- int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

### Wandboard Timer Delay

Timer-Callback-Routine: maximale Latenzzeit: im Bereich 10us..100us.

Tasksync
einseitige Tasksynchronisation


Hardware Config of Plattform is in Device Tree (dtb)

`copy_from_userspace` moves data from user to kernelspace

Python Regex
```python
import re
data="bla=39794"
num=re.search('([0-9]+)',data)
print(num.group(0))
```

---

CGI Scripts as
- seperate child process?
- shared lib (no)
- thread of webserver?


Wear Leveling
- static is better than dynamic?
dynamic = only on rewrite, not applied to read only blocks
static = all blocks


when do no syscalls happen?
- unbuffered file io
- buffered file io
- **both** <<----- always


what is a device tree?


page faults are handled in Kernel ?

fast GPIO access when
- buffered
- unbuffered  <<-- yes?
- both

syscall mmap cannot do
- access periph reg
- map file to virtual mem of app
- asynch interrupt (interrupt)   <----- 


greatest advantage of paging when
- max address space 4GB
- using shared libs
- small part of max space eg. 1MB


unbuffered io to real file
- no buffering
- buffering in kernel
- buffering in library  <---- Page Cache & IO Layer sind doch library??


what is ioctl()
für treiberspezifische Einstellmöglichkeiten

what address space do shared libs use?
their own, hence "shared" multiple processes use the same physical address space of the library

fastest way to access peripheral regs?
mmap ?

on demand paging? static / dynamic libraries
only page when page faults happen



which libc on wandboard?
glibc