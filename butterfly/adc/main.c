
#include <avr/io.h>
#include <util/delay.h>

#include <stdio.h>
#include "uart.h"
#include "adc.h"

int main(void) {
	
	int s1, s2, s3, s4;
	
	uart_init();
	
	stdout = &uart_stream;
	stdin  = &uart_stream;
	
	while (1) {
		_delay_ms(2000);
		
		ADC_init(4); s1 = ADC_read();
		ADC_init(5); s2 = ADC_read();
		ADC_init(6); s3 = ADC_read();
		ADC_init(7); s4 = ADC_read();
		
		printf("Read: %3d %3d %3d %3d\r\n", s1, s2, s3, s4);
	}
}
