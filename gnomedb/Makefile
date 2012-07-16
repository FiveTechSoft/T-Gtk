##################################
#
# Makefile para T-GTK codigo de C
#
ROOT = ../
include $(ROOT)config/global.mk
include $(ROOT)$(SETENV)

TARGET=libhbgda.a
LIBGDA=libgda-$(GDA_VERSION)

CFLAGS+=-I. -I$(ROOT)include $(shell pkg-config --cflags $(LIBGDA))
LIBGDA_VERSION=$(shell pkg-config --modversion $(LIBGDA))
CFLAGS+= -DLIBGDAVERSION=$(LIBGDA_VERSION)

SOURCE_TYPE=c
TGTK_INSTALL=$(ROOT)lib

include $(ROOT)Rules.make
