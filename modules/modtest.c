
#include <linux/module.h>
#include <linux/errno.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/mutex.h>
#include <linux/device.h>
#include <linux/miscdevice.h>
#include <linux/types.h>
#include <linux/sched.h>
#include <linux/slab.h>

#include <asm/uaccess.h>

#define NAME "modtest"

#define MESSAGE_SIZE 64

struct modtest_private_data {
	char message[MESSAGE_SIZE];
	size_t length;
};

static int modtest_open(
	struct inode *inode,
	struct file *file)
{
	struct modtest_private_data *priv_data;
	
	priv_data = kmalloc(sizeof(struct modtest_private_data), GFP_KERNEL);
	if (! priv_data) {
		return -EFAULT;
	}
	
	priv_data->length = snprintf(priv_data->message, MESSAGE_SIZE,
		"PID %d opens inode %ld as user %d\n",
		current->pid, inode->i_ino, file->f_uid);
	
	file->private_data = priv_data;
	
	printk(KERN_INFO "%s: File opened successfully\n", NAME);
	
	return 0;
}

static int modtest_release(
	struct inode *inode,
	struct file *file)
{
	kfree(file->private_data);
	
	printk(KERN_INFO "%s: File closed\n", NAME);
	
	return 0;
}

static ssize_t modtest_read(
		struct file *file,
		char __user *buffer,
		size_t count,
		loff_t *pos)
{
	struct modtest_private_data *data;
	
	if (file->private_data == NULL) {
		return -EFAULT;
	}
	
	data = file->private_data;
	
	if (*pos >= data->length) return 0;
	if (count > data->length - *pos) {
		count = data->length - *pos;
	}
	
	if (copy_to_user(buffer, data->message + *pos, count))
	{
		return -EFAULT;
	}
	*pos += count;
	
	return (ssize_t) count;
}

static ssize_t modtest_write(
		struct file *file,
		const char __user *buffer,
		size_t count,
		loff_t *pos)
{
	return (ssize_t) count;
}

static struct file_operations modtest_fops = {
	.owner   = THIS_MODULE,
	.open    = modtest_open,
	.release = modtest_release,
	.read    = modtest_read,
	.write   = modtest_write,
};

static struct miscdevice modtest_miscdevice = {
	.minor = MISC_DYNAMIC_MINOR,
	.name  = NAME,
	.fops  = &modtest_fops,
};

static int __init modtest_init(void)
{
	int status;
	
	printk(KERN_INFO "%s starting initialization\n", NAME);
	
	status = misc_register(&modtest_miscdevice);
	if (status) {
		printk(KERN_ERR "%s Failed to initialize\n", NAME);
		return status;
	}
	
	printk(KERN_INFO "%s Initialized\n", NAME);
	
	return 0;
}

static void __exit modtest_exit(void)
{
	misc_deregister(&modtest_miscdevice);
	
	printk(KERN_INFO "%s Deinitialized\n", NAME);
}

module_init(modtest_init);
module_exit(modtest_exit);

MODULE_AUTHOR("Owen Healy <ellbur@gmail.com>");
MODULE_DESCRIPTION("Just fooling around");
MODULE_LICENSE("GPL");
