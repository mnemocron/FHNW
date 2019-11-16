/*
 * File:  mod_hrtimer.c
 * Autor: Matthias Meier
 * Aim:   simple latency test of high res timers
 *
 * Based on an article "Kernel APIs, Part 3: Timers and lists in the 2.6 kernel" by M.Tim Jones:
 * http://www.ibm.com/developerworks/linux/library/l-timers-list/
 *
 * Remarks:
 * - The timer subsystem is documented here: http://www.kernel.org/doc/htmldocs/device-drivers/
 * - For a simple test without additional cpu-load enter:
 *   insmod mod_hrtimer.ko; sleep 3; dmesg | tail -25 ; rmmod mod_hrtimer
 * - For additional CPU load use 'hackbench' or (less heavy) by parallel kernel compile (eg. make -j 20)
 */

/*
 * sudo insmod mod_hrtimer_dev.ko
 * cat /proc/devices | grep hrtimer
 * sudo mknod -m 666 mod_hrtimer_dev c <major_node> 0
 * cat mod_hrtimer_dev
 */
#include <linux/module.h>
#include <linux/hrtimer.h>
#include <linux/kthread.h>
#include <linux/delay.h>
#include <linux/uaccess.h>   // copy from and to user
#include <linux/fs.h>
#include <linux/wait.h>
#include <linux/device.h>

MODULE_AUTHOR("M. Tim Jones (IBM)");
MODULE_AUTHOR("Matthias Meier <matthias.meier@fhnw.ch>");
MODULE_LICENSE("GPL");

static DECLARE_WAIT_QUEUE_HEAD(wq);
static struct class *mydev_class;

#define INTERVAL_BETWEEN_CALLBACKS (100 * 1000000LL) //100ms (scaled in ns) 
#define NR_ITERATIONS 20

static struct hrtimer hr_timer;
static ktime_t ktime_interval;
static s64 starttime_ns;

static int major;
static int triggered = 0;

static char mydata[100];

static int my_open(struct inode *inode, struct file *filp) {
    return 0; // success
}

static int my_release(struct inode *inode, struct file *flip) {
    return 0; // success
}

static ssize_t my_read(struct file *flip, char *buf, size_t count, loff_t *f_ops) {
    
    //get the current time as high resolution timestamp, convert it to ns
    starttime_ns = ktime_to_ns(ktime_get());
    //activate the high resolution timer including callback function...
    hrtimer_start( &hr_timer, ktime_interval, HRTIMER_MODE_REL );
    // wait for measurement to be completed
    wait_event_interruptible(wq, triggered);
    triggered = 1;

    //activate the high resolution timer including callback function...
    hrtimer_start( &hr_timer, ktime_interval, HRTIMER_MODE_REL );
    if (strnlen(mydata, sizeof(mydata)) < count)
        count = strnlen(mydata, sizeof(mydata));   // make count smaller
    __copy_to_user (buf, mydata, count);  // from kernel space to user space
    mydata[0] = 0;  // "clear" buffer
    return count;
}

// here appears to be some issue ? (my_write)
static ssize_t my_write(struct file *flip, const char *buf, size_t count, loff_t *f_pos) {
    if (sizeof(mydata) < count)
        count = sizeof(mydata);   // make count smaller
    __copy_from_user(mydata, buf, count);  // from user to kernel space
    return count;
}

static struct file_operations my_fops = {
    .owner = THIS_MODULE,
    .read = my_read,
    .write = my_write,
    .open = my_open,
    .release = my_release,
};

static enum hrtimer_restart  my_hrtimer_callback( struct hrtimer *timer )
{
    static int n = 0;
    static int min = 1000000000, max = 0, sum = 0;
    int latency;
    s64 now_ns = ktime_to_ns(ktime_get());
    hrtimer_forward(&hr_timer, hr_timer._softexpires, ktime_interval); //next call relative to expired timestamp

    // calculate some statistics values...
    n++;
    latency = now_ns - starttime_ns - n * INTERVAL_BETWEEN_CALLBACKS;
    sum += latency / 1000;
    if (min > latency) min = latency;
    if (max < latency) max = latency;
    printk("mod_hrtimer: my_hrtimer_callback called after %dus.\n", (int) (now_ns - starttime_ns) / 1000 );

    if (n < NR_ITERATIONS)
        return HRTIMER_RESTART;
    else
    {
        printk("mod_hrtimer: my_hrtimer_callback: statistics latences over %d hrtimer callbacks: "
               "min=%dus, max=%dus, mean=%dus\n", n, min / 1000, max / 1000, sum / n);
        snprintf(mydata, sizeof(mydata), "statistics latences over %d hrtimer callbacks: "
               "min=%dus, max=%dus, mean=%dus\n", n, min / 1000, max / 1000, sum / n);
        triggered = 1;
        wake_up_interruptible_sync(&wq);
        // reset variables?????
        n = 0;
        min = 1000000000; 
        max = 0;
        sum  = 0;
        return HRTIMER_NORESTART;
    }
}

static int  init_module_hrtimer( void )
{
    printk("mod_hrtimer: installing module...\n");
    //define a ktime variable with the interval time defined on top of this file
    ktime_interval = ktime_set( 0, INTERVAL_BETWEEN_CALLBACKS );
    //init a high resolution timer named 'hr_timer'
    hrtimer_init( &hr_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL );

    mydev_class = class_create(THIS_MODULE, "mod_hrtimer_dev");
    device_create(mydev_class, NULL, MKDEV(major, 0), NULL, "mod_hrtimer_dev");

    //set the callback function for this hr_timer
    hr_timer.function = &my_hrtimer_callback;
    //get the current time as high resolution timestamp, convert it to ns
    starttime_ns = ktime_to_ns(ktime_get());
    //activate the high resolution timer including callback function...
    hrtimer_start( &hr_timer, ktime_interval, HRTIMER_MODE_REL );
    printk( "mod_hrtimer: started timer callback function to fire every %lldns (current jiffies=%ld, HZ=%d)\n",
            INTERVAL_BETWEEN_CALLBACKS, jiffies, HZ );
    
    // register as device node
    major = register_chrdev(0, "mod_hrtimer_dev", &my_fops);
    if (major < 0) {
        printk("mod_hrtimer_dev: error, cannot register the character device\n");
        return major;       
    }

    return 0;
}

static void  cleanup_module_hrtimer( void )
{
    int ret;
    ret = hrtimer_cancel( &hr_timer );
    if (ret)
        printk("mod_hrtimer: The timer was still in use...\n");
    printk("mod_hrtimer: HR Timer module uninstalling\n");

    device_destroy(mydev_class, MKDEV(major,0));
    class_unregister(mydev_class);
    class_destroy(mydev_class);
    unregister_chrdev(major, "mod_hrtimer_dev");
}

module_init(init_module_hrtimer);
module_exit(cleanup_module_hrtimer);

