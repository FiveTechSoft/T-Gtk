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

ifeq ($(subst $(SPACE),,$(XBASE_COMPILER)),HARBOUR)
  HB_SHORTNAME=hb$(HB_VERSION)
endif
ifeq ($(subst $(SPACE),,$(XBASE_COMPILER)),XHARBOUR)
  HB_SHORTNAME=xhb$(HB_VERSION)
endif

# Generar setenv.mk
include $(ROOT)config/gensetenv.mk

# Obtenemos nombre generico de plataforma (PLATFORM_NAME)
include $(ROOT)config/platform_name.mk

# Revisamos las Rutas y Creamos los directorios si es necesario... (miquel)
DIR_OBJ := $(subst $(SPACE),,$(DIR_OBJ))
ifeq ($(DIR_OBJ),)
  export DIR_OBJ :=.$(DIRSEP)obj$(DIRSEP)$(PLATFORM_NAME)$(HB_SHORTNAME)$(DIRSEP)$(DIRSEP)
  ifeq ($(HB_MAKE_PLAT),linux)
     export DIR_OBJ :=.$(DIRSEP)obj$(DIRSEP)$(PLATFORM_NAME)$(HB_SHORTNAME)$(DIRSEP)
  endif
endif

# Verificamos PKG_CONFIG_PATH
include $(ROOT)config/pkgconfig.mk

# Directorio de librerias de t-gtk
#$(info $(LIBDIR_TGTK_))
ifeq ($(HB_MAKE_PLAT),win)
   ifeq ($(BIN_PLATFORM_NAME),yes)
      LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(PLATFORM_NAME)$(HB_SHORTNAME)
   else
      LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(HB_MAKE_PLAT)_$(HOST_PLAT)$(DIRSEP)$(HB_SHORTNAME)
   endif
else
   LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(PLATFORM_NAME)$(HB_SHORTNAME)
endif
#LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(subst .,,$(DIR_OBJ))

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
$(info * Gtk MultiThread  = $(GTK_THREAD)                    )
$(info * GtkSourceView    = $(GTKSOURCEVIEW)                    )
$(info * Gtk-Extra        = $(GTK_EXTRA)                        )
$(info * Bonobo           = $(BONOBO)                           )
$(info * Gnome Data Access= $(GDA)                              )
$(info * CURL             = $(CURL)                             )
ifneq ($(HB_MAKE_PLAT),win)
   $(info * WebKitGTK+       = $(WEBKIT) )
   $(info * Terminal Widget  = $(VTE) )
endif
$(info * SQLite           = $(SQLITE)                           )
$(info * MySQL            = $(MYSQL)                            )
ifeq ($(MYSQL),yes)
  $(info *    Dolphin       = $(DOLPHIN)                          )
  ifeq ($(HB_MAKE_PLAT),win)
     $(info *    PATH       = $(MYSQL_PATH))
  endif
endif
$(info * PostgreSQL       = $(POSTGRE)                            )
ifeq ($(POSTGRE),yes)
  ifeq ($(HB_MAKE_PLAT),win)
     $(info *    PATH       = $(POSTGRE_PATH))
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

#librerias usadas por Tgtk las definimos aqui. GTK y GLADE
LIBS += -L$(LIBDIR_TGTK_) $(shell pkg-config --libs tgtk )
# agregar despues a libgclass 
LIBS += -L$(LIBDIR_TGTK_) $(TGTK_LIBS) 
PRGFLAGS += -I$(INCLUDE_TGTK_PRG)

ifeq ($(HB_COMPILER),mingw32)
   CFLAGS +=-fms-extensions -Wall $(shell pkg-config --cflags tgtk)-mms-bitfields -ffast-math -D_HB_API_INTERNAL_
   CFLAGS +=-D__PLATFORM__WINDOWS
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

CFLAGS += -I$(INCLUDE_TGTK_PRG)

