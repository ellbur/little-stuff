
ROOT            = $(PWD)

BUILD_ROOT      =  build
BUILD_DIR       =  build

SUBDIRS         =  user_code sim

.PHONY: $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	make --directory=$@ $(TARGET) ROOT=$(ROOT)

clean:
	make TARGET=clean
