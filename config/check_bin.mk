#
# Revisa que los paquetes estan en TGTK_BIN o GTK_PATH
# Si, AUTO_INST esta seteado a yes, puede intentar descargar y descomprimir
#
ifeq ($(HB_MAKE_PLAT),win)

$(info )
$(info * Ejecutando config/check_bin.mk)

# Verificamos que la ruta GTK_PATH o TGTK_BIN estan en el PATH
$(info * Buscando GTK_PATH ($(GTK_PATH)\bin) en la Variable de Entorno PATH.)
ifeq ($(findstring $(GTK_PATH)\bin,$(PATH)),)
  $(info ** No Encontrado valor de GTK_PATH en path.)

  # Ahora Buscamos la Ruta TGTK_BIN
  $(info * Buscando TGTK_BIN ($(TGTK_BIN)\bin) en la Variable de Entorno PATH.)
  ifeq ($(findstring $(TGTK_BIN)\bin,$(PATH)),)
     $(info ** No Encontrado valor de TGTK_BIN en path. )
     $(info -------------- )
     $(info *  ATENCION  * )
     $(info -------------- )
     $(info * No coinciden las rutas GTK_PATH o TGTK_BIN )
     $(info * definidas en config/global.mk              )
     $(info * No sera posible localizar pkg-config.exe   )
     $(info * Por favor, revise las rutas y variables.   )
     $(info -------------- )
     $(error )
  else
     $(info * Encontrada $(TGTK_BIN)\bin en el path!)
  endif
else
  $(info * Encontrada $(GTK_PATH)\bin en el path!)
endif



# Buscamos pkg-config.exe en las rutas de GTK_PATH o TGTK_BIN

EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat $(TGTK_DIR) 

$(info * Buscando pkg-config.exe en GTK_PATH ->$(GTK_PATH)\bin)
$(shell $(EXECUTE) $(GTK_PATH)\bin\pkg-config.exe)

ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
  $(info * No encontrado... )
  
  $(info * Buscando pkg-config.exe en TGTK_BIN ->$(TGTK_BIN)\bin)
  $(shell $(EXECUTE) $(TGTK_BIN)\bin\pkg-config.exe)

  ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
    $(info No Encontrado... )

    ifeq ($(AUTO_INST),yes)
      include $(ROOT)config/links.mk
      # Descargar Paquetes Externos
      ifeq ($(TGTK_DOWN),yes)
        include $(ROOT)config/download.mk
      endif
      # Descomprime Paquetes Externos
      ifeq ($(TGTK_UNZIP),yes)
        ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\unzip.log)),yes)
           include $(ROOT)config/unzip.mk
           $(shell echo yes > $(TGTK_DIR)\config\unzip.log)
        endif
      endif
    else
      $(info Para intentar descargar, se debe setear las variables:) 
      $(info .   SET AUTO_INST=yes )
      $(info .   SET TGTK_DOWN=yes )
      $(info $(PKG_CONFIG_PATH))
    endif

  else
     $(info * Encontrado pkg-config.exe en $(TGTK_BIN)!)
  endif
else
  $(info * Encontrado pkg-config.exe $(GTK_PATH)!)
endif



# Buscamos wget

EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat $(TGTK_DIR) 

$(info * Buscando wget.exe en GTK_PATH ->$(GTK_PATH)\bin)
$(shell $(EXECUTE) $(GTK_PATH)\bin\wget.exe)

ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
  $(info * No encontrado... )

  $(info * Buscando wget.exe en TGTK_BIN ->$(TGTK_BIN)\bin)
  $(shell $(EXECUTE) $(TGTK_BIN)\bin\wget.exe)

  ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
    $(info No Encontrado... )

    ifeq ($(AUTO_INST),yes)
      $(info Debe descargar y descomprimir wget en una ruta como $(TGTK_BIN) )

      $(shell cmd /C start http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip)
      $(shell cmd /C start http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip)

    endif

  endif

endif


endif
#/eof