ifeq ($(GTK_MAJOR_VERSION),3)
#    CFLAGS += -D_GTK$(GTK_MAJOR_VERSION)_ -D_GTK_$(GTK_MAJOR_VERSION).$(GTK_MINOR_VERSION)_
    LIBS +=$(shell pkg-config --cflags --libs gtk+-3.0)
else
#   CFLAGS += -D_GTK$(GTK_MAJOR_VERSION)_ -D_GTK_$(GTK_MAJOR_VERSION).$(GTK_MINOR_VERSION)_
    LIBS +=$(shell pkg-config --cflags --libs gtk+-2.0)
    LIBS +=$(shell pkg-config --libs libglade-2.0)
endif

ifeq ($(BONOBO),yes)
    CFLAGS += -D_HAVEBONOBO_
    CFLAGS += $(shell pkg-config --cflags libbonobo-2.0 ) $(shell pkg-config --cflags libbonoboui-2.0 )
    LIBS += $(shell pkg-config --libs libbonobo-2.0 ) $(shell pkg-config --libs libbonoboui-2.0 )
endif


ifeq ($(GTK_THREAD),yes)
    CFLAGS += -D_GTK_THREAD_
    LIBS += $(shell pkg-config --libs gthread-2.0 )
endif


ifeq ($(GTK_EXTRA),yes)
    CFLAGS += $(shell pkg-config --cflags gtkextra-3.0) -D_GTKEXTRA_
    LIBS += $(shell pkg-config --libs gtkextra-3.0) 
    TGTK_LIBS += -lhbgtkextra
endif


ifeq ($(GTKSOURCEVIEW),yes)

   ifeq ($(findstring gtksourceview-2.0,$(PACKAGES)),)
      $(info ----------------------------------------)
      $(info *  ERROR GtkSourceView No Encontrado!  *)
      $(info ----------------------------------------)
      $(error Error, aparentemente no existe o no localiza GtkSourceView )
   endif

   CFLAGS += -D_HAVEGTKSOURCEVIEW_
   CFLAGS += $(shell pkg-config --cflags gtksourceview-2.0)
   LIBS += $(shell pkg-config --libs gtksourceview-2.0 ) 
endif


ifeq ($(GDA),yes)
    CFLAGS += -D_GDA_
    CFLAGS += $(shell pkg-config --cflags libgda-$(GDA_VERSION))
    LIBS   += $(shell pkg-config --libs libgda-$(GDA_VERSION) )
endif

ifeq ($(LIBGD),yes)
    CFLAGS += $(shell pkg-config --cflags gdlib)
    LIBS   += $(shell pkg-config --libs gdlib )
endif

ifeq ($(CURL),yes)
    ifeq ($(findstring libcurl,$(PACKAGES)),)
       $(info ----------------------------------------)
       $(info *  ERROR libcURL  No Encontrado!       *)
       $(info ----------------------------------------)
       $(error Error, aparentemente no existe o no localiza libcURL )
    endif
    CFLAGS +=-D_CURL_
    CFLAGS +=$(shell pkg-config --cflags libcurl )
    LIBS += $(shell pkg-config --libs libcurl )
    TGTK_LIBS += -lcurl-hb
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
  #-- Terminal Widget
  ifeq ($(VTE),yes)
    LIBS +=-L$(LIBDIR_TGTK_) -lhbvte $(shell pkg-config --libs vte)
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
        #lower a la ruta MYSQL_PATH para luego sustituir include por lib.
        LIBMYSQL_PATH:=$(call lc,$(MYSQL_PATH))
        LIBS +=-L$(subst include,lib,$(LIBMYSQL_PATH)) -lmysql #-lmysqlclient
        LIBS +=-L$(LIBDIR_TGTK) -lmysql #-lmysqlclient
    else
        #Flags para sistemas GNU/Linux
        CFLAGS+=-I../../include -I/usr/mysql/include
        #CFLAGS+=$(shell pkg-config --libs mysql-connector-net )
    endif
    TGTK_LIBS += -lhbmysql

    ifeq ($(DOLPHIN),yes)
       ifeq ($(HB_COMPILER),mingw32)
           #Flags para sistemas WINDOWS
           CFLAGS += -I$(INCLUDE_TGTK_PRG) -D__WIN__
           PRGFLAGS += -DNOINTERNAL-DDEBUG
       endif
       TGTK_LIBS += -ltdolphin

    endif

