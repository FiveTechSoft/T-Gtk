##################################
#
# Makefile para T-GTK codigo de C
#
ROOT = ../
include $(ROOT)config/global.mk
include $(ROOT)$(SETENV)


TARGET=libhbgtkextra.a
LIBGTKEXTRA=gtkextra-3.0

CFLAGS+=-I. -I$(ROOT)include $(shell pkg-config --cflags $(LIBGTKEXTRA))

SOURCES=gsheet.prg

#SOURCE_TYPE=c
CSOURCES=gtksheet.c

TGTK_INSTALL=$(ROOT)lib

include $(ROOT)Rules.make
