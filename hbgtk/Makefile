##################################
#
# Makefile para T-GTK codigo de C
#

ROOT = ../

#CFLAGS+=-I. -I$(ROOT)include $(shell pkg-config --cflags gtk+-2.0)$(shell pkg-config --cflags libglade-2.0) -D__OLDHARBOUR__
CFLAGS+=-I. -I$(ROOT)include $(shell pkg-config --cflags gtk+-2.0)$(shell pkg-config --cflags libglade-2.0)

SOURCE_TYPE=c
TGTK_INSTALL=$(ROOT)lib
TARGET=$(TGTK_INSTALL)$(DIRSEP)libhbgtk.a

include $(ROOT)Rules.make

