##################################
#
# Makefile para T-GTK codigo de C
#

ROOT = ../

TARGET=libhbgtk.a
#CFLAGS+=-I. -I$(ROOT)include $(shell pkg-config --cflags gtk+-2.0)$(shell pkg-config --cflags libglade-2.0) -D__OLDHARBOUR__
CFLAGS+=-I. -I$(ROOT)include $(shell pkg-config --cflags gtk+-2.0)$(shell pkg-config --cflags libglade-2.0)

SOURCE_TYPE=c
TGTK_INSTALL=$(ROOT)lib

include $(ROOT)Rules.make

