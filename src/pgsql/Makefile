##################################
#
# Makefile para librerias MySql de Contrib en T-Gtk
#

TARGET=libhbpg.a
SOURCES = TPostgres.prg

PRGFLAGS=-I../../include
#Flags para sistemas WINDOWS
#CFLAGS+=-I../../include -I'C:/Archivos de programa/MySQL/MySQL Server 5.0/include' -DHB_OS_WIN_32_USED -DWIN32 -D_WIN32 -D__WIN32__ 

#Flags para sistemas GNU/Linux
CFLAGS+=-I../../include -I/usr/include -I/usr/include/libpq -I/usr/include/pgsql/server/libpq

TGTK_INSTALL=../../lib

CSOURCES=postgres.c
include ../../Rules.make


#ROOT = ../../

#C_SOURCES=postgres.c

#PRG_SOURCES=TPostgres.prg  

#LIBNAME=hbpg

#include $(TOP)$(ROOT)config/lib.cf

#ifeq ($(HB_COMPILER),mingw32)
#   CFLAGS := $(CFLAGS) -I/postgres/include
#else
#   CFLAGS := $(CFLAGS) -I/usr/share/pgsql/include -I/usr/share/pgsql/include/libpq -I/usr/include/pgsql
#endif
