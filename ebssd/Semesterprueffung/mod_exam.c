// Burkhardt Simon
/* Testvorlage ebssd 19hs */
/* Derived from: https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt */
 
#include <linux/module.h>
#include <linux/init.h>
#include <linux/device.h>

#include <linux/kthread.h>
#include <linux/delay.h>

MODULE_LICENSE("GPL");

static  char mybuf[100]="bla";
static DECLARE_WAIT_QUEUE_HEAD(wq); // Wait Queue
static int triggered=0;             // used as a binary Semaphore in the queue

int del_value;
int ms_value;
int latency1=0, latency2=0;

static s64 starttime_ns;
static s64 now_ns_thread, now_ns;

static int mythread(void *data)
{
    now_ns_thread = ktime_to_ns(ktime_get());  // .. bis Start des threads
    ms_value = (int)data;
    mdelay(ms_value);
    triggered = 1;  // hier setzen (nach Diskussion mit Dozenten) 
    wake_up_interruptible_sync(&wq);
    return 0;  // kill ?
}

static ssize_t show_myvalue(struct device *dev,
                  struct device_attribute *attr, char *buf)        /* function called when reading 'myvalue' e.g. by 'cat' */
{
    wait_event_interruptible(wq, triggered);    // warte auf Deblocking der der Semaphore in der Waitqueue
    triggered = 0;
    now_ns = ktime_to_ns(ktime_get());  // ... bis nach der Waitqueue
    latency2 = now_ns - starttime_ns;         // Latenz nach Waitqueue
    latency1 = now_ns_thread - starttime_ns;  // Latenz nach Start des Threads
    return sprintf(buf, "latency thread: %d us\nlatency write : %d us\n", latency1/1000, latency2/1000);
}

static ssize_t set_myvalue(struct device *dev,
                 struct device_attribute *attr,
                 const char *buf, size_t len)        /* function called when writing to 'myvalue' e.g. by 'echo' */
{
    sprintf(mybuf, "%s", buf); 
    sscanf(buf, "%d", &del_value);

    starttime_ns = ktime_to_ns(ktime_get());
    kthread_run(mythread, (void *)del_value, "myvalue");

    return len;
}


static DEVICE_ATTR(myvalue, S_IWUSR | S_IRUGO, show_myvalue, set_myvalue);  /* define a pseudo file 'myvalue' which can be read and write */
static struct class *cls;


static int mytest_init(void)
{
    struct device *mydev;   
    cls=class_create(THIS_MODULE, "myclass");              /* create sysfs class 'myclass' */
    mydev = device_create(cls, 0, 0, NULL, "mydevice");    /* create device directory 'mydevice' under this class */
    if(sysfs_create_file(&(mydev->kobj), &dev_attr_myvalue.attr))    /* create the device attribute 'myvalue' under this device */
         return -1;
    return 0;
}

static void mytest_exit(void)
{
    device_destroy(cls, 0);
    class_destroy(cls);
}

module_init(mytest_init);
module_exit(mytest_exit);
