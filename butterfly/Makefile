
.SUFFIX : .c .h .o .hex .elf .S

AVRCC       =  avr-gcc
AVRLD       =  avr-gcc
OBJCOPY     =  avr-objcopy
AVRDUDE     =  avrdude
OBJDUMP     =  avr-objdump

CHIP        =  atmega169
F_CPU       =  2000000
PORT        =  /dev/ttyUSB0
TARGET      =  m169
PROG        =  butterfly

HEX         =  main.hex
ELF         =  main.elf
OD          =  main.od

AVRCFLAGS   =  -Wall -O0 -mmcu=$(CHIP) -DF_CPU=$(F_CPU)UL -std=gnu99 -O0
AVRLDFLAGS  =  -mmcu=$(CHIP)

SAVETEMPS   =  -save-temps

SOURCES_C   =  $(wildcard *.c)
SOURCES_S   =  $(wildcard *.S)
SOURCES     =  $(SOURCES_C) $(SOURCES_S)

OBJECTS_C   =  $(addsuffix .o, $(basename $(SOURCES_C)) )
OBJECTS_S   =  $(addsuffix .o, $(basename $(SOURCES_S)) )
OBJECTS     =  $(OBJECTS_C) $(OBJECTS_S)

HEADERS     =  $(wildcard *.h)

all: depend $(HEX) ;

# ------------------------------------------------

$(HEX): $(ELF)
	$(OBJCOPY) -j .text -j .data -O ihex $(ELF) $(HEX)

$(ELF): $(OBJECTS)
	$(AVRLD) -o $(ELF) $(AVRLDFLAGS) $(OBJECTS)

$(OBJECTS_C): %.o: %.c Makefile
	$(AVRCC) -c $(AVRCFLAGS) $< -o $@

$(OBJECTS_S): %.o: %.S Makefile
	$(AVRCC) -c $(AVRCFLAGS) $< -o $@

# ------------------------------------------------

clean:
	rm -rf *.o *.hex *.elf *.bak *.i *.s *.ob
	echo "# DO NOT DELETE THIS LINE -- make depend depends on it." > depend

# ------------------------------------------------

download: $(HEX)
	$(AVRDUDE) -P $(PORT) -p $(TARGET) -c $(PROG) -e -U flash:w:$(HEX):i

# ------------------------------------------------

depend: $(SOURCES) $(HEADERS)
	makedepend -f depend -I/usr/avr/include $(SOURCES) 2>/dev/null

# ------------------------------------------------

temps: $(SOURCES) $(HEADERS)
	$(AVRCC) -c $(AVRCFLAGS) $(SAVETEMPS) $(SOURCES)

# ------------------------------------------------

objdump: $(ELF)
	$(OBJDUMP) -zhD $(ELF) > $(OD)

include $(shell touch depend)
