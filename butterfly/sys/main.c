
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

#include <stdio.h>
#include <string.h>

#include "uart.h"
#include "timer.h"
#include "tasks.h"
#include "mutex.h"

void routine_1(void);
void routine_2(void);

int main(void) {
	uart_init();
	
	make_task((uint16_t) &routine_1);
	make_task((uint16_t) &routine_2);
	
	start_preemptor();
	
	return 0;
}

ISR(__vector_3)
{
	// Button press. Do nothing
}

ISR(BADISR_vect)
{
	printf("\n\n\n\n");
	fflush(stdout);
	printf("Bad Interrupt!!\n\n");
	fflush(stdout);
}

// ----------------------------------------------

#define PRINT_STRING_LEN 16
char print_string[PRINT_STRING_LEN] = "foo\n";

mutex_t string_mutex = 0;

void routine_1(void)
{
	char temp_string[PRINT_STRING_LEN];
	
	while (1) {
		
		mutex_spinlock(&string_mutex);
		memcpy(temp_string, print_string, PRINT_STRING_LEN);
		mutex_unlock(&string_mutex);
		
		printf("%s", temp_string);
		fflush(stdout);
	}
}

void routine_2(void)
{
	char temp_string[PRINT_STRING_LEN];
	
	while (1) {
		fgets(temp_string, PRINT_STRING_LEN, stdin);
		
		mutex_spinlock(&string_mutex);
		memcpy(print_string, temp_string, PRINT_STRING_LEN);
		mutex_unlock(&string_mutex);
	}
}
