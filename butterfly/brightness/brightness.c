
#include <avr/io.h>
#include <util/delay.h>

#define turn_on()  (PORTB = 0b00000100)
#define turn_off() (PORTB = 0b00000000)

#define cycle_us 20000.0

void pwm_cycle(double fraction) {
	double on_delay;
	double off_delay;
	
	on_delay = fraction * cycle_us;
	off_delay = cycle_us - on_delay;
	
	turn_on();
	_delay_us(on_delay);
	
	turn_off();
	_delay_us(off_delay);
}

void pwm_many_cycles(double ms, double fraction) {
	long i;
	
	for (i=0; i<ms*1000/cycle_us; i++) {
		pwm_cycle(fraction);
	}
}

int main(void) {
	long i;
	
	DDRB = 255;
	
	while (1) {
		
		for (i=0; i<20; i++) {
			pwm_many_cycles(50, i/20.0);
		}
		
		for (i=0; i<20; i++) {
			pwm_many_cycles(50, 1.0 - i/20.0);
		}
	}
}
