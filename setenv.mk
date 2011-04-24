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

#####################
# Indicar COMPILADOR XBASE. Opciones ( HARBOUR | XHARBOUR )
export XBASE_COMPILER =HARBOUR


#####################
#--- RUTAS DE T-GTK  
export TGTK_DIR         =\t-gtk-svn
#export LIBDIR_TGTK      =$(TGTK_DIR)\lib
#export INCLUDE_TGTK_PRG =$(TGTK_DIR)\include


# Uso solo en Windows.
# bin - para colocar herramientas
# run - binarios (RunTime) para distribuir 
export TGTK_BIN  =\mingw
export TGTK_RUN  =$(TGTK_DIR)\runtime
export DIR_DOWN :=$(TGTK_DIR)\downloads


#####################



##############################################
#   SOPORTE PARA COMPONENTES ADICIONALES Y   #
#   RUTAS CORRESPONDIENTES                   #
##############################################

# Solo para Windows
export GTK_PATH        :=\gnu
export PKG_CONFIG_PATH :=$(GTK_PATH)\lib\pkgconfig

#Soporte de Impresion
#export SUPPORT_PRINT_LINUX=no
#export SUPPORT_PRINT_WIN32=no


#Soporte para GTKSourceView
#export GTKSOURCEVIEW  =no

#Soporte para Bonobo
#export BONOBO         =no

#Alpha. Soporte para GNOMEDB y LIBGDA
#export GNOMEDB        =no

#Soporte para CURL
#export CURL           =no

#Soporte para WebKit (por los momentos solo para GNU/Linux)
#export WEBKIT         =no

#Soporte para SQLite 
#export SQLITE         =no

#Soporte MySQL
#export MYSQL          =no
#export DOLPHIN        =no
#export MYSQL_VERSION  =5.0
#export MYSQL_PATH     ="$(PROGRAMFILES)\MySQL\MySQL Server $(MYSQL_VERSION)\include"

#Soporte PostgreSQL
#export POSTGRE        =no
#export POSTGRE_VERSION=9.0
#export POSTGRE_PATH   ="$(PROGRAMFILES)\PostgreSQL\$(POSTGRE_VERSION)\include"



#Adicionales para el compilador xBase

#FLAGS para harbour predefinido
# Para Informacion ejecutar harbour --version
#-- solo para predefinir una cadena fija en los flags para harbour.
export HB_FLAGS :=
# -l  
export HB_LINES :=no
# -gh
export HB_HRB_OUT :=no
# -d<id>[=<val>]
export HB_DEFINE :=
# -v
export HB_ASSUME_VARS :=no
# -p
export HB_GEN_PPO :=yes
# -p+
export HB_GEN_PPT :=no
# -b
export HB_DEBUG_INFO :=no
# -w[level]  Warning Level [1..3]
export HB_WL :=1
# -q[,0,2]  
export HB_QUIET :=0


