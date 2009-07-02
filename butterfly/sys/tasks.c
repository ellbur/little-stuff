
#include "tasks.h"
#include "timer.h"

#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <avr/io.h>
#include <stdio.h>

uint8_t num_tasks    = 0;
uint8_t current_task = 0;

struct task tasks[MAX_TASKS];

void make_task(uint16_t start_ptr)
{
	uint8_t i, j;
	uint8_t *stack_ptr;
	uint16_t end_ptr;
	
	fflush(stdout);
	
	if (num_tasks >= MAX_TASKS) {
		return;
	}
	num_tasks++;
	
	// Now find an empty task
	
	for (i=0; i<MAX_TASKS; i++) {
		if (! tasks[i].active) break;
	}
	
	tasks[i].active = 1;
	
	printf("Setting up task %d to start at %04x\n", (int)i, (int)start_ptr);
	fflush(stdout);
	
	// Calculate the stack pointer and set it
	
	stack_ptr = (uint8_t*) (STACK_START - STACK_SIZE*i) - 1;
	
	// Set the initial stack to something appropriate
	
	end_ptr = (uint16_t) (&task_die);
	
	// The stack pointer points to the next byte TO BE WRITTEN
	*(stack_ptr--) = end_ptr >> 0;
	*(stack_ptr--) = end_ptr >> 8;
	
	*(stack_ptr--) = start_ptr >> 0; // return address
	*(stack_ptr--) = start_ptr >> 8;
	
	// registers, r0-31 and SREG
	for (j=0; j<33; j++) {
		*(stack_ptr--) = 0;
	}
	
	tasks[i].stack_ptr = (uint16_t) stack_ptr;
}

uint16_t change_task_data(uint16_t sp)
{
	uint8_t next_task;
	
	// reset premptive timer
	TCNT1 = 0;
	
	for (next_task=current_task+1; ; next_task++) {
		next_task %= MAX_TASKS;
		
		if (tasks[next_task].active) break;
	}
	
	tasks[current_task].stack_ptr = sp;
	current_task = next_task;
	
	return tasks[current_task].stack_ptr;
}

uint16_t first_task_data(void)
{
	current_task = 0;
	return tasks[current_task].stack_ptr;
}

void task_die(void)
{
	tasks[current_task].active = 0;
	
	context_switch();
}

void inspect_stack(uint8_t *sp)
{
	uint8_t i;
	
	printf("Inspecting at %d+1\n", (int) sp);
	fflush(stdout);
	
	sp++;
	
	for (i=0; i<40; i++) {
		printf("(%d) %02x\n", (int) i, (int) *(sp+i));
		fflush(stdout);
	}
}

void start_preemptor(void)
{
	printf("Starting preemptor\n");
	fflush(stdout);
	
	setup_timer();
	set_timer_interrupt(TASK_SWITCH_DELAY);
	
	start_tasks();
}
