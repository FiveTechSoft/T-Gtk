##############################################
# System Configure of T-Gtk.
# Version para:
# - GNU/Linux y Windows
# - Harbour o xHarbour
# (c)2004-11 Rafa Carmona.
# 
# Create: 11/28/05 # 15:47:14
##############################################

##############################################
ifneq ($(TGTK_GLOBAL),yes)
   $(info ejecutando global.mk )
   include $(ROOT)config/global.mk
endif

##############################################
# Compilador de Lenguaje C. 
# Opciones.
# Windows   =mingw32
# GNU/Linux =gcc 
##############################################
ifeq ($(HB_MAKE_PLAT),win)
  export HB_COMPILER =mingw32
else
  export HB_COMPILER =gcc
endif

ifeq ($(XBASE_COMPILER),HARBOUR)
  LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)hb
endif
ifeq ($(XBASE_COMPILER),XHARBOUR)
  LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)xhb
endif

# Generar setenv.mk
include $(ROOT)config/gensetenv.mk

# Verificamos PKG_CONFIG_PATH
include $(ROOT)config/pkgconfig.mk

# Revisamos las Rutas y Creamos los directorios si es necesario... (miquel)
include $(ROOT)config/dirs.mk

# Verificamos algunos binarios
include $(ROOT)config/check_bin.mk

# Verificamos Paquetes Disponibles
include $(ROOT)config/packages.mk 

##############################################

$(info *************************************************** )
$(info * Plataforma: $(HB_MAKE_PLAT).   Compilador: $(HB_COMPILER) ) 
$(info * Compilador XBase: $(XBASE_COMPILER)                 )
$(info * Rutas:                                              )
$(info * bin: $(HB_BIN_INSTALL)                              )
$(info * lib: $(HB_LIB_INSTALL)                              )
$(info * include: $(HB_INC_INSTALL)                          )
$(info *************************************************** )
$(info * Soporte.                                            )
$(info * GtkSourceView = $(GTKSOURCEVIEW)                    )
$(info * Bonobo        = $(BONOBO)                           )
$(info * gnomeDB       = $(GNOMEDB)                          )
$(info * CURL          = $(CURL)                             )
ifneq ($(HB_MAKE_PLAT),win)
   $(info * WebKitGTK+    = $(WEBKIT) )
endif
$(info * SQLite        = $(SQLITE)                           )
$(info * MySQL         = $(MYSQL)                            )
ifeq ($(MYSQL),yes)
  $(info *    Dolphin    = $(DOLPHIN)                          )
  ifeq ($(HB_MAKE_PLAT),win)
     $(info *    PATH    = $(MYSQL_PATH))
  endif
endif
$(info * PostgreSQL    = $(POSTGRE)                            )
ifeq ($(POSTGRE),yes)
  ifeq ($(HB_MAKE_PLAT),win)
     $(info *    PATH    = $(POSTGRE_PATH))
  endif
endif
$(info *************************************************** )


############################################## 
# Esqueleto para todas las plataformas
############################################## 

#Generic make options
LINKER = ar
CC = gcc
LIBRARIAN = ranlib


ifeq ($(HB_COMPILER),mingw32)
   CFLAGS +=-fms-extensions -Wall $(shell pkg-config --cflags tgtk)-mms-bitfields -ffast-math -D_HB_API_INTERNAL_
   ifeq ($(SUPPORT_PRINT_WIN32),yes)
     CFLAGS += $(shell pkg-config --cflags libgnomeprintui-2.2) 
   endif
else
   CFLAGS += -Wall -I. $(shell pkg-config --cflags tgtk) -D__HARBOUR64__
   ifeq ($(SUPPORT_PRINT_LINUX),yes)
     CFLAGS += $(shell pkg-config --cflags libgnomeprintui-2.2) -DHB_OS_LINUX
     LIBS += $(shell pkg-config --libs libgnomeprintui-2.2)
   endif
endif


ifeq ($(BONOBO),yes)
    CFLAGS += -D_HAVEBONOBO_
    CFLAGS += $(shell pkg-config --cflags libbonobo-2.0 ) $(shell pkg-config --cflags libbonoboui-2.0 )
    LIBS += $(shell pkg-config --libs libbonobo-2.0 ) $(shell pkg-config --libs libbonoboui-2.0 )
endif


ifeq ($(GTKSOURCEVIEW),yes)

   ifeq ($(findstring gtksourceview-2.0,$(PACKAGES)),)
      $(info ----------------------------------------)
      $(info *  ERROR GtkSourceView No Encontrado!  *)
      $(info ----------------------------------------)
      $(warning Error, aparentemente no existe o no localiza GtkSourceView )
   endif

   CFLAGS += -D_HAVEGTKSOURCEVIEW_
   CFLAGS += $(shell pkg-config --cflags gtksourceview-2.0)
   LIBS += $(shell pkg-config --libs gtksourceview-2.0 ) 
