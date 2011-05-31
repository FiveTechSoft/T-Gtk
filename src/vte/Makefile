# Please, you need libvte-dev for create this library
ROOT =../../
TARGET = libhbvte.a
SOURCES = vte.prg
CSOURCES= cvte.c

CFLAGS+=$(shell pkg-config --cflags vte)

TGTK_INSTALL=$(ROOT)lib

include $(ROOT)Rules.make

