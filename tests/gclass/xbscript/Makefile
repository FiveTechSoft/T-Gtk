# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../

include $(ROOT)config/global.mk

TARGET = testscript
SOURCES = prgscrpt.prg xbscript.prg

ifeq ($(XBASE_COMPILER),HARBOUR)
  SOURCES = hbrun.prg hbscript.prg 
  LIBS    =-lhbcplr -lhbpp -lhbcommon
else
  ifeq ($(HB_MAKE_PLAT),win)
     LIBS += -lharbour-$(HB_VERSION)
  endif
endif


include $(ROOT)Rules.make

