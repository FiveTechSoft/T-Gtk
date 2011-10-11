# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../

TARGET = client
SOURCES = netio_client.prg 
#hbnetio.prg

#PRGFLAGS=-I$(ROOT)include
ifeq ( $(HB_PLAT),win )
   LIBFILES_=-lhbnetio 
#-lws2_32
else
   LIBFILES_=-lhbnetio 
#-lhbrtl -lwininet -lwsock32 
endif

include $(ROOT)Rules.make