endif


ifeq ($(POSTGRE),yes)
#    PRGFLAGS=-I../../include
    ifeq ($(HB_COMPILER),mingw32)
        #Flags para sistemas WINDOWS
        LIBS+=-L$(POSTGRE_PATH) -lpq
        CFLAGS+=-I$(POSTGRE_PATH) -DHB_OS_WIN_32_USED -DWIN32 -D_WIN32 \
                -D__WIN32__ 
    else
        #Flags para sistemas GNU/Linux
        CFLAGS+=-I$(ROOT)include -I/usr/include -I/usr/include/libpq \
                -I/usr/include/postgresql/ -I/usr/include/postgresql/libpq \
                -I/usr/include/pgsql/server/libpq -I/usr/include/postgresql/libpq
        LIBS+= -L/usr/lib -lpq -lpgport -lkrb5 -lssl -lcrypt
    endif
    TGTK_LIBS += -lhbpg
endif



#
# Libraries for binary building
#

ifeq ($(HB_COMPILER),mingw32)
   LIBFILES_ += -luser32 -lwinspool -lole32 -loleaut32 -luuid -lgdi32 -lcomctl32 \
                -lcomdlg32 -lodbc32 -lwininet -lwsock32 -lws2_32 -lodbc32 -liphlpapi \
                -Wl,-subsystem,windows -mwindows -mconsole 
   EXETYPE=.exe
else
   LIBFILES_ += 
   EXETYPE=
endif

#librerias usadas por Tgtk las definimos aqui. GTK y GLADE
#LIBS += -L$(LIBDIR_TGTK_) $(shell pkg-config --libs tgtk )
# agregar despues a libgclass 
#LIBS += -L$(LIBDIR_TGTK_) $(TGTK_LIBS) 
#PRGFLAGS += -I$(INCLUDE_TGTK_PRG)

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
   OS_LIBS += -ldl -lz -lm $(shell pkg-config --cflags --libs libpcre) 
else
   #OS_LIBS += -ldl
endif


HB_LIBDIR_ = $(LIBDIR) -L$(HB_LIB_INSTALL)
#XHB_LIBDIR_ = $(LIBDIR) -L$(XHB_LIB_INSTALL)

#HB_LIBS_+= -L$(LIBDIR_TGTK_) $(TGTK_LIBS) -lgclass -lhbgtk -Wl,--start-group -L$(HB_LIB_INSTALL) 
#HB_LIBS_+= -L$(LIBDIR_TGTK_) $(TGTK_LIBS) -lhbgtk -lgclass -Wl,--start-group -L$(HB_LIB_INSTALL) 
HB_LIBS_+= -L$(LIBDIR_TGTK_) -lhbgtk -lgclass $(TGTK_LIBS) -Wl,--start-group -L$(HB_LIB_INSTALL) \
        $(HB_LIBFILES_) $(OS_LIBS) $(LIBFILES_) -Wl,--end-group \
        $(LIBS) $(OS_LIBS)
#        -L$(LIBDIR_TGTK_) -lhbgtk -lgclass $(TGTK_LIBS) 
#XHB_LIBS_= -L$(LIBDIR_TGTK_) -lgclass -lhbgtk -Wl,--start-group -L$(XHB_LIB_INSTALL) \
#        $(XHB_LIBFILES_) $(LIBFILES_) -Wl,--end-group $(LIBS)

#FLAGS a Pasar a Harbour o xHarbour
ifeq ($(HB_FLAGS),)
   HB_FLAGS = -w$(HB_WL) -q$(HB_QUIET) -gc0 -n \
              $(subst no,,$(subst yes,-kM,$(HB_MACROTEXT_SUBS)))  \
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

