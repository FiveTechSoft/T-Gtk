# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

TARGET = test
SOURCES = test.prg 

LIBS=-L/usr/lib/TGTK -lhbpg -L/usr/lib -lpq -lpgport -lkrb5 -lssl -lcrypt -lpthread
#LIBS=-lhbpg
#LIBS=-Lc:/TGTK/lib -lmysql_w32 

#Flags para sistemas GNU/Linux
CFLAGS+=-I../../include -I/usr/include -I/usr/include/libpq -I/usr/include/pgsql/server/libpq


include ../../../Rules.make 

