# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../
#SETTINGS=$(ROOT)config/settings/minimal.mk

TARGET = test
SOURCES = sheet.prg

#PRGFLAGS=-I$(ROOT)include
#CFLAGS+=$(shell pkg-config --cflags --libs gtkextra-3.0 )
#LIBS+= $(shell pkg-config --libs gtkextra-3.0 )

LIBS+= -lhbgtkextra

include $(ROOT)Rules.make

