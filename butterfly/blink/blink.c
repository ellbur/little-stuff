
/* 
blink.c for Blinking LED on AVR Butterfly's PB2

This file is a part of a series of tutorials created by Rutgers IEEE Robotics

Original Program by:
Adam stambler
3/23/08
*/

#include <avr/io.h>
#include <util/delay.h>

#define num_intervals 2

int intervals[num_intervals] = {
	1000,
	1000,
};

int main(void)
{
	int interval_counter;
	
	DDRB = 255;
	PORTB = 0b00000100;
	
	interval_counter = 0;
	
	while(1)
	{
		_delay_ms(intervals[interval_counter]);
		PORTB = 0b00000100;
		
		interval_counter++;
		interval_counter %= num_intervals;
		
		_delay_ms(intervals[interval_counter]);
		PORTB = 0b00000000;
		
		interval_counter++;
		interval_counter %= num_intervals;
	}
}
