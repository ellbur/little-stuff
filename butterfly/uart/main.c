
#include <avr/io.h>
#include <avr/pgmspace.h>

#include <util/delay.h>
#include <stdio.h>

#include "uart.h"

int main(void) {
	
	int address;
	int contents;
	
	uart_init();
	
	stdout = &uart_stream;
	stdin  = &uart_stream;
	
	while (1) {
		printf("Address\n\r");
		printf(">> ");
		fflush(stdout);
		
		scanf("%d", &address);
		contents = *((int*) address);
		
		printf("Contents: %x\r\n", contents);
	}
}
