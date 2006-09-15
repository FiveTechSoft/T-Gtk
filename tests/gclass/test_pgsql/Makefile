# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

TARGET = test
SOURCES = test.prg 

# Para sistemas GNU/Linux
LIBS=-L/usr/lib/TGTK -lhbpg -L/usr/lib -lpq -lpgport -lkrb5 -lssl -lcrypt -lpthread

# Para sistemas Windows
#LIBS=-LC:/TGKT/lib -lhbpg -L'C:/Archivos de programa/PostgreSQL/8.1/lib' -lpq 

#Flags para sistemas GNU/Linux
CFLAGS+=-I../../include -I/usr/include -I/usr/include/libpq -I/usr/include/pgsql/server/libpq

include ../../../Rules.make 
