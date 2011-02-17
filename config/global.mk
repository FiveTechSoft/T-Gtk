###################################################
# Please, use tool /utils/config_system/configure # 
# for create this file                            #
# OR modify correct the paths.                    #
###################################################

##############################################
# System Configure of T-Gtk.
# (c)2004-11 gTXBASE Team.
# 
##############################################

include $(ROOT)config/detect.mk

#Ruta de PROGRAMFILES (solo Windows)
export PROGRAMFILES =\Archivos de Programa


##############################################
# Indicar COMPILADOR XBASE. 
# Opciones ( HARBOUR | XHARBOUR )
export XBASE_COMPILER =HARBOUR
##############################################

##############################################
# INDICAR RUTA DEL COMPILADOR XBASE
ifeq ($(HB_MAKE_PLAT),win)
# Ruta en Windows:
  HARBOUR_PATH  =\hb-mingw

  export HB_BIN_INSTALL =$(HARBOUR_PATH)\bin
  export HB_INC_INSTALL =$(HARBOUR_PATH)\include
  export HB_LIB_INSTALL =$(HARBOUR_PATH)\lib\win\mingw
  # -- Version = [ 2.0 | 2.1 ]
  export HB_VERSION =2.1
else
# Ruta en GNU/Linux:
  HARBOUR_PATH  =/usr/local

  export HB_BIN_INSTALL =$(HARBOUR_PATH)/bin
  export HB_INC_INSTALL =$(HARBOUR_PATH)/include/harbour
  export HB_LIB_INSTALL =$(HARBOUR_PATH)/lib/harbour
  # -- Version = [ 2.0 | 2.1 ]
  export HB_VERSION =2.1
endif
##############################################


##############################################
#                                            #
#              RUTAS DE T-GTK                #
#                                            #
##############################################
ifeq ($(HB_MAKE_PLAT),win)
  # Ruta en Windows:
  export TGTK_DIR         =\t-gtk
  export LIBDIR_TGTK      =$(TGTK_DIR)\lib
  export INCLUDE_TGTK_PRG =$(TGTK_DIR)\include
else
  # Ruta en GNU/Linux
  export TGTK_DIR         =$(HOME)/repos/tgtk/trunk
  export LIBDIR_TGTK      =$(TGTK_DIR)/lib
  export INCLUDE_TGTK_PRG =$(TGTK_DIR)/include
endif

# Se usa DIRSEP para el buen
# funcionamiento xcopy al utilizar "make install"

export TGTK_INSTALL     =$(TGTK_DIR)$(DIRSEP)

##############################################



##############################################
#                                            #
#   SOPORTE PARA COMPONENTES ADICIONALES Y   #
#   RUTAS CORRESPONDIENTES                   #
#                                            #
##############################################

#Soporte de Impresion
export SUPPORT_PRINT_LINUX=no
export SUPPORT_PRINT_WIN32=no


#Soporte para GTKSourceView
export GTKSOURCEVIEW  =no

#Soporte para Bonobo
export BONOBO         =no

#Alpha. Soporte para GNOMEDB y LIBGDA
export GNOMEDB        =no

#Soporte para CURL
export CURL           =no

#Soporte para WebKit (por los momentos solo para GNU/Linux)
export WEBKIT         =no

#Soporte MySQL
export MYSQL          =no
export DOLPHIN        =no
export MYSQL_VERSION  =5.0
export MYSQL_PATH     ="$(PROGRAMFILES)\MySQL\MySQL Server $(MYSQL_VERSION)\include"

#Soporte PostgreSQL
export POSTGRE        =no
export POSTGRE_VERSION=9.0
export POSTGRE_PATH   ="$(PROGRAMFILES)\PostgreSQL\$(POSTGRE_VERSION)\include"

# HASTA AQUI. EL Resto es detectable o se deduce...


export TGTK_GLOBAL=yes
