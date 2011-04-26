#
# Rutina para generar archivo setenv.mk
#

$(info )
$(info Ejecutando config/gensetenv.mk )

ifeq ($(HB_MAKE_PLAT),win)
ifeq ($(notdir $(wildcard $(subst \,/,$(ROOT)/setenv.mk))),)

$(info * Generando setenv.mk )
N:=\#
INI:=> $(ROOT)\setenv.mk 
ADD:=>> $(ROOT)\setenv.mk 
$(shell $(strip echo $(N)--------------------------------------------- $(INI)))
$(shell $(strip echo $(N) System Configure of T-Gtk.                   $(ADD)))
$(shell $(strip echo $(N) (c)2004-11 gTXBASE Team.                     $(ADD)))
$(shell $(strip echo $(N)                                              $(ADD)))
$(shell $(strip echo $(N)--------------------------------------------- $(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N)-------------------- $(ADD)))
$(shell $(strip echo $(N) Compilador xBase. Opciones [HARBOUR o XHARBOUR] $(ADD)))
$(shell $(strip echo export XBASE_COMPILER =$(XBASE_COMPILER) $(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N)-------------------- $(ADD)))
$(shell $(strip echo $(N) RUTAS Compilador xBase HARBOUR. $(ADD)))

export HB_BIN_INSTALL:=
export HB_INC_INSTALL:=
export HB_LIB_INSTALL:=
include $(ROOT)config/harbour.mk 
$(shell $(strip echo export HB_BIN_INSTALL =$(HB_BIN_INSTALL)$(ADD)))
$(shell $(strip echo export HB_INC_INSTALL =$(HB_INC_INSTALL)$(ADD)))
$(shell $(strip echo export HB_LIB_INSTALL =$(HB_LIB_INSTALL)$(ADD)))
$(shell $(strip echo export HB_VERSION =$(HB_VERSION)$(ADD)))
$(shell $(strip echo $(N)-------------------- $(ADD)))
$(shell $(strip echo $(N) RUTAS Compilador xBase xHARBOUR. $(ADD)))

include $(ROOT)config/xharbour.mk 
$(shell $(strip echo export XHB_BIN_INSTALL =$(XHB_BIN_INSTALL)$(ADD)))
$(shell $(strip echo export XHB_INC_INSTALL =$(XHB_INC_INSTALL)$(ADD)))
$(shell $(strip echo export XHB_LIB_INSTALL =$(XHB_LIB_INSTALL)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N)-------------------- $(ADD)))
$(shell $(strip echo $(N) RUTAS T-GTK. $(ADD)))
$(shell $(strip echo export TGTK_DIR =$(TGTK_DIR)$(ADD)))
$(shell $(strip echo export LIBDIR_TGTK =$(LIBDIR_TGTK)$(ADD)))
$(shell $(strip echo export INCLUDE_TGTK_PRG =$(INCLUDE_TGTK_PRG)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N)-------------------- $(ADD)))
$(shell $(strip echo $(N) Componentes Adicionales. $(ADD)))
$(shell $(strip echo export GTK_PATH =$(GTK_PATH)$(ADD)))
$(shell $(strip echo export TGTK_BIN =$(TGTK_BIN)$(ADD)))
$(shell $(strip echo export PKG_CONFIG_PATH =$(PKG_CONFIG_PATH)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Soporte de Impresion. $(ADD)))
ifeq ($(HB_MAKE_PLAT),win)
$(shell $(strip echo export SUPPORT_PRINT_WIN32 =$(SUPPORT_PRINT_WIN32)$(ADD)))
else
$(shell $(strip echo export SUPPORT_PRINT_LINUX =$(SUPPORT_PRINT_LINUX)$(ADD)))
endif
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Soporte para GTKSourceView. $(ADD)))
$(shell $(strip echo export GTKSOURCEVIEW =$(GTKSOURCEVIEW)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Soporte para Bonobo. $(ADD)))
$(shell $(strip echo export BONOBO =$(BONOBO)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Soporte para gnomeDB y LibGDA. $(ADD)))
$(shell $(strip echo export GNOMEDB =$(GNOMEDB)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Soporte para cURL. $(ADD)))
$(shell $(strip echo export CURL =$(CURL)$(ADD)))
$(shell $(strip echo. $(ADD)))
ifneq ($(HB_MAKE_PLAT),win)
$(shell $(strip echo $(N) Soporte para WebKit. $(ADD)))
$(shell $(strip echo export WEBKIT =$(WEBKIT)$(ADD)))
$(shell $(strip echo. $(ADD)))
endif
$(shell $(strip echo $(N) Soporte para SQLite. $(ADD)))
$(shell $(strip echo export SQLITE =$(SQLITE)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Soporte para MySQL. $(ADD)))
$(shell $(strip echo export MYSQL =$(MYSQL)$(ADD)))
$(shell $(strip echo export DOLPHIN =$(DOLPHIN)$(ADD)))
$(shell $(strip echo export MYSQL_VERSION =$(MYSQL_VERSION)$(ADD)))
$(shell $(strip echo export MYSQL_PATH =$(MYSQL_PATH)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Soporte para PostgreSQL. $(ADD)))
$(shell $(strip echo export POSTGRE =$(POSTGRE)$(ADD)))
$(shell $(strip echo export POSTGRE_VERSION =$(POSTGRE_VERSION)$(ADD)))
$(shell $(strip echo export POSTGRE_PATH =$(POSTGRE_PATH)$(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) Flags para el Compilador xBase. $(ADD)))
$(shell $(strip echo $(N) Solo para definir una cadena fija como flag (HB_FLAGS). $(ADD)))
$(shell $(strip echo $(N)export HB_FLAGS $(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo $(N) -l $(ADD)))
$(shell $(strip echo export HB_LINES :=$(HB_LINES)$(ADD)))
$(shell $(strip echo $(N) -gh $(ADD)))
$(shell $(strip echo export HB_HRB_OUT :=$(HB_HRB_OUT)$(ADD)))
$(shell $(strip echo $(N) -d $(ADD)))
$(shell $(strip echo export HB_DEFINE :=$(HB_DEFINE)$(ADD)))
$(shell $(strip echo $(N) -v $(ADD)))
$(shell $(strip echo export HB_ASSUME_VARS :=$(HB_ASSUME_VARS)$(ADD)))
$(shell $(strip echo $(N) -p $(ADD)))
$(shell $(strip echo export HB_GEN_PPO :=$(HB_GEN_PPO)$(ADD)))
$(shell $(strip echo $(N) -p+ $(ADD)))
$(shell $(strip echo export HB_GEN_PPT :=$(HB_GEN_PPT)$(ADD)))
$(shell $(strip echo $(N) -b $(ADD)))
$(shell $(strip echo export HB_DEBUG_INFO :=$(HB_DEBUG_INFO)$(ADD)))
$(shell $(strip echo $(N) -w[level] Warning Level [1..3]$(ADD)))
$(shell $(strip echo export HB_WL :=$(HB_WL) $(ADD)))
$(shell $(strip echo $(N) -q[,0,2] $(ADD)))
$(shell $(strip echo export HB_QUIET :=$(HB_QUIET) $(ADD)))
$(shell $(strip echo. $(ADD)))
$(shell $(strip echo. $(ADD)))

$(info * Finalizada la contruccion de setenv.mk )

$(shell notepad $(ROOT)setenv.mk )
$(info * Vuelva a ejecutar.. )
$(error )

endif
endif
#/eof
