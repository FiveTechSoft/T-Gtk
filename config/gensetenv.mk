#
# Rutina para generar archivo setenv.mk
#

$(info )
$(info Ejecutando config/gensetenv.mk )
ifeq ($(notdir $(wildcard $(subst \,/,$(ROOT)/$(SETENV)))),)

$(info * Generando $(SETENV) )

ifeq ($(HB_MAKE_PLAT),win)
  SPACE =echo.
  ECHO:=echo
  N:=\#
  INI:=> $(ROOT)\$(SETENV) 
  ADD:=>> $(ROOT)\$(SETENV) 
else
  ECHO:=echo "
  SPACE:=$(ECHO)
  N:=\#
  INI:="> $(ROOT)\$(SETENV) 
  ADD:=">> $(ROOT)\$(SETENV) 
endif
$(shell $(strip $(ECHO) $(N)--------------------------------------------- $(INI)))
$(shell $(strip $(ECHO) $(N) System Configure of T-Gtk.                   $(ADD)))
$(shell $(strip $(ECHO) $(N) (c)2004-15 gTXBASE Team.                     $(ADD)))
$(shell $(strip $(ECHO) $(N)                                              $(ADD)))
$(shell $(strip $(ECHO) $(N)--------------------------------------------- $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N)-------------------- $(ADD)))
$(shell $(strip $(ECHO) $(N) Compilador xBase. Opciones [HARBOUR o XHARBOUR] $(ADD)))
$(shell $(strip $(ECHO) export XBASE_COMPILER =$(XBASE_COMPILER) $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N)-------------------- $(ADD)))
$(shell $(strip $(ECHO) $(N) RUTAS Compilador xBase HARBOUR. $(ADD)))

export HB_BIN_INSTALL:=
export HB_INC_INSTALL:=
export HB_LIB_INSTALL:=
include $(ROOT)config/harbour.mk 
ifeq ($(HB_MAKE_PLAT),win)
  $(shell $(strip $(ECHO) export HARBOUR_PATH =\harbour-project$(ADD)))
else
  $(shell $(strip $(ECHO) export HARBOUR_PATH =/usr/local$(ADD)))
endif
$(shell $(strip $(ECHO) export HB_BIN_INSTALL =$(HB_BIN_INSTALL)$(ADD)))
$(shell $(strip $(ECHO) export HB_INC_INSTALL =$(HB_INC_INSTALL)$(ADD)))
$(shell $(strip $(ECHO) export HB_LIB_INSTALL =$(HB_LIB_INSTALL)$(ADD)))
$(shell $(strip $(ECHO) export HB_VERSION =$(HB_VERSION)$(ADD)))
$(shell $(strip $(ECHO) $(N)-------------------- $(ADD)))
$(shell $(strip $(ECHO) $(N) RUTAS Compilador xBase xHARBOUR. $(ADD)))

include $(ROOT)config/xharbour.mk 
$(shell $(strip $(ECHO) export XHB_BIN_INSTALL =$(XHB_BIN_INSTALL)$(ADD)))
$(shell $(strip $(ECHO) export XHB_INC_INSTALL =$(XHB_INC_INSTALL)$(ADD)))
$(shell $(strip $(ECHO) export XHB_LIB_INSTALL =$(XHB_LIB_INSTALL)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N)-------------------- $(ADD)))
$(shell $(strip $(ECHO) $(N) RUTAS T-GTK. $(ADD)))
$(shell $(strip $(ECHO) export TGTK_DIR =$(TGTK_DIR)$(ADD)))
ifeq ($(HB_MAKE_PLAT),win)
  $(shell $(strip $(ECHO) export LIBDIR_TGTK =$$(TGTK_DIR)$(DIRSEP)lib$(ADD)))
  $(shell $(strip $(ECHO) export INCLUDE_TGTK_PRG =$$(TGTK_DIR)$(DIRSEP)include$(ADD)))
  $(shell $(strip $(ECHO) export TGTK_RUN =$$(TGTK_DIR)$(DIRSEP)runtime$(ADD)))
  $(shell $(strip $(ECHO) export DIR_DOWN =$$(TGTK_DIR)$(DIRSEP)downloads$(ADD)))
else
  $(shell $(strip $(ECHO) export LIBDIR_TGTK =\$$(TGTK_DIR)$(DIRSEP)lib$(ADD)))
  $(shell $(strip $(ECHO) export INCLUDE_TGTK_PRG =\$$(TGTK_DIR)$(DIRSEP)include$(ADD)))
endif
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N)-------------------- $(ADD)))
$(shell $(strip $(ECHO) $(N) Componentes Adicionales. $(ADD)))
$(shell $(strip $(ECHO) export GTK_PATH =$(GTK_PATH)$(ADD)))
$(shell $(strip $(ECHO) export TGTK_BIN =$(TGTK_BIN)$(ADD)))
$(shell $(strip $(ECHO) export PKG_CONFIG_PATH =$$(GTK_PATH)$(DIRSEP)lib$(DIRSEP)pkgconfig$(ADD)))
$(shell $(strip $(ECHO) $(N)-------------------- $(ADD)))
$(shell $(strip $(ECHO) $(N) Genera Binario con Datos de la Plataforma. $(ADD)))
$(shell $(strip $(ECHO) export BIN_PLATFORM_NAME =yes$(ADD)))
$(shell $(strip $(ECHO) $(N)-------------------- $(ADD)))
$(shell $(strip $(ECHO) $(N) Auto Descarga e Instalación de Componentes. $(ADD)))
$(shell $(strip $(ECHO) export AUTO_INST =yes$(ADD)))
$(shell $(strip $(ECHO) export TGTK_DOWN =yes$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte de Impresion. $(ADD)))
ifeq ($(HB_MAKE_PLAT),win)
$(shell $(strip $(ECHO) export SUPPORT_PRINT_WIN32 =$(SUPPORT_PRINT_WIN32)$(ADD)))
else
$(shell $(strip $(ECHO) export SUPPORT_PRINT_LINUX =$(SUPPORT_PRINT_LINUX)$(ADD)))
endif

