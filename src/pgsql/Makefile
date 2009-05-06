##################################
#
# Makefile para librerias PgSql de Contrib en T-Gtk
#

TARGET=libhbpg.a
SOURCES = TPostgres.prg

PRGFLAGS=-I../../include

#Flags para sistemas WINDOWS
#INCLUDE_PQ = 'C:/Archivos de programa/PostgreSQL/8.1/include'
#Flags para sistemas WINDOWS
#CFLAGS+=-I../../include -I$(INCLUDE_PQ) -DHB_OS_WIN_32_USED


#Flags para sistemas GNU/Linux
CFLAGS+=-I../../include -I/usr/include -I/usr/include/libpq -I/usr/include/pgsql/server/libpq -I/usr/include/postgresql

TGTK_INSTALL=../../lib

CSOURCES=postgres.c
include ../../Rules.make

