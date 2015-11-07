#
# File: Linux serproxy makefile
#
# (C)1999 Stefano Busti
#

VERSION = `cat VERSION`

SRCS = \
  main.c sio.c sock.c thread.c vlist.c cfglib.c config.c string.c \
  pipe.c error.c

OBJS = \
  main.o sio.o sock.o thread.o vlist.o cfglib.o config.o string.o \
  pipe.c error.c

CC = gcc

ifdef DEBUG
CFLAGS = -Wall -g -D__UNIX__ -DDEBUG
else
CFLAGS = -Wall -O2 -fomit-frame-pointer -D__UNIX__
endif

ifdef USE_EF
LIBS= -lpthread -lefence
else
LIBS= -lpthread
endif

# Build the program

serproxy: $(SRCS) $(OBJS)
	$(CC) $(CFLAGS)  -o serproxy $(OBJS) $(LDFLAGS) $(LIBS)

install: serproxy
	cp -f serproxy /usr/local/bin

clean:
	rm -f *.o *~

realclean:
	rm -f *.o *~ serproxy *.gz *.zip

dep:
	makedepend -Y -- $(CFLAGS) -- $(SRCS) 2&>/dev/null

# DO NOT DELETE

main.o: sio.h sock.h pipe.h thread.h vlist.h cfglib.h config.h error.h
sio.o: sio.h
sock.o: sock.h
thread.o: thread.h
vlist.o: vlist.h
cfglib.o: cfglib.h
config.o: config.h cfglib.h string.h
string.o: string.h
pipe.o: pipe.h sio.h sock.h thread.h
error.o: error.h