endif


ifeq ($(GNOMEDB),yes)
    CFLAGS += -D_GNOMEDB_
    CFLAGS += $(shell pkg-config --cflags libgnomedb-3.0)
    LIBS   += $(shell pkg-config --libs libgnomedb-3.0 )
endif


ifeq ($(CURL),yes)
    ifeq ($(findstring libcurl,$(PACKAGES)),)
       $(info ----------------------------------------)
       $(info *  ERROR libcURL  No Encontrado!       *)
       $(info ----------------------------------------)
       $(error Error, aparentemente no existe o no localiza libcURL )
    endif
    ifeq ($(HB_COMPILER),mingw32)
        ifeq ($(XBASE_COMPILER),XHARBOUR)
            CFLAGS += -D_CURL_
            CFLAGS +=-Ic:/curl/include -DHB_OS_WIN_32_USED
        else
            LIBFILES_ +=-lhbcurl
        endif
    else
        CFLAGS += -D_CURL_
        CFLAGS += $(shell pkg-config --cflags libcurl)
        LIBS += $(shell pkg-config --libs libcurl )
    endif
endif

ifneq ($(HB_MAKE_PLAT),win)
ifeq ($(WEBKIT),yes)
    ifeq ($(findstring webkit,$(PACKAGES)),)
      $(info ----------------------------------------)
      $(info *  ERROR WebKit  No Encontrado!       *)
      $(info ----------------------------------------)
      $(error Error, aparentemente no existe o no localiza WebKit )
    endif
    CFLAGS += -D_WEBKIT_
    CFLAGS += $(shell pkg-config --cflags webkit-1.0)
    LIBS += $(shell pkg-config --libs webkit-1.0 )
endif
endif

ifeq ($(SQLITE),yes)
  ifeq ($(HB_COMPILER),mingw32)
  else
     ifeq ($(findstring sqlite3,$(PACKAGES)),)
       $(info ----------------------------------------)
       $(info *  ERROR SQLite3  No Encontrado!       *)
       $(info ----------------------------------------)
       $(error Error, aparentemente no existe o no localiza SQLite )
     endif
     CFLAGS += $(shell pkg-config --cflags sqlite3)
     LIBS += $(shell pkg-config --libs sqlite3 ) 
  endif 
endif

ifeq ($(MYSQL),yes)
#    PRGFLAGS=-I../../include
    ifeq ($(HB_COMPILER),mingw32)
        #Flags para sistemas WINDOWS
        CFLAGS+=-I../../include -I$(MYSQL_PATH) -DHB_OS_WIN_32_USED -DWIN32 -D_WIN32 -D__WIN32__ 
    else
        #Flags para sistemas GNU/Linux
        CFLAGS+=-I../../include -I/usr/mysql/include
        #CFLAGS+=$(shell pkg-config --libs mysql-connector-net )
    endif
endif

ifeq ($(MYSQL),yes)
ifeq ($(DOLPHIN),yes)
    ifeq ($(HB_COMPILER),mingw32)
        #Flags para sistemas WINDOWS
        LIBS +=-L$(LIBDIR_TGTK_) -L./ -lmysql
        CFLAGS += -I$(INCLUDE_TGTK_PRG) -D__WIN__
        PRGFLAGS += -DNOINTERNAL-DDEBUG
        ifeq ($(XBASE_COMPILER),HARBOUR)
           LIBS+= -lhbct -lharbour-$(HB_VERSION) -lhbwin -lhbnf -lole32 -loleaut32 -lwinspool -luuid
        endif
    endif
endif
endif


ifeq ($(POSTGRE),yes)
#    PRGFLAGS=-I../../include
    ifeq ($(HB_COMPILER),mingw32)
        #Flags para sistemas WINDOWS
        CFLAGS+=-I$(POSTGRE_PATH) -DHB_OS_WIN_32_USED -DWIN32 -D_WIN32 \
                -D__WIN32__ 
    else
        #Flags para sistemas GNU/Linux
        CFLAGS+=-I../../include -I/usr/include -I/usr/include/libpq \
                -I/us/include/pgsql/server/libpq -I/usr/include/postgresql
    endif
endif



#
# Libraries for binary building
#

ifeq ($(HB_COMPILER),mingw32)
   LIBFILES_ += -luser32 -lwinspool -lole32 -loleaut32 -luuid -lgdi32 -lcomctl32 \
                -lcomdlg32 -lodbc32 -lwininet -lwsock32 -lodbc32 \
                -Wl,-subsystem,windows -mwindows -mconsole
   EXETYPE=.exe
else
   LIBFILES_ += 
   EXETYPE=
endif

#librerias usadas por Tgtk las definimos aqui. GTK y GLADE
LIBS += -L$(LIBDIR_TGTK_) $(shell pkg-config --libs tgtk ) 
PRGFLAGS += -I$(INCLUDE_TGTK_PRG)

