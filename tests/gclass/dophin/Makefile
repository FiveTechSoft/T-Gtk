# Atención, la ruta include/lib de tdolphin tiene que estar definida, aqui o en rules.make
ROOT = ../../../
include $(ROOT)config/global.mk

TARGET = test
SOURCES = dophin.prg

PRGFLAGS=-I$(TGTK_DIR)/tdolphin/include
LIBFILES_=-ltdolphin -lhbct
ifneq ($(HB_MAKE_PLAT),win)
   LIBFILES_+= -lmysqlclient
endif
#LIBS =-L./ -ldolphin 

include $(ROOT)Rules.make

