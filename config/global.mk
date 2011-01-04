ifneq ($(TGTK_GLOBAL),) 
endif
export XBASE_COMPILER =HARBOUR
export HB_COMPILER    =mingw32

export HB_BIN_INSTALL =/hb-mingw/bin
export HB_INC_INSTALL =/hb-mingw/include
export HB_LIB_INSTALL =/hb-mingw/lib

export TGTK_DIR       =/t-gtk

#Soporte para GTKSourceView
export GTKSOURCEVIEW  =no

#Soporte para Bonobo
export BONOBO         =no

#Alpha. Soporte para GNOMEDB y LIBGDA
export GNOMEDB        =no

#Soporte para CURL
export CURL           =no

#Soporte para WebKit
export WEBKIT         =no

#Soporte MySQL
export MYSQL          =yes
export DOLPHIN        =yes

#Soporte PostgreSQL
export POSTGRE        =yes

#Soporte de Impresion
export SUPPORT_PRINT_LINUX=no

export SUPPORT_PRINT_WIN32=no

#Ruta de PROGRAMFILES (solo windows)
export PROGRAMFILES   = /Archivos de Programa


# HASTA AQUI. EL Resto es detectable o se deduce...

export HB_MAKE_PLAT
#Se usa DIRSEP para que pueda funcionar xcopy al utilizar "make install"
export DIRSEP
export LIBDIR_TGTK      = $(TGTK_DIR)$(DIRSEP)lib
export INCLUDE_TGTK_PRG = $(TGTK_DIR)$(DIRSEP)include
export TGTK_INSTALL     = $(TGTK_DIR)$(DIRSEP)


#Especificamos compilador xBase a usar, si harbour o xHarbour
ifeq ($(XBASE_COMPILER),)
  XBASE_COMPILER = HARBOUR
endif

HB_COMPILER := mingw32

# Make platform detection
ifneq ($(findstring COMMAND,$(SHELL)),)
   HB_MAKE_PLAT := dos
else
   ifneq ($(findstring sh.exe,$(SHELL)),)
      HB_MAKE_PLAT := win
   else
      ifneq ($(findstring CMD.EXE,$(SHELL)),)
         HB_MAKE_PLAT := os2
      else
         HB_MAKE_PLAT := unix
         HB_COMPILER  := gcc
      endif
   endif
endif
# Directory separator default
ifeq ($(DIRSEP),)
   DIRSEP := /
   ifeq ($(HB_COMPILER),mingw32)
      DIRSEP := $(subst /,\,\)
   endif
endif
# Path separator default
ifeq ($(PTHSEP),)
   # small hack, it's hard to detect what is real path separator because
   # some shells in MS-DOS/Windows translates MS-DOS style paths to POSIX form
   ifeq ($(subst ;,:,$(PATH)),$(PATH))
      PTHSEP := :
   else
      PTHSEP := ;
   endif
endif


#Soporte MySQL
ifeq ($(MYSQL),yes)
   ifeq ($(MYSQL_PATH),)
      MYSQL_PATH='$(PROGRAMFILES)\MySQL\MySQL Server 5.0\include'
   endif
endif


#Soporte PostgreSQL
ifeq ($(POSTGRE),yes)
   ifeq ($(POSTGRE_PATH),)
      POSTGRE_PATH='$(PROGRAMFILES)\PostgreSQL\9.0\include'
   endif
endif


$(info *************************************************** )
$(info * Plataforma: $(HB_MAKE_PLAT).   Compilador: $(HB_COMPILER) ) 
$(info * Compilador XBase: $(XBASE_COMPILER)                 )
$(info * Rutas:                                              )
$(info * bin: $(HB_BIN_INSTALL)                              )
$(info * lib: $(HB_LIB_INSTALL)                              )
$(info * include: $(HB_INC_INSTALL)                          )
$(info *                                                     )
$(info * Soporte.                                            )
$(info * GtkSourceView = $(GTKSOURCEVIEW)                    )
$(info * Bonobo        = $(BONOBO)                           )
$(info * gnomeDB       = $(GNOMEDB)                          )
$(info * CURL          = $(CURL)                             )
ifneq ($(HB_MAKE_PLAT),win)
   $(info * WebKitGTK+    = $(WEBKIT) )
endif
$(info * MySQL         = $(MYSQL)                            )
ifeq ($(MYSQL),yes)
  $(info *    PATH    = $(MYSQL_PATH))
  $(info *    Dolphin    = $(DOLPHIN)                          )
endif
$(info * PostgreSQL    = $(MYSQL)                            )
ifeq ($(POSTGRE),yes)
  $(info *    PATH    = $(POSTGRE_PATH))
endif
$(info *************************************************** )


export TGTK_GLOBAL=yes
