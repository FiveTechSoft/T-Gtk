##################################
#
# Makefile para librerias MySql de Contrib en T-Gtk
#
ROOT = ../../
include $(ROOT)config/global.mk
include $(ROOT)$(SETENV)

TARGET = libhbmysql.a
ifeq ($(strip $(XBASE_COMPILER)),HARBOUR)
   SOURCEDIR=hb
   SOURCES  = $(SOURCEDIR)/tmysql.prg $(SOURCEDIR)/tsqlbrw.prg
   #SOURCES  = tmysql.prg tsqlbrw.prg
else
   SOURCEDIR=xhb
   SOURCES  = $(SOURCEDIR)/tmysql.prg 
endif
CSOURCES = $(SOURCEDIR)/mysql.c
PRGFLAGS=-I$(ROOT)include

ifeq ($(HB_MAKE_PLAT),win)
  #Flags para sistemas WINDOWS
  CFLAGS=-I$(MYSQL) -DHB_OS_WIN_32_USED

  #Si no esta libmysql.a, procede a generarla...
  ifeq ($(notdir $(wildcard $(subst \,/,./libmysql.a))),)
     $(info Generando libmysql.a )
     $(shell genlibmysql.bat > %TEMP%\out.log )
  endif

else
 
  #Flags para sistemas GNU/Linux
  CFLAGS=-I$(ROOT)include -I/usr/include -I/usr/include/mysql 

endif


include $(TGTK_DIR)/Rules.make

