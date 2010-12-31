######################################################################
# Please, use tool /utils/config_system/configure for create this file
# OR modify correct the paths.
######################################################################

##################################################
# System Configure of T-Gtk.
# Version para el S.O Windows y para HARBOUR
# (c)2004-05 Rafa Carmona.
# 
# Create: 11/28/05 # 15:47:14
##################################################
 
# Para tener soporte de impresion en GNU/Linux a traves de gnome.
# tenemos que tener instalado el paquete libgnomeprintui22-devel,
# si queremos realizar la aplicacion con soporte de impresion.
# Aqui , especificaremos los cFlags de compilacion necesarios para C
SUPPORT_PRINT_LINUX=no

# 20-12-2005 by Joaquim Ferrer <quim_ferrer@yahoo.es>
# Soporte de Impresion para Win32
# Es necesario tener instalado el pack de soporte para impresion
# de gnome, portado a Win32, gtk-win32-gnomeprint-2-2 instalado
# en el path de Gtk+, si no es asi, SUPPORT_PRINT_WIN32=no -->
SUPPORT_PRINT_WIN32=no

#Especifica aqui, si lo necesitas por no tenerlo en el entorno, SET,
#las rutas del compilador de Harbour.
#Bajo Windows especificar mingw32, bajo linux especificar gcc.
ifeq ($(HB_COMPILER),)
HB_COMPILER=gcc
endif   
 
#Especificamos compilador xBase a usar, si harbour o xHarbour
ifeq ($(XBASE_COMPILER),)
XBASE_COMPILER = HARBOUR
endif

#Nueva version harbour 1.1
ifeq ($(HB_COMPILER),gcc)
HB_BIN_INSTALL = /usr/local/bin
HB_INC_INSTALL = /usr/local/include/harbour
HB_LIB_INSTALL = /usr/local/lib/harbour
else
HB_BIN_INSTALL = /harbour/bin
HB_INC_INSTALL = /harbour/bin/include
HB_LIB_INSTALL = /harbour/bin/lib
endif 

#Rutas de librerias y de includes de TGTK.
LIBDIR_TGTK= ./lib
INCLUDE_TGTK_PRG=./include

#Soporte para GtkSourceView
GTKSOURCEVIEW=no

#Soporte para Bonobo
BONOBO=no

#Alpha. Soporte para GNOMEDB y LIBGDA
GNOMEDB=no

#Soporte para CURL
CURL=no

#Soporte para WebKit
WEBKIT=yes

############################################## 
# Esqueleto para todas las plataformas
############################################## 

#Generic make options
LINKER = ar
CC = gcc
LIBRARIAN = ranlib

#Definition GT driver
ifeq ($(HB_COMPILER),mingw32)
   GT_LIBS=-lgtwin
else
   ifeq ($(XBASE_COMPILER),HARBOUR)
      #HARBOUR
      GT_LIBS=-lgtstd 
   else
      #XHARBOUR
      GT_LIBS=-lgtstd -lgttrm
   endif
endif


ifeq ($(HB_COMPILER),mingw32)
   CFLAGS +=-fms-extensions -Wall $(shell pkg-config --cflags tgtk)-mms-bitfields -ffast-math -D_HB_API_INTERNAL_
   ifeq ($(SUPPORT_PRINT_WIN32),yes)
     CFLAGS += $(shell pkg-config --cflags libgnomeprintui-2.2) 
   endif
else
   CFLAGS += -Wall -I. $(shell pkg-config --cflags tgtk)
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
   CFLAGS += -D_HAVEGTKSOURCEVIEW_
   CFLAGS += $(shell pkg-config --cflags gtksourceview-2.0)
   LIBS += $(shell pkg-config --libs gtksourceview-2.0 ) 
endif


ifeq ($(GNOMEDB),yes)
    CFLAGS += -D_GNOMEDB_
    CFLAGS += $(shell pkg-config --cflags libgnomedb-3.0)
    LIBS += $(shell pkg-config --libs libgnomedb-3.0 )
endif


ifeq ($(CURL),yes)
    CFLAGS += -D_CURL_
    CFLAGS += $(shell pkg-config --cflags libcurl)
    LIBS += $(shell pkg-config --libs libcurl )
endif

ifeq ($(WEBKIT),yes)
    CFLAGS += -D_WEBKIT_
    CFLAGS += $(shell pkg-config --cflags webkit-1.0)
    LIBS += $(shell pkg-config --libs webkit-1.0 )
endif


ifeq ($(XBASE_COMPILER),HARBOUR)
   CFLAGS += -D_HB_API_INTERNAL_ -DHB_ARRAY_USE_COUNTER_OFF -D__COMPATIBLE_HARBOUR__ -D__HARBOUR20__
endif

#libraries for binary building
ifeq ($(HB_MT),MT)
   LIBFILES_ = -ldebug -lvmmt -lrtlmt $(GT_LIBS) -lrddmt -lrtlmt -lvmmt -lmacro -lppmt -ldbfntxmt -ldbfcdx -ldbfdbt -lcommon -lm -lpthread
