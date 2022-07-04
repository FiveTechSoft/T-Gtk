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

SPACE:=  
SPACE+= 
export SPACE

include $(ROOT)config/detect.mk
#ifneq ($(notdir $(wildcard $(subst \,/,$(ROOT)/setenv.mk))),)
#   $(info ejecutando $(ROOT)setenv.mk)
#   include $(ROOT)setenv.mk
#endif

# Obtenemos nombre generico de plataforma (PLATFORM_NAME)
include $(ROOT)config/platform_name.mk

# Inicializamos el valor para la variable SETENV
ifeq ($(SETENV),)
  SETENV :=$(subst $(DIRSEP),,$(PLATFORM_NAME))
  ifeq ($(HB_MAKE_PLAT),linux)
     SETENV :=$(HB_MAKE_ISSUE)_$(HOST_PLAT)
  endif
  SETENV := setenv_$(SETENV).mk
endif

ifeq ($(notdir $(wildcard $(subst \,/,$(ROOT)/$(SETENV)))),$(SETENV))
  $(info Ejecutando $(SETENV) )
  include $(ROOT)$(SETENV)
endif


# Si existe se asigna un archivo para seteo adicional o personalizado
ifneq ($(SETTINGS),)
  $(info Ejecutando $(SETTINGS) (Settings) )
  include $(SETTINGS)
endif

ifeq ($(HB_MAKE_PLAT),win)
   # -- verificamos si los valores de estas variables estan en minuscula.
   env:=$(call lc,$(shell set))
   #$(info $(env))
   ifneq ($(findstring auto_inst=yes,$(env)),)
      #$(info encontrado!!)
      AUTO_INST=yes
   endif
   ifneq ($(findstring tgtk_down=yes,$(env)),)
      #$(info encontrado!!)
      TGTK_DOWN=yes
   endif
endif

export TGTK_VERSION :=3

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
    export TGTK_DIR         =\t-gtk$(TGTK_VERSION)
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
  ifneq ($(findstring 64,$(HOST_PLAT)),)
    export TGTK_BIN  =\mingw64
  else
    export TGTK_BIN  =\mingw
  endif
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
    ifneq ($(findstring 64,$(HOST_PLAT)),)
      export GTK_PATH        :=\mingw64
    else
      export GTK_PATH        :=\mingw
    endif
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


#Soporte para MultiThread
ifeq ($(GTK_THREAD),)
  export GTK_THREAD =no
endif


#Soporte para VTE
ifeq ($(VTE),)
  export VTE  =no
endif

#Soporte para GTKSourceView
ifeq ($(GTKSOURCEVIEW),)
  export GTKSOURCEVIEW  =no
endif

#Soporte para GTK-Extra
ifeq ($(GTK_EXTRA),)
  export GTK_EXTRA  =no
endif

#Soporte para Bonobo
ifeq ($(BONOBO),)
  export BONOBO         =no
endif

#Alpha. Soporte para GNOMEDB y LIBGDA
ifeq ($(GDA),)
  export GDA            =no
endif

#Soporte para CURL
ifeq ($(CURL),)
  export CURL           =no
endif

#Soporte para WebKit (por los momentos solo para GNU/Linux)
ifeq ($(WEBKIT),)
  export WEBKIT         =no
endif

#Soporte a LibGD (GD Graphic Library)
ifeq ($(LIBGD),)
  export LIBGD         =no
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


#Soporte SSL
ifeq ($(SSL),)
  export SSL        =yes
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

# -kM  Turn Off macrotext substitution
ifeq ($(HB_MACROTEXT_SUBS),)
  export HB_MACROTEXT_SUBS :=no
endif


# HASTA AQUI. EL Resto es detectable o se deduce...

export TGTK_GLOBAL=yes

# Inicializamos el valor para la variable SETENV
#SETENV :=$(HB_MAKE_PLAT)$(HB_MAKE_ISSUE)_$(HOST_PLAT)
#ifeq ($(HB_MAKE_PLAT),linux)
#   SETENV :=$(HB_MAKE_ISSUE)_$(HOST_PLAT)
#endif
#SETENV := setenv_$(SETENV).mk

#ifeq ($(BIN_PLATFORM_NAME),no)
#  SETENV :=setenv.mk
#endif

export SETENV

ifeq ($(notdir $(wildcard $(subst \,/,$(ROOT)/$(SETENV)))),$(SETENV))

  #$(info Ejecutando $(SETENV) )
  #include $(ROOT)$(SETENV)

  #eliminamos posibles espacios en blanco
  XBASE_COMPILER:=$(subst $(SPACE),,$(XBASE_COMPILER))
  HB_BIN_INSTALL:=$(subst $(SPACE),,$(HB_BIN_INSTALL))
  HB_INC_INSTALL:=$(subst $(SPACE),,$(HB_INC_INSTALL))
  HB_LIB_INSTALL:=$(subst $(SPACE),,$(HB_LIB_INSTALL))
  HB_VERSION:=$(subst $(SPACE),,$(HB_VERSION))
  XHB_BIN_INSTALL:=$(subst $(SPACE),,$(XHB_BIN_INSTALL))
  XHB_INC_INSTALL:=$(subst $(SPACE),,$(XHB_INC_INSTALL))
  XHB_LIB_INSTALL:=$(subst $(SPACE),,$(XHB_LIB_INSTALL))
  TGTK_DIR:=$(subst $(SPACE),,$(TGTK_DIR))
  LIBDIR_TGTK:=$(subst $(SPACE),,$(LIBDIR_TGTK))
  INCLUDE_TGTK_PRG:=$(subst $(SPACE),,$(INCLUDE_TGTK_PRG))
  GTK_PATH:=$(subst $(SPACE),,$(GTK_PATH))
  TGTK_BIN:=$(subst $(SPACE),,$(TGTK_BIN))
  PKG_CONFIG_PATH:=$(subst $(SPACE),,$(PKG_CONFIG_PATH))
  TGTK_RUN:=$(subst $(SPACE),,$(TGTK_RUN))
  DIR_DOWN:=$(subst $(SPACE),,$(DIR_DOWN))

endif

#eof
