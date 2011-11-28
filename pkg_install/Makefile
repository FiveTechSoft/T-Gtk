#
#  www.t-gtk.org
#

$(info Ejecutando build.bat (exporta version de SVN para instalador))
$(info Esto puede demorar unos minutos, por favor espere... )
$(shell build.bat)
$(info Finalizada creacion de carpeta preinstall. )

export ROOT=../
include $(ROOT)config/detect.mk
include $(ROOT)$(SETENV)
include $(ROOT)config/global.mk

ifeq ($(subst $(SPACE),,$(XBASE_COMPILER)),HARBOUR)
  HB_SHORTNAME=hb$(HB_VERSION)
endif
ifeq ($(subst $(SPACE),,$(XBASE_COMPILER)),XHARBOUR)
  HB_SHORTNAME=xhb$(HB_VERSION)
endif

ifeq ($(HB_MAKE_PLAT),win)
   LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(HB_MAKE_PLAT)$(HB_MAKE_ISSUE)$(DIRSEP)$(HOST_PLAT)$(DIRSEP)$(HB_SHORTNAME)
else
   LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(HB_MAKE_ISSUE)$(DIRSEP)$(HOST_PLAT)$(DIRSEP)$(HB_SHORTNAME)
endif

$(info copy $(LIBDIR_TGTK_)\*.a $(LIBDIR_TGTK)\hb\ )
$(shell mkdir $(LIBDIR_TGTK)\hb)
$(shell copy $(LIBDIR_TGTK_)\*.a $(LIBDIR_TGTK)\hb\ > %TEMP%/out.log)


$(info Ejecutando Makefile en $(ROOT)pkg_install)

#TGTK_VERSION=2.1
INSTALL_DIR=$(subst %\:,C\:,$(TGTK_DIR))_$(TGTK_VERSION)

DEST_MINGWDIR=$(INSTALL_DIR)\MinGW

