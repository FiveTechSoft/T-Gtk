##################################
#
# Makefile para librerias PgSql de Contrib en T-Gtk
#
ROOT = ../../
include $(ROOT)setenv.mk

TARGET = libhbpg.a
ifeq ($(strip $(XBASE_COMPILER)),HARBOUR)
   SOURCEDIR=hb
else
   SOURCEDIR=xhb
endif
SOURCES  = $(SOURCEDIR)/tpostgre.prg $(SOURCEDIR)/pgrdd.prg
CSOURCES = $(SOURCEDIR)/postgres.c
PRGFLAGS=-I$(ROOT)include

ifeq ($(HB_MAKE_PLAT),win)
  #Flags para sistemas WINDOWS
  CFLAGS=-I$(POSTGRE_PATH) -DHB_OS_WIN_32_USED
else
  #Flags para sistemas GNU/Linux
  CFLAGS=-I$(ROOT)include -I/usr/include -I/usr/include/libpq \
	  -I/usr/include/pgsql/server/libpq -I/usr/include/postgresql
endif

include $(TGTK_DIR)/Rules.make

