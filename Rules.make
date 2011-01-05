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

#include $(TOP)$(ROOT)/config/global.mk

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
    LIBS   += $(shell pkg-config --libs libgnomedb-3.0 )
endif


ifeq ($(CURL),yes)
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

ifeq ($(WEBKIT),yes)
    CFLAGS += -D_WEBKIT_
    CFLAGS += $(shell pkg-config --cflags webkit-1.0)
    LIBS += $(shell pkg-config --libs webkit-1.0 )
endif


ifeq ($(MYSQL),yes)
#    PRGFLAGS=-I../../include
    ifeq ($(HB_COMPILER),mingw32)
        #Flags para sistemas WINDOWS
        CFLAGS+=-I../../include -I$(MYSQL_PATH) -DHB_OS_WIN_32_USED -DWIN32 -D_WIN32 -D__WIN32__ 
    else
        #Flags para sistemas GNU/Linux
        CFLAGS+=-I../../include -I/usr/mysql/include
        CFLAGS+=$(shell pkg-config --libs mysql-connector-net )
    endif
endif

ifeq ($(MYSQL),yes)
ifeq ($(DOLPHIN),yes)
    ifeq ($(HB_COMPILER),mingw32)
        #Flags para sistemas WINDOWS
        LIBS +=-L$(LIBDIR_TGTK) -L./ -lmysql
        CFLAGS += -I$(INCLUDE_TGTK_PRG)
        PRGFLAGS += -DNOINTERNAL-DDEBUG
        ifeq ($(XBASE_COMPILER),HARBOUR)
           LIBS+= -lhbct -lharbour-21 -lhbwin -lhbnf -lole32 -loleaut32 -lwinspool -luuid
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


ifeq ($(XBASE_COMPILER),HARBOUR)
   CFLAGS += -D_HB_API_INTERNAL_ -DHB_ARRAY_USE_COUNTER_OFF \
             -D__COMPATIBLE_HARBOUR__ -D__HARBOUR20__
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
         LIBFILES_ = -lhbvm -lhbrtl -lhblang -lhbrdd -lhbmacro -lhbpp -lhbxpp \
                     -lhbsix -lhbdebug -lhbcommon -lrddntx -lrddfpt -lrddcdx \
                     -lhbsix -lxhb -lhbpp -lhbcpage -lhbwin -lhbpcre $(GT_LIBS) 
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
   LIBFILES_ += -luser32 -lwinspool -lole32 -loleaut32 -luuid -lgdi32 -lcomctl32 \
                -lcomdlg32 -lodbc32 -lwininet -lwsock32 -lodbc32 
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
LIBS += -L$(LIBDIR_TGTK) $(shell pkg-config --libs tgtk ) 
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
ifeq ($(HB_COMPILER),mingw32)
	del *.o
	del *.ppo
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
	xcopy /Y *.a $(TGTK_INSTALL)
else
	cp -f *.a $(TGTK_INSTALL)
endif
