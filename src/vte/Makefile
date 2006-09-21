# Please, you need libvte-dev for create this library

TARGET = libhbvte.a
SOURCES = vte.prg
CSOURCES= cvte.c

CFLAGS+=$(shell pkg-config --cflags vte)

TGTK_INSTALL=../../lib

include ../../../Rules.make

