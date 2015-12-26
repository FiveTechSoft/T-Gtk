#
#  www.t-gtk.org
#  (c)2004-15 gTxBase Team
#

$(info  )
$(info * Ejecutando Makefile en $(ROOT)pkg_install)

ROOT=../
include ../config/detect.mk
include ../config/global.mk
include $(TGTK_DIR)/$(SETENV)
#ROOT=$(TGTK_DIR)
$(info  )

ifeq ($(subst $(SPACE),,$(XBASE_COMPILER)),HARBOUR)
  HB_SHORTNAME=hb$(HB_VERSION)
endif
ifeq ($(subst $(SPACE),,$(XBASE_COMPILER)),XHARBOUR)
  HB_SHORTNAME=xhb$(HB_VERSION)
endif


ifeq ($(HB_MAKE_PLAT),win)

   #-- De acuerdo al formato de fecha se debe cambiar los valores para
   #   obtener el mes y el año.
   MONTH=$(shell echo %date:~-7,2%)
   YEAR=$(shell echo %date:~-4%)
   FECHA=$(shell echo %date:~-7,2%-%date:~-4%)

   $(info Ejecutando build.bat (exporta version de SVN para instalador))
   $(info Esto puede demorar unos minutos, por favor espere... )
   $(shell build.bat)

   ifeq ($(BIN_PLATFORM_NAME),yes)
      LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(PLATFORM_NAME)$(HB_SHORTNAME)
   else
      LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(HB_MAKE_PLAT)_$(HOST_PLAT)$(DIRSEP)$(HB_SHORTNAME)
   endif

   LIB_DEST=..$(DIRSEP)lib$(DIRSEP)$(HB_MAKE_PLAT)_$(HOST_PLAT)$(DIRSEP)$(HB_SHORTNAME)$(DIRSEP)

else

   MONTH=$(shell date +'%m')
   YEAR=$(shell date +'%Y')
   FECHA=$(shell date +'%m-%Y')

   $(shell cd $(TGTK_DIR); git checkout-index --prefix=preinstall/ -a -f )
   $(info se genera directorio con fuentes de Harbour)
   $(info $(HARBOUR_PATH))
   #$(shell cd ~$(HARBOUR_PATH); git checkout-index --prefix=hb_git/ -a -f )
   #$(shell cd ~/harbour-project; git checkout-index --prefix=hb_git/ -a -f )

   LIBDIR_TGTK_ =$(LIBDIR_TGTK)$(DIRSEP)$(PLATFORM_NAME)$(HB_SHORTNAME)
   LIB_DEST=..$(DIRSEP)$(PLATFORM_NAME)$(HB_SHORTNAME)$(DIRSEP)

   exit
endif
$(info Finalizada creacion de carpeta preinstall. )
$(info  )


$(shell mkdir $(LIBDIR_TGTK)$(DIRSEP)hb)
$(info copy $(LIBDIR_TGTK_)$(DIRSEP)*.a $(LIBDIR_TGTK)$(DIRSEP)hb$(DIRSEP) )
ifeq ($(HB_MAKE_PLAT),win)
   $(shell copy $(LIBDIR_TGTK_)\*.a $(LIBDIR_TGTK)\hb\ > %TEMP%/out.log)
