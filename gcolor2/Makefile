default: build

object:
		gcc -Wall -c `pkg-config --cflags --libs gtk+-2.0` src/callbacks.c -o src/callbacks.o
		gcc -Wall -c `pkg-config --cflags --libs gtk+-2.0` src/interface.c -o src/interface.o
		gcc -Wall -c `pkg-config --cflags --libs gtk+-2.0` src/support.c -o src/support.o
		gcc -Wall -c `pkg-config --cflags --libs gtk+-2.0` src/main.c -o src/main.o

build: object
		gcc -Wall `pkg-config --cflags --libs gtk+-2.0`\
				src/callbacks.o src/interface.o src/support.o src/main.o -o gcolor2\
				`pkg-config --libs gtk+-2.0`

clean:
		rm src/callbacks.o
		rm src/interface.o
		rm src/support.o
		rm src/main.o
		rm gcolor2

run:
		./gcolor2
