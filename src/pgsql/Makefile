##################################
#
# Makefile para librerias PgSql de Contrib en T-Gtk
#

TARGET=libhbpg.a
SOURCES = TPostgres.prg

PRGFLAGS=-I../../include
#Flags para sistemas WINDOWS

#Flags para sistemas GNU/Linux
CFLAGS+=-I../../include -I/usr/include -I/usr/include/libpq -I/usr/include/pgsql/server/libpq

TGTK_INSTALL=../../lib

CSOURCES=postgres.c
include ../../Rules.make

