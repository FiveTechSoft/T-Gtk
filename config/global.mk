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
ifeq ($(XBASE_COMPILER),)
   export XBASE_COMPILER =HARBOUR
endif
##############################################

##############################################
# INDICAR RUTA DEL COMPILADOR XBASE
ifeq ($(XBASE_COMPILER),ALL)
   include $(ROOT)config/harbour.mk
   include $(ROOT)config/xharbour.mk
endif
ifeq ($(XBASE_COMPILER),HARBOUR)
   include $(ROOT)config/harbour.mk
endif
ifeq ($(XBASE_COMPILER),XHARBOUR)
   include $(ROOT)config/xharbour.mk
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
  export TGTK_DIR         =$(HOME)/t-gtk-cvs/t-gtk-cvs
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

#Soporte para SQLite 
export SQLITE         =no

#Soporte MySQL
export MYSQL          =no
export DOLPHIN        =no
export MYSQL_VERSION  =5.0
export MYSQL_PATH     ="$(PROGRAMFILES)\MySQL\MySQL Server $(MYSQL_VERSION)\include"

#Soporte PostgreSQL
export POSTGRE        =no
export POSTGRE_VERSION=9.0
export POSTGRE_PATH   ="$(PROGRAMFILES)\PostgreSQL\$(POSTGRE_VERSION)\include"



#Adicionales para el compilador xBase

#FLAGS para harbour predefinido
#-- solo para predefinir una cadena fija en los flags para harbour.
ifeq ($(HB_FLAGS),)
  export HB_FLAGS :=
endif

# -l
ifeq ($(HB_LINES),)
  export HB_LINES :=no
endif

# -gh
ifeq ($(HB_HRB_OUT),)
  export HB_HRB_OUT :=no
endif

# -d<id>[=<val>]
ifeq ($(HB_DEFINE),)
  export HB_DEFINE :=
endif

# -v
ifeq ($(HB_ASSUME_VARS),)
  export HB_ASSUME_VARS :=no
endif

# -p
ifeq ($(HB_GEN_PPO),)
  export HB_GEN_PPO :=yes
endif

# -p+
ifeq ($(HB_GEN_PPT),)
  export HB_GEN_PPT :=no
endif

# -b
ifeq ($(HB_DEBUG_INFO),)
  export HB_DEBUG_INFO :=no
endif

# -w[level]  Warning Level [1..3]
ifeq ($(HB_WL),)
  export HB_WL :=1
endif

# -q[,0,2]  
ifeq ($(HB_QUIET),)
  export HB_QUIET :=0
endif


# HASTA AQUI. EL Resto es detectable o se deduce...


export TGTK_GLOBAL=yes
