# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

TARGET = test
SOURCES = ejemplo2.prg

PRGFLAGS=-I../../include
LIBS=-L../../src/gclass -lgclass -L../../hbgtk -lhbgtk $(shell pkg-config --libs libglade-2.0) $(shell pkg-config --libs gtk+-2.0 ) -mwindows

include ../../Rules.make

