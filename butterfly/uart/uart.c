
#include "uart.h"

FILE uart_stream = FDEV_SETUP_STREAM(
	uart_putchar,
	uart_getchar,
	_FDEV_SETUP_RW);

void uart_init(void) {
	UCSRA &= ~(1 << U2X);
	UCSRB |= (1 << RXEN) | (1 << TXEN);
	UCSRC |= (1 << UCSZ0) | (1 << UCSZ1);
	
	UBRRL = BAUD_PRESCALE;
	UBRRH = (BAUD_PRESCALE >> 8);
}

int uart_putchar(char c, FILE *stream) {
	while ((UCSRA & (1 << UDRE)) == 0) ;
	UDR = c;
	
	return 0;
}

int uart_getchar(FILE *sttream) {
	char c;
	
	while ((UCSRA & (1 << RXC)) == 0) ;
	
	if (UCSRA & _BV(FE))  return _FDEV_EOF;
	if (UCSRA & _BV(DOR)) return _FDEV_ERR;
	
	c = UDR;
	
	return c;
}