# By Quim -->
# Soporte impresion para Win32, las libs de gnome van en este orden y despues de tgtk si no, no enlaza.
# <--
ifeq ($(SUPPORT_PRINT_WIN32),yes)
  LIBS += $(shell pkg-config --libs libgnomeprint-2.2) $(shell pkg-config --libs libgnomeprintui-2.2)
endif

#nos servira, para compilar prgs exclusivos para GNU/Linux
#por ejemplo, gPrinter.prg
ifeq ($(HB_COMPILER),gcc)
   PRGFLAGS += -DHB_OS_LINUX
endif   

ifneq ($(HB_MAKE_PLAT),win)
   OS_LIBS += -ldl -lz
endif


HB_LIBDIR_ = $(LIBDIR) -L$(HB_LIB_INSTALL)
#XHB_LIBDIR_ = $(LIBDIR) -L$(XHB_LIB_INSTALL)

HB_LIBS_= -L$(LIBDIR_TGTK_) -lgclass -lhbgtk -Wl,--start-group -L$(HB_LIB_INSTALL) \
        $(HB_LIBFILES_)$(OS_LIBS) $(LIBFILES_) -Wl,--end-group $(LIBS)
#XHB_LIBS_= -L$(LIBDIR_TGTK_) -lgclass -lhbgtk -Wl,--start-group -L$(XHB_LIB_INSTALL) \
#        $(XHB_LIBFILES_) $(LIBFILES_) -Wl,--end-group $(LIBS)

#FLAGS a Pasar a Harbour
ifeq ($(HB_FLAGS),)
   HB_FLAGS = -w$(HB_WL) -q$(HB_QUIET) -gc0 -n \
              $(subst no,,$(subst yes,-gh,$(HB_HRB_OUT)))  \
              $(subst no,,$(subst yes,-p,$(HB_GEN_PPO)))  \
              $(subst no,,$(subst yes,-p+,$(HB_GEN_PPT)))  \
              $(subst no,,$(subst yes,-l,$(HB_LINES)))  \
              $(subst no,,$(subst yes,-v,$(HB_ASSUME_VARS)))  \
              $(subst no,,$(subst yes,-b,$(HB_DEBUG_INFO))) 
   ifneq ($(HB_DEFINE),)
      HB_FLAGS += -d$(HB_DEFINE)
   endif
endif

ifeq ($(strip $(SOURCE_TYPE)),)
SOURCE_TYPE=prg
endif

#Sources / object determination rule
#subidr might override this file by providing a makefile.sources
ifeq ($(strip $(SOURCES)),)
SOURCES=$(wildcard *.$(SOURCE_TYPE))
endif

ifeq ($(strip $(OBJECTS)),)
OBJECTS=$(patsubst %.$(SOURCE_TYPE),%.o,$(SOURCES))
ifneq ($(strip $(CSOURCES)),)
OBJECTS+=$(patsubst %.c,%.o,$(CSOURCES))
endif
ifneq ($(strip $(CPPSOURCES)),)
   OBJECTS+=$(patsubst %.cpp,%.o,$(CPPSOURCES))
endif
endif


#COMMANDS
all:$(TARGET) $(TARGETS)
win:$(TARGET) $(TARGETS)
linux:$(TARGET) $(TARGETS)

.PHONY: clean install 

%$(EXETYPE):%.o
	$(CC) -o$@ $< $(HB_LIBDIR_) $(HB_LIBS_)

%.o: %.c
	$(CC) -c -o$@ $(CFLAGS) $(HB_CFLAGS) -I$(HB_INC_INSTALL) $<

%.o: %.cpp
	$(CC) -c -o$@ $(CFLAGS) $(HB_CFLAGS) -I$(HB_INC_INSTALL) $<

%.c: %.prg
	$(HB_BIN_INSTALL)/harbour $(strip $(HB_FLAGS)) $(PRGFLAGS) -I$(HB_INC_INSTALL)  -o$@ $<

$(TARGET): $(OBJECTS)
ifeq ( lib , $(patsubst %.a, lib, $(TARGET)))
	$(LINKER) -r $(TARGET) $(OBJECTS)
	$(LIBRARIAN) $(TARGET)
else
	$(CC) -o $(TARGET) $(OBJECTS) $(HB_LIBDIR_) $(HB_LIBS_)
endif


clean:
ifeq ($(HB_COMPILER),mingw32)
	del *.o
	del *.ppo
	del $(TARGET)
	del $(TARGET).exe
else
	rm -f *.o
	rm -f *.ppo
	rm -f $(TARGET)
	rm -f $(TARGET).exe
	rm -f $(TARGETS)
endif

install: all
ifeq ($(HB_COMPILER),mingw32)
	xcopy /Y *.a $(LIBDIR_TGTK_)
else
	cp -f *.a $(LIBDIR_TGTK_)
endif

