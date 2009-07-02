
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

#include <stdio.h>

#include "uart.h"
#include "timer.h"
#include "tasks.h"

void routine_1(void);
void routine_2(void);

int main(void) {
	uart_init();
	
	stdout = &uart_stream;
	stdin  = &uart_stream;
	
	printf("EIMSK  = %02x\n", (int) EIMSK);
	printf("EIFR   = %02x\n", (int) EIFR);
	printf("PCMSK1 = %02x\n", (int) PCMSK1);
	printf("\n");
	printf("main      = %04x\n", (int) (&main));
	printf("routine_1 = %04x\n", (int) (&routine_1));
	printf("task_die  = %04x\n", (int) (&task_die));
	
	printf("About to make a task\n");
	fflush(stdout);
	
	make_task((uint16_t) &routine_1);
	make_task((uint16_t) &routine_2);
	
	printf("About to start tasks\n");
	fflush(stdout);
	
	start_preemptor();
	
	return 0;
}

ISR(__vector_3)
{
	// Button press. Do nothing
}


void routine_1(void)
{
	while (1) {
		lock_atomic();
		
		printf("A\n");
		fflush(stdout);
		
		unlock_atomic();
	}
}

void routine_2(void)
{
	while (1) {
		lock_atomic();
		
		printf("B\n");
		fflush(stdout);
		
		unlock_atomic();
	}
}
