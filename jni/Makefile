
SUN_INCLUDE_PATH = /usr/lib/jvm/java-6-sun/include

INCLUDE  = \
	-I$(SUN_INCLUDE_PATH)/ \
	-I$(SUN_INCLUDE_PATH)/linux

CFLAGS  =  $(INCLUDE)

library: Foo.so ;

headers: Foo.h ;

run: library Foo.class
	java Foo

Foo.so: Foo.c
	$(CC) -fPIC -shared -o $@ $(CFLAGS) $^

Foo.h: Foo.class
	javah -jni Foo

Foo.class: Foo.java
	javac Foo.java