$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para MultiThread. $(ADD)))
$(shell $(strip $(ECHO) export GTK_THREAD =$(GTK_THREAD)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para Terminal. $(ADD)))
$(shell $(strip $(ECHO) $(N)export VTE =$(VTE)$(ADD)))

$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para GTKSourceView. $(ADD)))
$(shell $(strip $(ECHO) export GTKSOURCEVIEW =$(GTKSOURCEVIEW)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para GTK-Extra. $(ADD)))
$(shell $(strip $(ECHO) export GTK_EXTRA =$(GTK_EXTRA)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para Bonobo. $(ADD)))
$(shell $(strip $(ECHO) export BONOBO =$(BONOBO)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para gnomeDB y LibGDA. $(ADD)))
$(shell $(strip $(ECHO) export GDA =$(GDA)$(ADD)))
$(shell $(strip $(ECHO) export GDA_VERSION =5.0$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para cURL. $(ADD)))
$(shell $(strip $(ECHO) export CURL =$(CURL)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
ifneq ($(HB_MAKE_PLAT),win)
$(shell $(strip $(ECHO) $(N) Soporte para WebKit. $(ADD)))
$(shell $(strip $(ECHO) export WEBKIT =$(WEBKIT)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
endif
$(shell $(strip $(ECHO) $(N) Soporte para SQLite. $(ADD)))
$(shell $(strip $(ECHO) export SQLITE =$(SQLITE)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para MySQL. $(ADD)))
$(shell $(strip $(ECHO) export MYSQL =$(MYSQL)$(ADD)))
$(shell $(strip $(ECHO) export DOLPHIN =$(DOLPHIN)$(ADD)))
$(shell $(strip $(ECHO) export DOLPHIN_PATH =$(DOLPHIN_PATH)$(ADD)))
$(shell $(strip $(ECHO) export MYSQL_VERSION =$(MYSQL_VERSION)$(ADD)))
$(shell $(strip $(ECHO) export MYSQL_PATH =$(MYSQL_PATH)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para PostgreSQL. $(ADD)))
$(shell $(strip $(ECHO) export POSTGRE =$(POSTGRE)$(ADD)))
$(shell $(strip $(ECHO) export POSTGRE_VERSION =$(POSTGRE_VERSION)$(ADD)))
$(shell $(strip $(ECHO) export POSTGRE_PATH =$(POSTGRE_PATH)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Soporte para SSL (Secure Sockets Layer). $(ADD)))
$(shell $(strip $(ECHO) export SSL =$(SSL)$(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) Flags para el Compilador xBase. $(ADD)))
$(shell $(strip $(ECHO) $(N) Solo para definir una cadena fija como flag (HB_FLAGS). $(ADD)))
$(shell $(strip $(ECHO) $(N)export HB_FLAGS $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(ECHO) $(N) -l $(ADD)))
$(shell $(strip $(ECHO) export HB_LINES :=$(HB_LINES)$(ADD)))
$(shell $(strip $(ECHO) $(N) -gh $(ADD)))
$(shell $(strip $(ECHO) export HB_HRB_OUT :=$(HB_HRB_OUT)$(ADD)))
$(shell $(strip $(ECHO) $(N) -d $(ADD)))
$(shell $(strip $(ECHO) export HB_DEFINE :=$(HB_DEFINE)$(ADD)))
$(shell $(strip $(ECHO) $(N) -v $(ADD)))
$(shell $(strip $(ECHO) export HB_ASSUME_VARS :=$(HB_ASSUME_VARS)$(ADD)))
$(shell $(strip $(ECHO) $(N) -p $(ADD)))
$(shell $(strip $(ECHO) export HB_GEN_PPO :=$(HB_GEN_PPO)$(ADD)))
$(shell $(strip $(ECHO) $(N) -p+ $(ADD)))
$(shell $(strip $(ECHO) export HB_GEN_PPT :=$(HB_GEN_PPT)$(ADD)))
$(shell $(strip $(ECHO) $(N) -b $(ADD)))
$(shell $(strip $(ECHO) export HB_DEBUG_INFO :=$(HB_DEBUG_INFO)$(ADD)))
$(shell $(strip $(ECHO) $(N) -w[level] Warning Level [1..3]$(ADD)))
$(shell $(strip $(ECHO) export HB_WL :=$(HB_WL) $(ADD)))
$(shell $(strip $(ECHO) $(N) -q[,0,2] $(ADD)))
$(shell $(strip $(ECHO) export HB_QUIET :=$(HB_QUIET) $(ADD)))
$(shell $(strip $(ECHO) $(N) -kM turn off macrotext substitution $(ADD)))
$(shell $(strip $(ECHO) export HB_MACROTEXT_SUBS :=$(HB_MACROTEXT_SUBS) $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))
$(shell $(strip $(SPACE) $(ADD)))

$(info * Finalizada la contruccion de $(SETENV) )

ifeq ($(HB_MAKE_PLAT),win)
   $(shell notepad $(ROOT)$(SETENV) )
else
   $(info Por favor, edite $(SETENV) y ajuste los valores... )
endif
$(info * Vuelva a ejecutar.. )
$(error )

endif
#/eof
