##################################
#
# Makefile para librerias en codigo .PRG
#

ROOT = ../
include $(ROOT)config/global.mk
$(info $(SETENV))
include $(ROOT)$(SETENV)


PRGFLAGS=-I$(ROOT)include -I$(ROOT)/tdolphin/include

CFLAGS+=-I$(ROOT)include
ifeq ($(HB_MAKE_PLAT),win)
   CFLAGS=-I$(MYSQL_PATH)
else
   CFLAGS=-I/usr/include/mysql -I/usr/local/include/mysql
endif

TGTK_INSTALL=$(ROOT)lib
TARGET=libtdolphin.a

CSOURCES=c/function.c

include $(ROOT)Rules.make
