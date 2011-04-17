##################################
#
# Makefile para librerias MySql de Contrib en T-Gtk
#
ROOT = ../../
TARGET=libhbmysql.a
SOURCES = tmysql.prg tsqlbrw.prg

PRGFLAGS=-I$(ROOT)include
#Flags para sistemas WINDOWS
CFLAGS+=-I$(ROOT)include -I'C:/Archivos de programa/MySQL/MySQL Server 5.0/include' -DHB_OS_WIN_32_USED -DWIN32 -D_WIN32 -D__WIN32__ 

#Flags para sistemas GNU/Linux
#CFLAGS+=-I$(ROOT)include -I/usr/mysql/include

TGTK_INSTALL=$(ROOT)lib

CSOURCES=mysql.c
include $(ROOT)Rules.make
