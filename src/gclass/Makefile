##################################
#
# Makefile para librerias en codigo .PRG
#

ROOT = ../../

include $(ROOT)config/detect.mk
#ifeq ($(GTK_MAJOR_VERSION),3)
   SOURCES=gsignals.prg wqout.prg
#endif

PRGFLAGS=-I$(ROOT)include 
CFLAGS+=-I$(ROOT)include
TGTK_INSTALL=$(ROOT)lib
TARGET=libgclass.a

#CSOURCES= si tenemos ficheros C definirlos aqui

include $(ROOT)Rules.make