else
   ifeq ($(HB_COMPILER),mingw32)
     ifeq ($(XBASE_COMPILER),XHARBOUR)
         # XHARBOUR  . tenemos para 0.99.51(dbfdbt) y 0.99.60
         #LIBFILES_ =  -ldebug -lvm -lrtl $(GT_LIBS) -llang -lrdd -lrtl -lvm -lmacro -lpp -ldbfntx -ldbfcdx -ldbfdbt -ldbffpt -lrtl -lcommon -lm -lgtwin $(GT_LIBS) -lgtnul -lgtwin 
         LIBFILES_ = -lvm -lrtl -llang -lrdd -lmacro -lpp -ldbfntx -ldbfcdx -ldbffpt -lhbsix -lhsx -lpcrepos -lcommon -lm -lgtwin -lgtnul $(GT_LIBS) -lstdc++ -lhbzip 
     else
         # HARBOUR
         #LIBFILES_ =  -ldebug -lvm -lrtl $(GT_LIBS) -llang -lrdd -lrtl -lvm -lmacro -lpp -ldbfntx -ldbfcdx -ldbfdbt -lcommon -lm -lgtwin $(GT_LIBS) -lgtwin
         LIBFILES_ = -lhbvm -lhbrtl $(GT_LIBS) -lhblang -lhbrdd -lhbmacro -lhbpp -lhbdbfntx -lhbdbfcdx -lhbdbffpt -lhbsix -lhsx -lhbcommon -lhbm -lgtgui $(GT_LIBS) 
     endif
   else
     ifeq ($(XBASE_COMPILER),XHARBOUR)
        # XHARBOUR
        #LIBFILES_ = -ldebug -lvm -lrtl -lgtnul -lgtcrs -lncurses -llang -lrdd -lrtl -lvm -lmacro -lpp -ldbfntx -ldbfdbt -ldbfcdx -lrtl -lcommon -lm
        LIBFILES_ = -lvm -lrtl -llang -lrdd -lmacro -lpp -ldbfntx -ldbfcdx -ldbffpt -lcommon -lm -lhbsix -lpcrepos $(GT_LIBS) -lcodepage -lct -ltip
     else
        # HARBOUR
        # LIBFILES_ =  -ldebug -lvm -lrtl $(GT_LIBS) -llang -lrdd -lrtl -lvm -lmacro -lpp -ldbfntx -ldbfcdx -ldbfdbt -lcommon -lm  $(GT_LIBS)
        LIBFILES_ = -lhbrtl -lhblang -lhbrdd -lhbvm -lhbmacro -lhbpp -lrddntx -lrddcdx -lrddfpt -lhbsix -lhbcommon -lgttrm -lxhb -lhbxpp
     endif
   endif
endif

ifeq ($(HB_COMPILER),mingw32)
    ifeq ($(XBASE_COMPILER),XHARBOUR)
        # XHARBOUR
        LIBFILES_ += -lhbodbc -luser32 -lwinspool -lole32 -loleaut32 -luuid -lgdi32 -lcomctl32 -lcomdlg32 -lodbc32 -lwininet -lwsock32
    else
       # HARBOUR
       LIBFILES_ += -luser32 -lwinspool -lole32 -loleaut32 -luuid -lgdi32 -lcomctl32 -lcomdlg32 -lodbc32 -lwininet -lwsock32
    endif
   EXETYPE=.exe
else
   LIBFILES_ +=
   EXETYPE=
endif

#librerias usadas por Tgtk las definimos aqui. GTK y GLADE
LIBS += -L$(LIBDIR_TGTK) $(shell pkg-config --libs tgtk ) $(shell pkg-config --libs libgnomedb-3.0) 
PRGFLAGS += -I$(INCLUDE_TGTK_PRG)

# By Quim -->
# Soporte impresion para Win32, las libs de gnome van en este orden y despues de tgtk si no, no enlaza.
# <--
ifeq ($(SUPPORT_PRINT_WIN32),yes)
  LIBS += $(shell pkg-config --libs libgnomeprint-2.2) $(shell pkg-config --libs libgnomeprintui-2.2)
endif

#nos servir�, para compilar prgs exclusivos para GNU/Linux
#por ejemplo, gPrinter.prg
ifeq ($(HB_COMPILER),gcc)
   PRGFLAGS += -DHB_OS_LINUX
endif   

LIBDIR_ = $(LIBDIR) -L$(HB_LIB_INSTALL)
LIBS_= -L$(LIBDIR_TGTK) -lgclass -lhbgtk -Wl,--start-group -L$(HB_LIB_INSTALL) $(LIBFILES_) -Wl,--end-group $(LIBS)

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
	$(CC) -o$@ $< $(LIBDIR_) $(LIBS_)

%.o: %.c
	$(CC) -c -o$@ $(CFLAGS) -I$(HB_INC_INSTALL) $<

%.o: %.cpp
	$(CC) -c -o$@ $(CFLAGS) -I$(HB_INC_INSTALL) $<

%.c: %.prg
	$(HB_BIN_INSTALL)/harbour -w -q0 -gc0 -n -p  $(PRGFLAGS) -I$(HB_INC_INSTALL)  -o$@ $<

$(TARGET): $(OBJECTS)
ifeq ( lib , $(patsubst %.a, lib, $(TARGET)))
	$(LINKER) -r $(TARGET) $(OBJECTS)
	$(LIBRARIAN) $(TARGET)
else
	$(CC) -o $(TARGET) $(OBJECTS) $(LIBDIR_) $(LIBS_)
endif

clean:
	rm -f *.o
	rm -f *.ppo
	rm -f $(TARGET)
	rm -f $(TARGET).exe
	rm -f $(TARGETS)

install: all
	cp -f *.a $(TGTK_INSTALL)

