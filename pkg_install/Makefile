#
#  Probando sonido
#

export ROOT=../
include $(ROOT)config/detect.mk
include $(ROOT)setenv.mk
include $(ROOT)config/global.mk

$(info Ejecutando Makefile en $(ROOT)pkg_install)

TGTK_VERSION=2.0

MYSQL_PATH=\MySQlClient
PGSQL_PATH=\pgsql

$(shell cmd /C start svn export --force ../ ./preinstall/ )

$(info * ------------------------------------- * )
$(info Ruta GTK a utilizar: $(GTK_PATH) )
$(info Ruta Harbour a utilizar: $(HB_BIN_INSTALL) )
$(info Ruta MinGW a utilizar: $(TGTK_BIN) )
$(info Ruta MySQL a utilizar: $(MYSQL_PATH) )
$(info Ruta PgSQL a utilizar: $(PGSQL_PATH) )
$(info * ------------------------------------- * )


$(info Inicializando dolphin.nsh )
$(shell echo.   > dolphin.nsh )

$(info Inicializando mysql.nsh )
$(shell echo.   > mysql.nsh )

$(info Inicializando pgsql.nsh )
$(shell echo.   > pgsql.nsh )


$(info Generando Instalador Basico o Minimo (Solo t-gtk) )

$(shell echo   Name "t-gtk $(TGTK_VERSION)"         > install_name.nsh )
$(shell echo   InstallDir "C:\t-gtk_$(TGTK_VERSION)" >> install_name.nsh )
$(shell echo   OutFile "t-gtk_setup.exe"        >> install_name.nsh )
$(shell echo.  >> install_name.nsh )

$(shell echo   StrCpy $$SRC_MINGWDIR "$(TGTK_BIN)" >  parameters.nsh)
$(shell echo   StrCpy $$SRC_GTKDIR   "$(GTK_PATH)" >> parameters.nsh)
$(shell echo   StrCpy $$SRC_HBDIR    "$(HB_BIN_INSTALL)" >> parameters.nsh)
$(shell echo   StrCpy $$SRC_MYSQL    "$(MYSQL_PATH)" >> parameters.nsh)
$(shell echo   StrCpy $$SRC_PGSQL    "$(PGSQL_PATH)" >> parameters.nsh)
$(shell echo   StrCpy $$SRC_GEDIT    "$$INSTDIR\gedit" >> parameters.nsh)

$(shell echo   !define FULL >> parameters.nsh)
$(shell echo   !undef FULL >> parameters.nsh)

ifeq ($(NSIS_PATH),)
   NSIS_PATH =$(PROGRAMFILES)\NSIS
endif
$(info Puede tardar varios minutos, por favor espere. )
$(shell "$(NSIS_PATH)\makensis.exe" /Onsis.log t-gtk.nsi )
$(shell notepad nsis.log )


#-----------------------------------------

 EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat \
	 $(TGTK_DIR)

 $(info * Verificando existencia de tdolphin )
 $(shell $(EXECUTE) $(TGTK_DIR)\tdolphin\function.c)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye tdolphin - No ha sido localizado en: )
   $(info * $(TGTK_DIR)\tdolphin )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$INSTDIR\tdolphin"       > dolphin.nsh )
   $(shell echo   File /nonfatal /r "$(TGTK_DIR)\tdolphin\*.*"  >> dolphin.nsh )
 endif



 $(info * Verificando existencia de Cliente MySQL )
 $(shell $(EXECUTE) $(MYSQL_PATH)\lib\libmysql.dll)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye MySQL Client - No ha sido localizado en: )
   $(info * $(MYSQL_PATH) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$INSTDIR\MySQLClient"       > mysql.nsh )
   $(shell echo   File /nonfatal /r "$(MYSQL_PATH)\*.*"  >> mysql.nsh )
 endif




 $(info * Verificando existencia de Cliente PostgreSQL )
 $(shell $(EXECUTE) $(MYSQL_PATH)\lib\libpq.dll)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye PostgreSQL Client - No ha sido localizado en: )
   $(info * $(PGSQL_PATH) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$INSTDIR\PgSQLClient"       > pgsql.nsh )
   $(shell echo   File /nonfatal /r "$(PGSQL_PATH)\*.*"  >> pgsql.nsh )
 endif




$(info Generando Instalador Full )

$(shell echo   Name "t-gtk $(TGTK_VERSION)"         > install_name.nsh )
$(shell echo   InstallDir "C:\t-gtk_$(TGTK_VERSION)" >> install_name.nsh )
$(shell echo   OutFile "t-gtk_setup_full.exe"        >> install_name.nsh )
$(shell echo.  >> install_name.nsh )

$(shell echo   !define FULL >> parameters.nsh)
#$(shell echo   !undef FULL >> parameters.nsh)

ifeq ($(NSIS_PATH),)
   NSIS_PATH =$(PROGRAMFILES)\NSIS
endif
$(info Puede tardar varios minutos, por favor espere. )
$(shell "$(NSIS_PATH)\makensis.exe" /Onsis.log t-gtk.nsi )
$(shell notepad nsis.log )

#eof
