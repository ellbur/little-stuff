
#include "adc.h"
#include <avr/io.h>

/*
 * Code in this file stolen from
 * bf_gcc.
 */

#define sbiBF(port,bit)  (port |= (1<<bit))   //set bit in port
#define cbiBF(port,bit)  (port &= ~(1<<bit))  //clear bit in port

void ADC_init(char input)
{
  
	ADMUX = input;    // external AREF and ADCx
	
	// My clock is 2MHz for some reason
//     ADCSRA = (1<<ADEN) | (1<<ADPS1) | (1<<ADPS0);    // set ADC prescaler to , 1MHz / 8 = 125kHz    
	ADCSRA = (1<<ADEN) | (1<<ADPS2); // set ADC prescaler to , 2MHz / 16 = 125kHz    

	input = ADC_read();        // dummy 
}

int ADC_read(void)
{
	char i;
	int ADC_temp;
	// mt int ADC = 0 ;
	int ADCr = 0;
	
	// To save power, the voltage over the LDR and the NTC is turned off when not used
	// This is done by controlling the voltage from a I/O-pin (PORTF3)
	sbiBF(PORTF, PF3); // mt sbi(PORTF, PORTF3);     // Enable the VCP (VC-peripheral)
	sbiBF(DDRF, DDF3); // sbi(DDRF, PORTF3);        

	sbiBF(ADCSRA, ADEN);     // Enable the ADC

	//do a dummy readout first
	ADCSRA |= (1<<ADSC);        // do single conversion
	while(!(ADCSRA & 0x10));    // wait for conversion done, ADIF flag active
		
	for(i=0;i<8;i++)            // do the ADC conversion 8 times for better accuracy 
	{
		ADCSRA |= (1<<ADSC);        // do single conversion
		while(!(ADCSRA & 0x10));    // wait for conversion done, ADIF flag active
		
		ADC_temp = ADCL;            // read out ADCL register
		ADC_temp += (ADCH << 8);    // read out ADCH register        

		ADCr += ADC_temp;      // accumulate result (8 samples) for later averaging
	}

	ADCr = ADCr >> 3;     // average the 8 samples
	
	cbiBF(PORTF,PF3); // mt cbi(PORTF, PORTF3);     // disable the VCP
	cbiBF(DDRF,DDF3); // mt cbi(DDRF, PORTF3);  
	
	cbiBF(ADCSRA, ADEN);      // disable the ADC

	return ADCr;
}
