
ROOT       = $(PWD)/..
BUILD_ROOT = $(ROOT)/build
NAME       = sim

BUILD_DIR = $(BUILD_ROOT)/$(NAME)

ALL   = $(BUILD_DIR)/.all
SO    = $(BUILD_DIR)/sim.so
C     = $(BUILD_DIR)/sim.c

PIC_OBJECTS = $(wildcard $(BUILD_ROOT)/user_code/*.o)

all: $(ALL)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ALL): $(SO) Makefile | $(BUILD_DIR)
	touch $(ALL)

$(SO): $(PIC_OBJECTS) sim.pyx make_sim_setup.py | $(BUILD_DIR)
	rm -f $(SO)
	cp sim.pyx $(BUILD_DIR)
	./make_sim_setup.py $(ROOT) > $(BUILD_DIR)/sim_setup.py
	cd $(BUILD_DIR) && \
		python sim_setup.py build_ext --inplace 

$(PIC_OBJECTS): $(BUILD_ROOT)/user_code/.all
	make -C $(ROOT)/user_code

clean:
	rm -f $(ALL) $(SO) $(C)
	rm -rf $(wildcard $(BUILD_DIR)/*)
