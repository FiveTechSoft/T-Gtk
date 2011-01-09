# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../

#include $(ROOT)config/global.mk

TARGET = testscript
SOURCES = prgscrpt.prg xbscript.prg

#ifndef __XHARBOUR__
  SOURCES = hbrun.prg hbscript.prg 
  LIBS    =-lhbcplr -lhbpp -lhbcommon
#else
  LIBS += -lharbour-$(HB_VERSION)
#endif


include $(ROOT)Rules.make

