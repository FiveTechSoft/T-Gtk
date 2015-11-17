##################################
#
# Makefile para librerias en codigo .PRG
#

ROOT = ../../
include $(ROOT)config/global.mk
include $(ROOT)$(SETENV)

TARGET=libtimprime.a
SOURCES= timprimepdf.prg tutilpdf.prg
CSOURCES= ./C/grid_sheet.c

export HPDF=yes

include $(TGTK_DIR)/Rules.make
