VERSION=jcrypt-1.0

UNAME=\`uname\`
OS = `if [ $(UNAME) = 'Linux' ] ; then \
		echo 'linux' ; \
	elif [ $(UNAME) = 'SunOS' ] ; then \
		echo 'solaris' ; \
	elif [ $(UNAME) = 'HP-UX' ] ; then \
		echo 'hp-ux' ; \
	fi`
# solaris
CC = gcc
CFLAGS = -fPIC -Wall -c
LIBFLAGS = -shared -o
INCLUDE = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/$(OS)

SRC = com_nara_beehive_util_jni_Crypt.c
OBJ = com_nara_beehive_util_jni_Crypt.o
LIB = libbeehive_jcrypt.so

all: object share install

object: $(SRC)
	$(CC) $(CFLAGS) $(INCLUDE) $(SRC)

share: $(OBJ)
	$(CC) $(LIBFLAGS) $(LIB) $(OBJ) -lc

install:
	cp $(LIB) /usr/lib

clean:
	rm -f $(OBJ) $(LIB)