else
   $(shell cp $(LIBDIR_TGTK_)/*.a $(LIBDIR_TGTK)/hb/ > /tmp/out.log)
endif


#TGTK_VERSION=2.1  defined in config/global.mk
$(info  )
$(info * ------------------------------------- * )
INSTALL_DIR=$(subst %\:,C\:,$(TGTK_DIR))_$(TGTK_VERSION)
$(info Destino de instalacion: $(INSTALL_DIR) )

DEST_MINGWDIR=$(INSTALL_DIR)\MinGW
#$(info MinGW Path: $(DEST_MINGWDIR))

MSQL_PATH=$(subst ",,$(dir $(MYSQL_PATH)))
#$(info MySQL Path: $(MSQL_PATH) )
PSQL_PATH=$(subst ",,$(dir $(POSTGRE_PATH)))
#$(info PgSQL Path: $(PSQL_PATH) )
#$(info  )

#-- RUTA DE FUENTES DE HARBOUR
ifeq ($(HB_SOURCE_PATH),)
$(info * ------------------------------------- *                   )
$(info *              ATENCION.                                    )
$(info * ------------------------------------- *                   )
$(info * La variable con la ruta a los fuentes de Harbour,         )
$(info * no esta definida. Se asume /harbour-project               )
$(info * Puede indicar la variable mediante la instruccion:        )
$(info * SET HB_SOURCE_PATH=RUTA.                                  )
$(info * Ejemplo:                                                  )
$(info * SET HB_SOURCE_PATH=\harbour-project                       )
   HB_SOURCE_PATH:=$(HARBOUR_PATH)$(DIRSEP)hb_git
endif
#$(info Harbour (Source) Path: $(HB_SOURCE_PATH) )

HB_PATH:=$(dir $(HB_BIN_INSTALL))

# (shell cmd /C start svn export --force ../ ./preinstall/ )
# (shell cmd /C start svn export ../ ./preinstall/ )
# (shell cd $(TGTK_DIR); makedir preinstall; git checkout-index --prefix=preinstall/ -a -f )
#git checkout-index -a -f --prefix=/destination/path/

$(info * ------------------------------------- * )
$(info Ruta GTK a utilizar: $(GTK_PATH) )
$(info Ruta Harbour a utilizar: $(HB_PATH) )
$(info Ruta MinGW a utilizar: $(TGTK_BIN) )
$(info Ruta MySQL a utilizar: $(MSQL_PATH) )
$(info Ruta PgSQL a utilizar: $(PSQL_PATH) )
$(info * ------------------------------------- * )


#--- Se copia carpeta de binarios a otra para evitar que se incluyan
#--- archivos temporales
$(shell echo. )
$(info Copiando binarios a carpeta 'binaries' en Harbour.)
$(shell mkdir $(HARBOUR_PATH)$(DIRSEP)binaries)
$(info copy $(HB_BIN_INSTALL)$(DIRSEP)*.* $(HARBOUR_PATH)$(DIRSEP)binaries$(DIRSEP) )
$(shell copy /Y $(HB_BIN_INSTALL)$(DIRSEP)*.* $(HARBOUR_PATH)$(DIRSEP)binaries$(DIRSEP) > %TEMP%/out.log)
$(shell echo. )


# --------------------------------------
# Inicializa Archivos .nsh
# --------------------------------------
$(info Generando Valores Iniciales (init.nsh) )
$(shell echo   File /nonfatal /r /x CVS $(ROOT)$(DIRSEP)preinstall\*.* > init.nsh )
$(shell echo.   >> init.nsh )
$(shell echo   SetOutPath "$$INSTDIR$(DIRSEP)lib" >> init.nsh )
$(shell echo   File /nonfatal "$(LIB_DEST)libhbgtk.a" >> init.nsh )
$(shell echo   File /nonfatal "$(LIB_DEST)libgclass.a" >> init.nsh )


# --------------------------------------
# Inicializa Fecha (date.nsh)
# --------------------------------------
$(info Inicializando date.nsh )
ifeq ($(MES),12)
   FECHA="Dic, $(YEAR)"
endif
$(shell echo.   > date.nsh )
$(shell echo      	StrCpy $$1 "$(FECHA)" >> date.nsh )


$(info Inicializando dolphin.nsh )
$(shell echo.   > dolphin.nsh )
$(shell echo   SetOutPath "$$INSTDIR$(DIRSEP)lib"  >> dolphin.nsh )
$(shell echo   File /nonfatal "$(LIB_DEST)libmysql.a"  >> dolphin.nsh )
$(shell echo   File /nonfatal "$(LIB_DEST)libhbmysql.a"  >> dolphin.nsh )
$(shell echo   File /nonfatal "$(LIB_DEST)libtdolphin.a"  >> dolphin.nsh )


$(info Inicializando mysql.nsh )
$(shell echo.   > mysql.nsh )


$(info Inicializando pgsql.nsh )
$(shell echo.   > pgsql.nsh )
$(shell echo  SetOutPath "$$INSTDIR$(DIRSEP)lib" >> pgsql.nsh )
$(shell echo  File /nonfatal "$(LIB_DEST)libpq.a" >> pgsql.nsh )
$(shell echo  File /nonfatal "$(LIB_DEST)libhbpg.a" >> pgsql.nsh )


$(info Inicializando gtk.nsh )
$(shell echo.   > gtk.nsh )


$(info Inicializando question.nsh )
$(shell echo.   > question.nsh )
$(shell echo    StrCpy $$DEST_MINGWDIR "$$INSTDIR\MinGW"    >> question.nsh )
$(shell echo    StrCpy $$DEST_GTKDIR "$$INSTDIR\GTK+"    >> question.nsh )
$(shell echo    StrCpy $$DEST_HBDIR "$$INSTDIR\hb$(HB_VERSION)-mingw"    >> question.nsh )


# --------------------------------------
# Genera Valores Iniciales
# --------------------------------------


# --------------------------------------
# Genera Instalador Basico
# --------------------------------------
$(info Generando Instalador Basico (Solo t-gtk) )

$(info Inicializando install_name.nsh )
$(shell echo   Name "t-gtk $(TGTK_VERSION)"         > install_name.nsh )
$(shell echo   InstallDir "C:\t-gtk_$(TGTK_VERSION)" >> install_name.nsh )
$(shell echo   OutFile "t-gtk_$(TGTK_VERSION)_setup.exe"        >> install_name.nsh )
$(shell echo.  >> install_name.nsh )


# --------------------------------------
# Definicion de parameters.nsh
# --------------------------------------
$(shell echo   StrCpy $$SRC_MINGWDIR "$(TGTK_BIN)"       >  parameters.nsh)
$(shell echo   StrCpy $$SRC_GTKDIR   "$(GTK_PATH)"       >> parameters.nsh)
$(shell echo   StrCpy $$SRC_HBDIR    "$(HB_BIN_INSTALL)" >> parameters.nsh)
$(shell echo   StrCpy $$SRC_HBVER    "$(HB_VERSION)"     >> parameters.nsh)
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

$(shell echo   !macro PSQL_PATH >> parameters.nsh )
$(shell echo     StrCpy $$RULES_PGSQL    "$$RULES_PGSQLPOSTGRE_PATH=$(POSTGRE_PATH)$$\r$$\n" >> parameters.nsh )
$(shell echo   !macroend >> parameters.nsh)



# --------------------------------------
# Crea Instalador Basico
# --------------------------------------
ifeq ($(NSIS_PATH),)
   NSIS_PATH =$(PROGRAMFILES)\NSIS
endif
$(info Puede tardar varios minutos, por favor espere. )
$(shell "$(NSIS_PATH)\makensis.exe" /V3 /Onsis.log t-gtk.nsi )
$(shell cmd /C start nsis.log )
$(info echo.)
$(info echo.)


# --------------------------------------
# Verifica existencia de componentes externos
# --------------------------------------
 EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat \
	 $(TGTK_DIR)

#-- TDOLPHIN

# $(info * Verificando ruta de tdolphin )
# $(shell $(EXECUTE) $(TGTK_DIR)\tdolphin\c\function.c)
# ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
#   $(info -------------------------------------------------------- )
#   $(info *  No se incluye tdolphin - No ha sido localizado en: )
#   $(info * $(TGTK_DIR)\tdolphin )
#   $(info -------------------------------------------------------- )
# else
#   $(shell echo   SetOutPath "$$INSTDIR\tdolphin"       > dolphin.nsh )
#   $(shell echo   File /nonfatal /r "$(TGTK_DIR)\tdolphin\*.*"  >> dolphin.nsh )
   $(shell echo.    > dolphin.nsh )
   $(shell echo   SetOutPath "$$INSTDIR\lib" >> dolphin.nsh )
   $(shell echo   File /nonfatal /r "$(LIB_DEST)libmysql.a"  >> dolphin.nsh )
   $(shell echo   File /nonfatal /r "$(LIB_DEST)libhbmysql.a"  >> dolphin.nsh )
   $(shell echo   File /nonfatal /r "$(LIB_DEST)libtdolphin.a"  >> dolphin.nsh )
# endif


#-- MySQL

 $(info * Verificando ruta de Cliente MySQL )
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

 $(info * Verificando ruta de Cliente PostgreSQL )
 $(shell echo.   > pgsql.nsh )
 $(shell $(EXECUTE) $(PSQL_PATH)\lib\libpq.dll)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye PostgreSQL Client - No ha sido localizado en: )
   $(info * $(PSQL_PATH) )
   $(info -------------------------------------------------------- )
 else
   $(shell echo   SetOutPath "$$INSTDIR\PgSQLClient"       > pgsql.nsh )
   $(shell echo   File /nonfatal /r "$(PSQL_PATH)*.*"  >> pgsql.nsh )
#   $(shell echo   SetOutPath "$$INSTDIR\PgSQLClient\include"     >> pgsql.nsh )
#   $(shell echo   File /nonfatal "$(PSQL_PATH)include\*.*"  >> pgsql.nsh )
 endif
$(shell echo  SetOutPath "$$INSTDIR$(DIRSEP)lib" >> pgsql.nsh )
$(shell echo  File /nonfatal "$(LIB_DEST)libpq.a" >> pgsql.nsh )
$(shell echo  File /nonfatal "$(LIB_DEST)libhbpg.a" >> pgsql.nsh )


#-- GTK+

 $(info * Verificando ruta de GTK+ )
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

 $(info * Verificando ruta de MinGW )
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

 $(info * Verificando ruta de Harbour )
 $(shell $(EXECUTE) $(HB_PATH)mingw\harbour.exe)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info -------------------------------------------------------- )
   $(info *  No se incluye Harbour - No ha sido localizado en: )
   $(info * $(HB_PATH) )
   $(info * No se continua la generacion del instalador.           )
   $(info -------------------------------------------------------- )
   $(error No se puede generar instalador FULL )
 else

   $(shell echo   SetOutPath "$$DEST_HBDIR$(DIRSEP)bin"       > harbour.nsh )
   $(shell echo   File /nonfatal /r "$(HARBOUR_PATH)$(DIRSEP)binaries$(DIRSEP)*.*"  >> harbour.nsh )
   $(shell echo   SetOutPath "$$DEST_HBDIR$(DIRSEP)include"       >> harbour.nsh )
   $(shell echo   File /nonfatal /r "$(HB_SOURCE_PATH)$(DIRSEP)include$(DIRSEP)*.*"  >> harbour.nsh )
   $(shell echo   SetOutPath "$$DEST_HBDIR$(DIRSEP)contrib"       >> harbour.nsh )
   $(shell echo   File /nonfatal /r "$(HB_SOURCE_PATH)$(DIRSEP)contrib$(DIRSEP)*.*"  >> harbour.nsh )
   $(shell echo   SetOutPath "$$DEST_HBDIR$(DIRSEP)lib"       >> harbour.nsh )
   $(shell echo   File /nonfatal /r "$(HB_LIB_INSTALL)$(DIRSEP)*.a"  >> harbour.nsh )

   #Fuentes de Harbour.
   $(info Generando hbsources.nsh )
   $(shell echo   SetOutPath "$$DEST_HBDIR"       > hbsources.nsh )
   $(shell echo   File /nonfatal /r "$(HB_SOURCE_PATH)$(DIRSEP)*.*"  >> hbsources.nsh )
 endif




# --------------------------------------
# Unidos o Separados (question.nsh)
# --------------------------------------
 $(shell echo !ifdef QUESTION > question.nsh )
 
 $(shell echo    MessageBox MB_YESNO \
                 "¿Desea colocar todos los componentes externos en \
	         $$INSTDIR\MinGW ?" IDYES true IDNO false >> question.nsh )
# $(shell echo   InstallDir "C:\t-gtk_$(TGTK_VERSION)" >> install_name.nsh )
 $(shell echo    true:        >> question.nsh )
 $(shell echo       DetailPrint "Todo a MinGW"    >> question.nsh )
 $(shell echo       StrCpy $$DEST_MINGWDIR "$$INSTDIR\MinGW"    >> question.nsh )
 $(shell echo       StrCpy $$DEST_GTKDIR "$$INSTDIR\MinGW"    >> question.nsh )
 $(shell echo       StrCpy $$DEST_HBDIR "$$INSTDIR\hb$(HB_VERSION)-mingw"    >> question.nsh )
 $(shell echo       Goto next    >> question.nsh )
 $(shell echo    false:        >> question.nsh )
 $(shell echo       DetailPrint "Separados!"    >> question.nsh )
 $(shell echo       StrCpy $$DEST_MINGWDIR "$$INSTDIR\MinGW"    >> question.nsh )
 $(shell echo       StrCpy $$DEST_GTKDIR "$$INSTDIR\GTK+"    >> question.nsh )
 $(shell echo       StrCpy $$DEST_HBDIR "$$INSTDIR\hb$(HB_VERSION)-mingw"    >> question.nsh )
 $(shell echo    next:        >> question.nsh )
 $(shell echo !else >> question.nsh )
 $(shell echo   StrCpy $$DEST_MINGWDIR \MinGW >> question.nsh )
 $(shell echo   StrCpy $$DEST_GTKDIR   \GTK >> question.nsh )
 $(shell echo   StrCpy $$DEST_HBDIR    \hb$(HB_VERSION) >> question.nsh )
 $(shell echo !endif >> question.nsh )


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
$(shell "$(NSIS_PATH)\makensis.exe" /V3 /Onsis.log t-gtk.nsi )
$(shell notepad nsis.log )

$(info Finalizado. )

#eof
