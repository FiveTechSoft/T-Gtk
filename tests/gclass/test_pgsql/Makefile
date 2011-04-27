# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT =../../../

TARGET =test
SOURCES = main.prg test.prg

include $(ROOT)config/global.mk

ifneq ($(HB_MAKE_PLAT),win)
# Para sistemas GNU/Linux
   LIBS=-L$(LIBDIR_TGTK) -lhbpg -L/usr/lib -lpq \
	-lpgport -lkrb5 -lssl -lcrypt -lpthread 
   CFLAGS+=-I$(ROOT)include -I/usr/include \
	   -I/usr/include/libpq -I/usr/include/pgsql/server/libpq
else
# Para sistemas Windows
   LIBS=-lhbpg -L$(POSTGRE_PATH) -lpq 
   $(info $(LIBS) )
   exit
endif

include $(ROOT)Rules.make 
