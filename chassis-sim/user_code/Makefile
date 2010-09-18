
ROOT       = $(PWD)/..
BUILD_ROOT = $(ROOT)/build
NAME       = user_code

BUILD_DIR = $(BUILD_ROOT)/$(NAME)

ALL   = $(BUILD_DIR)/.all

CFLAGS      = -fsingle-precision-constant -fPIC -mpc32 -I. -I../sim

SOURCES     = $(wildcard *.c)
HEADERS     = $(wildcard *.h)
OBJECTS     = $(patsubst %, $(BUILD_DIR)/%, $(SOURCES:.c=.o))

CC          = gcc

all: $(ALL)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ALL): $(OBJECTS) Makefile | $(BUILD_DIR)
	touch $(ALL)

$(BUILD_DIR)/%.o: %.c $(HEADERS) Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	rm -f $(OBJECTS)
	rm -rf $(wildcard $(BUILD_DIR)/*)
