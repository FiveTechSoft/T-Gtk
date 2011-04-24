#
# Revision de PKG_CONFIG_PATH en Windows
#

ifeq ($(HB_MAKE_PLAT),win)

$(info )
$(info * Ejecutando config/pkgconfig.mk )

ifeq ($(PKG_CONFIG_PATH),)
  $(info -------------- )
  $(info *  ATENCION  * )
  $(info -------------- )
  $(info * No existe PKG_CONFIG_PATH como Variable de Entorno )
  $(info *                                                    )
  $(info * Se Asume TGTK_BIN+/lib/pkgconfig ->$(TGTK_BIN)/lib/pkgconfig )
  $(info -------------- )

  export PKG_CONFIG_PATH :=$(TGTK_BIN)/lib/pkgconfig

else
  $(info * PKG_CONFIG_PATH -> $(PKG_CONFIG_PATH) )
  $(info * Verificando la ruta de pkgconfig. )
  ifeq ($(notdir $(wildcard $(subst \,/,$(PKG_CONFIG_PATH)/*))),)

    EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat \
	      $(TGTK_DIR)

    $(info * Verificando ruta de pkgconfig en PKG_CONFIG_PATH ->$(PKG_CONFIG_PATH))
    #$(info $(EXECUTE) $(PKG_CONFIG_PATH))
    $(shell $(EXECUTE) $(PKG_CONFIG_PATH))
    ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
      $(info ----------------- )
      $(info *  ATENCION     * )
      $(info ----------------- )
      $(info * No existe $(PKG_CONFIG_PATH) )
      $(shell mkdir $(PKG_CONFIG_PATH))
      ifeq ($(AUTO_INST),yes)
        include $(TGTK_DIR)\config\check_bin.mk	
        $(info * Instalando Paquetes... )
        export TGTK_DOWN=yes
        export TGTK_UNZIP=yes
        $(shell del $(TGTK_DIR)\config\*.log)
        include $(TGTK_DIR)\config\download.mk
        include $(TGTK_DIR)\config\unzip.mk
        $(info )
        $(info * Por Favor, vuelva a intentar.. )
        $(error )
      endif
      $(info ----------------- )
    else
      ifeq ($(shell pkg-config --version),)
        ifeq ($(AUTO_INST),yes)
          $(info * Instalando Paquetes... )
          export TGTK_DOWN=yes
          export TGTK_UNZIP=yes
          include $(TGTK_DIR)\config\download.mk
          include $(TGTK_DIR)\config\unzip.mk
          #$(info )
          #$(info * Por Favor, vuelva a intentar.. )
          #$(error )
      endif
      endif
    endif
  else
      ifeq ($(AUTO_INST),yes)
        $(info * Instalando Paquetes... )
        export TGTK_DOWN=yes
        export TGTK_UNZIP=yes
        include $(TGTK_DIR)\config\download.mk
        include $(TGTK_DIR)\config\unzip.mk
        #$(info )
        #$(info * Por Favor, vuelva a intentar.. )
        #$(error )
      endif
  endif
#exit
endif

endif
#/eof
