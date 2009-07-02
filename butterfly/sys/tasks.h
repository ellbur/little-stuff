
#ifndef _tasks_h
#define _tasks_h 1

#include <inttypes.h>
#include "asm-routines.h"

#define STACK_START        1200
#define STACK_SIZE         128

#define TASK_SWITCH_DELAY  600
#define MAX_TASKS          4

#define lock_atomic()   cli()
#define unlock_atomic() sei()

struct task {
	uint8_t active;
	
	uint16_t stack_ptr;
};

extern uint8_t num_tasks;
extern struct task tasks[];

extern uint8_t current_task;

void make_task(uint16_t start_ptr);

/*
 * Arguments:
 *  sp - the old stack pointer to save
 *
 * Returns:
 *  The new stack pointer to be restored
 *
 * Also alters current_task
 */
uint16_t change_task_data(uint16_t sp);

uint16_t first_task_data(void);

void task_die(void);

void start_preemptor(void);

#endif /* defined _tasks_h */
