##################################
#
# Makefile para librerias PgSql de Contrib en T-Gtk
#
ROOT = ../../
include $(ROOT)setenv.mk
include $(ROOT)config/global.mk

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

  #Si no esta libpq.a, procede a generarla...
  ifeq ($(notdir $(wildcard $(subst \,/,./libpq.a))),)
     $(info Generando libpq.a )
     $(shell dlltool -d libpqdll.def -D libpq.dll -k -l libpq.a -S as.exe )
  endif

else
 
  #Flags para sistemas GNU/Linux
  CFLAGS=-I$(ROOT)include -I/usr/include -I/usr/include/libpq \
	  -I/usr/include/pgsql/server/libpq -I/usr/include/postgresql

endif


include $(TGTK_DIR)/Rules.make

