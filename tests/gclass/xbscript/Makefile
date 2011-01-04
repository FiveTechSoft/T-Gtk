# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../

TARGET = testscript
SOURCES = prgscrpt.prg xbscript.prg

#ifndef __XHARBOUR__
  SOURCES = hbrun.prg hbscript.prg 
  LIBS    =-lhbcplr -lhbpp -lhbcommon
#endif


include $(ROOT)Rules.make