MSQL_PATH=$(subst ",,$(dir $(MYSQL_PATH)))
PSQL_PATH=$(subst ",,$(dir $(POSTGRE_PATH)))

#-- RUTA DE FUENTES DE HARBOUR
HB_SOURCE_PATH:=\harbour-svn

HB_PATH:=$(dir $(HB_BIN_INSTALL))

#$(shell cmd /C start svn export --force ../ ./preinstall/ )
$(shell cmd /C start svn export ../ ./preinstall/ )

$(info * ------------------------------------- * )
$(info Ruta GTK a utilizar: $(GTK_PATH) )
$(info Ruta Harbour a utilizar: $(HB_PATH) )
$(info Ruta MinGW a utilizar: $(TGTK_BIN) )
$(info Ruta MySQL a utilizar: $(MSQL_PATH) )
$(info Ruta PgSQL a utilizar: $(PSQL_PATH) )
$(info * ------------------------------------- * )


# --------------------------------------
# Inicializa Archivos .nsh
# --------------------------------------
$(info Inicializando dolphin.nsh )
$(shell echo.   > dolphin.nsh )

$(info Inicializando mysql.nsh )
$(shell echo.   > mysql.nsh )

$(info Inicializando pgsql.nsh )
$(shell echo.   > pgsql.nsh )

$(info Inicializando gtk.nsh )
$(shell echo.   > gtk.nsh )

$(info Inicializando question.nsh )
$(shell echo.   > question.nsh )
$(shell echo    StrCpy $$DEST_MINGWDIR "$(DEST_MINGWDIR)"    >> question.nsh )
$(shell echo    StrCpy $$DEST_GTKDIR "$$INSTDIR\GTK+"    >> question.nsh )
$(shell echo    StrCpy $$DEST_HBDIR "$$INSTDIR\hb-mingw"    >> question.nsh )
$(shell echo    StrCpy $$DEST_GEDIT "$$INSTDIR\gedit"    >> question.nsh )


# --------------------------------------
# Genera Instalador Basico
# --------------------------------------
$(info Generando Instalador Basico o Minimo (Solo t-gtk) )

$(info Inicializando install_name.nsh )
$(shell echo   Name "t-gtk $(TGTK_VERSION)"         > install_name.nsh )
$(shell echo   InstallDir "$(INSTALL_DIR)" >> install_name.nsh )
$(shell echo   OutFile "t-gtk_$(TGTK_VERSION)_setup.exe"        >> install_name.nsh )
$(shell echo.  >> install_name.nsh )


# --------------------------------------
# Definicion de parameters.nsh
# --------------------------------------
$(shell echo   StrCpy $$SRC_MINGWDIR "$(TGTK_BIN)"       >  parameters.nsh)
$(shell echo   StrCpy $$SRC_GTKDIR   "$(GTK_PATH)"       >> parameters.nsh)
$(shell echo   StrCpy $$SRC_HBDIR    "$(HB_BIN_INSTALL)" >> parameters.nsh)
$(shell echo   StrCpy $$SRC_MYSQL    "$(MSQL_PATH)"      >> parameters.nsh)
$(shell echo   StrCpy $$SRC_PGSQL    "$(PSQL_PATH)"      >> parameters.nsh)
$(shell echo   StrCpy $$SRC_GEDIT    "$$INSTDIR\gedit"   >> parameters.nsh)


$(shell echo   !define FULL >> parameters.nsh)
$(shell echo   !undef FULL >> parameters.nsh)
$(shell echo   !define QUESTION >> parameters.nsh)
$(shell echo   !undef QUESTION >> parameters.nsh)

$(shell echo   !macro SET_ENV >> parameters.nsh )
$(shell echo     $${EnvVarUpdate} $$0 "PATH" "A" "HKLM"\
               "$(DEST_MINGWDIR)\bin" >> parameters.nsh )
$(shell echo   !macroend >> parameters.nsh)

$(shell echo   !macro UNSET_ENV >> parameters.nsh)
$(shell echo     $${un.EnvVarUpdate} $$0 "PATH" "R" "HKLM" \
               "$(DEST_MINGWDIR)\bin" >> parameters.nsh )
$(shell echo   !macroend >> parameters.nsh)

$(shell echo   !macro MYSQL_PATH >> parameters.nsh )
$(shell echo     StrCpy $$RULES_MYSQL    "$$RULES_MYSQLMYSQL_PATH=$(MYSQL_PATH)$$\r$$\n" >> parameters.nsh )
$(shell echo   !macroend >> parameters.nsh)

$(shell echo   !macro PGSQL_PATH >> parameters.nsh )
$(shell echo     StrCpy $$RULES_PGSQL    "$$RULES_PGSQLPOSTGRE_PATH=$(POSTGRE_PATH)$$\r$$\n" >> parameters.nsh )
$(shell echo   !macroend >> parameters.nsh)



# --------------------------------------
# Crea Instalador Basico
# --------------------------------------
ifeq ($(NSIS_PATH),)
   NSIS_PATH =$(PROGRAMFILES)\NSIS
endif
$(info Puede tardar varios minutos, por favor espere. )
$(shell "$(NSIS_PATH)\makensis.exe" /Onsis.log t-gtk.nsi )
$(shell cmd /C start nsis.log )

aqui

# --------------------------------------
# Verifica existencia de componentes externos
# --------------------------------------
 EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat \
	 $(TGTK_DIR)

#-- TDOLPHIN

 $(info * Verificando existencia de tdolphin )
 $(shell $(EXECUTE) $(TGTK_DIR)\tdolphin\c\function.c)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye tdolphin - No ha sido localizado en: )
   $(info * $(TGTK_DIR)\tdolphin )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$INSTDIR\tdolphin"       > dolphin.nsh )
   $(shell echo   File /nonfatal /r "$(TGTK_DIR)\tdolphin\*.*"  >> dolphin.nsh )
 endif


#-- MySQL

 $(info * Verificando existencia de Cliente MySQL )
 $(shell $(EXECUTE) $(MSQL_PATH)\lib\libmysql.dll)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye MySQL Client - No ha sido localizado en: )
   $(info * $(MYSQL_PATH) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$INSTDIR\MySQLClient"       > mysql.nsh )
   $(shell echo   File /nonfatal /r "$(MSQL_PATH)*.*"  >> mysql.nsh )
 endif


#-- PostgreSQL

 $(info * Verificando existencia de Cliente PostgreSQL )
 $(shell $(EXECUTE) $(PSQL_PATH)\lib\libpq.dll)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye PostgreSQL Client - No ha sido localizado en: )
   $(info * $(PGSQL_PATH) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$INSTDIR\PgSQLClient\lib"       > pgsql.nsh )
   $(shell echo   File /nonfatal "$(PSQL_PATH)lib\libpq.*"  >> pgsql.nsh )
   $(shell echo   SetOutPath "$$INSTDIR\PgSQLClient\include"     >> pgsql.nsh )
   $(shell echo   File /nonfatal "$(PSQL_PATH)include\*.*"  >> pgsql.nsh )
 endif


#-- GTK+

 $(info * Verificando existencia de GTK+ )
 $(shell $(EXECUTE) $(GTK_PATH)\bin\libgtk-win32-2.0-0.dll)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye GTK+ - No ha sido localizado en: )
   $(info * $(GTK_PATH) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$DEST_GTKDIR"       > gtk.nsh )
   $(shell echo   File /nonfatal /r "$(GTK_PATH)\*.*"  >> gtk.nsh )
 endif

#-- MinGW

 $(info * Verificando existencia de MinGW )
 $(shell $(EXECUTE) $(TGTK_BIN)\bin\gcc.exe)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye MinGW - No ha sido localizado en: )
   $(info * $(TGTK_BIN) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$DEST_MINGWDIR"       > mingw.nsh )
   $(shell echo   File /nonfatal /r "$(TGTK_BIN)\*.*"  >> mingw.nsh )
 endif


#-- Harbour

 $(info * Verificando existencia de Harbour )
 $(shell $(EXECUTE) $(HB_PATH)bin\harbour.exe)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye Harbour - No ha sido localizado en: )
   $(info * $(HB_PATH) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$DEST_HBDIR"       > harbour.nsh )
   $(shell echo   File /nonfatal /r "$(HB_PATH)*.*"  >> harbour.nsh )
 endif




# --------------------------------------
# Unidos o Separados (question.nsh)
# --------------------------------------
 $(shell echo MessageBox MB_YESNO \
              "¿Desea colocar todos los componentes externos en \
	      $$INSTDIR\MinGW ?" > question.nsh )
 $(shell echo   InstallDir "$(TGTK_DIR)" >> install_name.nsh )
 $(shell echo true:        >> question.nsh )
 $(shell echo    DetailPrint "Todo a MinGW"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_MINGWDIR "$$INSTDIR\MinGW"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_GTKDIR "$$INSTDIR\MinGW"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_HBDIR "$$INSTDIR\hb-mingw"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_GEDIT "$$INSTDIR\MinGW"    >> question.nsh )
 $(shell echo    Goto next    >> question.nsh )
 $(shell echo false:        >> question.nsh )
 $(shell echo    DetailPrint "Separados!"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_MINGWDIR "$$INSTDIR\MinGW"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_GTKDIR "$$INSTDIR\GTK+"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_HBDIR "$$INSTDIR\hb-mingw"    >> question.nsh )
 $(shell echo    StrCpy $$DEST_GEDIT "$$INSTDIR\gedit"    >> question.nsh )
 $(shell echo next:        >> question.nsh )


# --------------------------------------
# GENERA INSTALADOR FULL
# --------------------------------------
$(info Generando Instalador Full )

$(info Inicializando install_name.nsh )
$(shell echo   Name "t-gtk $(TGTK_VERSION)"         > install_name.nsh )
$(shell echo   InstallDir "$(TGTK_DIR)" >> install_name.nsh )
$(shell echo   OutFile "t-gtk_$(TGTK_VERSION)_setup_full.exe"        >> install_name.nsh )
$(shell echo.  >> install_name.nsh )

$(shell echo   !define FULL >> parameters.nsh)
$(shell echo   !define QUESTION >> parameters.nsh)

ifeq ($(NSIS_PATH),)
   NSIS_PATH =$(PROGRAMFILES)\NSIS
endif
$(info Puede tardar varios minutos, por favor espere. )
$(shell "$(NSIS_PATH)\makensis.exe" /Onsis.log t-gtk.nsi )
$(shell notepad nsis.log )

#eof
