# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

TARGET = test
SOURCES = dialogos.prg

PRGFLAGS=-I../../../include -p
LIBS=-L../../../src/gclass -lgclass -L../../../hbgtk -lhbgtk $(shell pkg-config --libs libglade-2.0) $(shell pkg-config --libs gtk+-2.0 )

include ../../../Rules.make

