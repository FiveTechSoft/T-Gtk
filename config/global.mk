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

$(info )
$(info Ejecutando config/global.mk)

ifeq ($(notdir $(wildcard $(subst \,/,$(ROOT)/setenv.mk))),setenv.mk)
  $(info Ejecutando setenv.mk )
  include $(ROOT)setenv.mk
endif

include $(ROOT)config/detect.mk

export TGTK_VERSION :=2.0

##############################################
# Indicar COMPILADOR XBASE. 
# Opciones ( HARBOUR | XHARBOUR )
ifeq ($(XBASE_COMPILER),)
   export XBASE_COMPILER =HARBOUR
endif
export XBASE_COMPILER:=$(strip $(XBASE_COMPILER))
##############################################

##############################################
# INDICAR RUTA DEL COMPILADOR XBASE
#ifeq ($(XBASE_COMPILER),ALL)
#   include $(ROOT)config/harbour.mk
#   include $(ROOT)config/xharbour.mk
#endif
ifeq ($(XBASE_COMPILER),HARBOUR)
   include $(ROOT)config/harbour.mk
else
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
  ifeq ($(TGTK_DIR),)
    export TGTK_DIR         =\t-gtk-$(TGTK_VERSION)
  endif
  ifeq ($(LIBDIR_TGTK),)
    export LIBDIR_TGTK      =$(TGTK_DIR)\lib
  endif
  ifeq ($(INCLUDE_TGTK_PRG),)
    export INCLUDE_TGTK_PRG =$(TGTK_DIR)\include
  endif
else
  # Ruta en GNU/Linux
  ifeq ($(TGTK_DIR),)
    export TGTK_DIR         =$(HOME)/t-gtk-$(TGTK_VERSION)
  endif
  ifeq ($(LIBDIR_TGTK),)
    export LIBDIR_TGTK      =$(TGTK_DIR)/lib
  endif
  ifeq ($(INCLUDE_TGTK_PRG),)
    export INCLUDE_TGTK_PRG =$(TGTK_DIR)/include
  endif
endif

# Se usa DIRSEP para el buen
# funcionamiento xcopy al utilizar "make install"
ifeq ($(TGTK_INST),)
  export TGTK_INST     =$(TGTK_DIR)$(DIRSEP)
endif

# Uso solo en Windows.
# bin - para colocar herramientas
# run - binarios (RunTime) para distribuir 
ifeq ($(TGTK_BIN),)
  export TGTK_BIN  =\mingw
endif
ifeq ($(TGTK_RUN),)
  export TGTK_RUN  =$(TGTK_DIR)\runtime
endif
ifeq ($(DIR_DOWN),)
  export DIR_DOWN :=$(TGTK_DIR)\downloads
endif

##############################################



##############################################
#                                            #
#   SOPORTE PARA COMPONENTES ADICIONALES Y   #
#   RUTAS CORRESPONDIENTES                   #
#                                            #
##############################################

ifeq ($(HB_MAKE_PLAT),win)
  ifeq ($(GTK_PATH),)
    export GTK_PATH        :=\mingw
  endif
  ifeq ($(PKG_CONFIG_PATH),)
    export PKG_CONFIG_PATH :=$(GTK_PATH)\lib\pkgconfig
  endif
endif


#Soporte de Impresion
ifeq ($(SUPPORT_PRINT_LINUX),)
  export SUPPORT_PRINT_LINUX=no
endif
ifeq ($(SUPPORT_PRINT_WIN32),)
  export SUPPORT_PRINT_WIN32=no
endif


#Soporte para GTKSourceView
ifeq ($(GTKSOURCEVIEW),)
  export GTKSOURCEVIEW  =no
endif

#Soporte para Bonobo
ifeq ($(BONOBO),)
  export BONOBO         =no
endif

#Alpha. Soporte para GNOMEDB y LIBGDA
ifeq ($(GNOMEDB),)
  export GNOMEDB        =no
endif

#Soporte para CURL
ifeq ($(CURL),)
  export CURL           =no
endif

#Soporte para WebKit (por los momentos solo para GNU/Linux)
ifeq ($(WEBKIT),)
  export WEBKIT         =no
endif

#Soporte para SQLite 
ifeq ($(SQLITE),)
  export SQLITE         =no
endif

#Soporte MySQL
ifeq ($(MYSQL),)
  export MYSQL          =no
endif
ifeq ($(DOLPHIN),)
  export DOLPHIN        =no
endif
ifeq ($(MYSQL_VERSION),)
  export MYSQL_VERSION  =5.0
endif
ifeq ($(MYSQL_PATH),)
  export MYSQL_PATH     ="$(PROGRAMFILES)\MySQL\MySQL Server $(MYSQL_VERSION)\include"
endif

#Soporte PostgreSQL
ifeq ($(POSTGRE),)
  export POSTGRE        =no
endif
ifeq ($(POSTGRE_VERSION),)
  export POSTGRE_VERSION=9.0
endif
ifeq ($(POSTGRE_PATH),)
  export POSTGRE_PATH   ="$(PROGRAMFILES)\PostgreSQL\$(POSTGRE_VERSION)\include"
endif


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
