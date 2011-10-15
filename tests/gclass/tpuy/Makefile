# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../

include $(ROOT)config/global.mk

TARGET = tpuy
SOURCES  = main.prg        \
           tpublic.prg     \
           hbrun.prg       \
	   connto.prg      \
           tools01.prg     \

#	   filechooser.prg \
           about.prg       \
           testqry1.prg    \
           xml.prg 


LIBS =-ltdolphin -lhbct 

ifeq ($(HB_MAKE_PLAT),win)
#   LIBS    =-lhbcplr -lhbpp -lhbcommon -lhbnetio -lhbrtl -lwininet -lwsock32 -lws2_32
    LIBS +=-lhbcplr -lhbtip
else
   LIBS +=-lmysqlclient
endif


ifeq ($(XBASE_COMPILER),HARBOUR)
  ifeq ($(HB_MAKE_PLAT),win)
     LIBS += -lharbour-$(HB_VERSION)
  endif
endif

PRGFLAGS=-I./include 




include $(ROOT)Rules.make

