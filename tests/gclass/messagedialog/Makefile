# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../
TARGET = test
SOURCES = test.prg

#PRGFLAGS=-I$(ROOT)include
#LIBS=-L$(ROOT)src/gclass -lgclass -L$(ROOT)hbgtk -lhbgtk $(shell pkg-config --libs libglade-2.0) $(shell pkg-config --libs gtk+-2.0 )

LIBS_= -L$(LIBDIR_TGTK) -lgclass -lhbgtk -Wl,--start-group -L$(HB_LIB_INSTALL) $(LIBFILES_) -Wl,--end-group $(LIBS)

include $(ROOT)Rules.make