# En Windows si se define fichero de recursos, generamos el objeto.
# Si desea crear un icono, muy simple: 
# Abre Gimp y pega las diferentes imagenes (tamaños) como capas,
# luego guardar con extension .ico y listo!
RESOURCE =
ifeq ($(HB_MAKE_PLAT),win) 
  ifeq ($(RESOURCE_FILE),)
  else
     RESOURCE = $(DIR_OBJ)win_resource.o
     $(info Objeto de recursos (Windows): $(RESOURCE) )
     $(info )
  endif
endif

ifeq ($(strip $(OBJECTS)),)
  OBJECTS=$(patsubst %.$(SOURCE_TYPE),$(DIR_OBJ)%.o,$(SOURCES))
  ifneq ($(strip $(CSOURCES)),)
    OBJECTS+=$(patsubst %.c,$(DIR_OBJ)%.o,$(CSOURCES))
  endif
  ifneq ($(strip $(CPPSOURCES)),)
    OBJECTS+=$(patsubst %.cpp,$(DIR_OBJ)%.o,$(CPPSOURCES))
  endif
endif

# Determinamos si agregar datos de plataforma en el binario a crear.
ifeq ($(BIN_PLATFORM_NAME),)
  $(info *----------------------------------------------------------*)
  $(info Si define la Variable BIN_PLATFORM_NAME=yes en su setenv.mk )
  $(info podra  generar el  nombre del  binario con los  datos de la )
  $(info plataforma en que se compila. )
  $(info *----------------------------------------------------------*)
endif
ifeq ($(BIN_PLATFORM_NAME),yes)
  ifneq ( lib , $(patsubst %.a, lib, $(TARGET)))
    VARTEMP := $(subst $(DIRSEP)$(DIRSEP),,$(PLATFORM_NAME)_$(HB_SHORTNAME))
    TARGET := $(TARGET)_$(subst $(DIRSEP),_,$(subst .,,$(VARTEMP)))
    TARGET := $(subst __,_,$(TARGET))
    TARGET := $(patsubst %_,%,$(TARGET))
  endif
endif


#COMMANDS
all:$(TARGET) $(TARGETS)
win:$(TARGET) $(TARGETS)
linux:$(TARGET) $(TARGETS)

.PHONY: clean install 

%$(EXETYPE):$(DIR_OBJ)%.o
	$(CC) -o$@ $< $(HB_LIBDIR_) $(HB_LIBS_)

$(DIR_OBJ)%.o: %.c
	$(CC) -c -o$@ $(CFLAGS) $(HB_CFLAGS) -I$(HB_INC_INSTALL) $(HB_INC_3RD) $<

$(DIR_OBJ)%.o: %.cpp
	$(CC) -c -o$@ $(CFLAGS) $(HB_CFLAGS) -I$(HB_INC_INSTALL) $(HB_INC_3RD) $<

%.c: %.prg
	$(HB_BIN_INSTALL)$(DIRSEP)harbour $(strip $(HB_FLAGS)) $(PRGFLAGS) -I$(HB_INC_INSTALL) $(HB_INC_3RD) -o$@ $<

$(TARGET): $(OBJECTS)
ifeq ( lib , $(patsubst %.a, lib, $(TARGET)))
	$(LINKER) -r $(TARGET) $(OBJECTS)
	$(LIBRARIAN) $(TARGET)
else
  ifeq ($(RESOURCE),)
	$(CC) -o $(TARGET) $(OBJECTS) $(HB_LIBDIR_) $(HB_LIBS_) 
  else
	windres $(RESOURCE_FILE) $(RESOURCE) 
	$(CC) -o $(TARGET) $(OBJECTS) $(RESOURCE) $(HB_LIBDIR_) $(HB_LIBS_) 
  endif
endif


clean:
ifeq ($(HB_COMPILER),mingw32)
	del $(DIR_OBJ)*.o
	del *.ppo
	del $(TARGET)
	del $(TARGET).exe
else
	rm -f $(patsubst %,%*.o,$(O_DIR))
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

