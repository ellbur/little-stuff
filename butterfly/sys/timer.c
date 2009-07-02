
#include "timer.h"

#include <avr/interrupt.h>
#include <avr/io.h>

void setup_timer(void)
{
	// internal, 256 prescaler
	TCCR1B |=  (1 << 2);
	TCCR1B &= ~(1 << 1) & ~(1 << 0);
}

void set_timer_interrupt(int compare)
{
	// "Set OC1A on Compare Match"
	TCCR1A |= (1 << 7) | (1 << 6);
	
	// Compare value (2 bytes)
	OCR1A = compare;
	
	TIMSK1 |= (1 << 1);
}
