##################################
#
# Makefile para librerias PgSql de Contrib en T-Gtk
#

include ../../config/global.mk

TARGET = libhbpg.a
ifeq ($(XBASE_COMPILER),HARBOUR)
   SOURCEDIR=hb
else
   SOURCEDIR=xhb
endif
SOURCES  = $(SOURCEDIR)/tpostgre.prg $(SOURCEDIR)/pgrdd.prg
CSOURCES = $(SOURCEDIR)/postgres.c
PRGFLAGS=-I../../include

ifeq ($(HB_MAKE_PLAT),win)
  #Flags para sistemas WINDOWS
  INCLUDE_PQ= '$(PROGRAMFILES)/PostgreSQL/9.0/include'
  #Flags para sistemas WINDOWS
  CFLAGS=-I$(INCLUDE_PQ) -DHB_OS_WIN_32_USED

else
  #Flags para sistemas GNU/Linux
  CFLAGS=-I../../../include -I/usr/include -I/usr/include/libpq \
	  -I/usr/include/pgsql/server/libpq -I/usr/include/postgresql
endif

include $(TGTK_DIR)/Rules.make

