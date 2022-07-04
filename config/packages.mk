#
# Utilidad para verificar Paquetes Instalados
#

$(info )
$(info * Ejecutando config/packages.mk )


# Verificamos que esta tgtk3.pc pkg-config
$(info * Verificando existencia de tgtk3.pc en: $(PKG_CONFIG_PATH))
ifeq ($(notdir $(wildcard $(PKG_CONFIG_PATH)/tgtk3.pc)),)
  $(info * Registrando t-gtk en pkg-config... $(PKG_CONFIG_PATH))
  ifeq ($(HB_MAKE_PLAT),win)
     $(shell type $(TGTK_DIR)\utils\config_system\tgtk3_win.pc > $(PKG_CONFIG_PATH)\tgtk3.pc )
  else
     $(shell cat $(TGTK_DIR)/utils/config_system/tgtk3_gnu.pc > $(PKG_CONFIG_PATH)/tgtk3.pc)
  endif
endif

export PACKAGES :=$(shell pkg-config --list-all  )
ifeq ($(findstring tgtk,$(PACKAGES)),)
   ifeq ($(HB_MAKE_PLAT),win)
      ifeq ($(findstring PKG_CONFIG_PATH,$(shell set)),)
         $(info ------------------------------------------------)
         $(info *  ERROR Variable de Entorno PKG_CONFIG_PATH   *)
         $(info *        No Definida!                          *)
         $(info ------------------------------------------------)
         $(error PKG_CONFIG_PATH not found.)
      endif
   endif
   $(info ----------------------------------------)
   $(info *  ERROR pkg-config No Ejecuta!        *)
   $(info ----------------------------------------)
   $(info *  posiblemente no esta en el PATH     *)
   $(info *  la ruta a PKG_CONFIG o              *)
   $(info *  No hay lista de paquetes            *)
   $(info ----------------------------------------)
   $(info PKG_CONFIG_PATH --> $(PKG_CONFIG_PATH) )
   $(info PACKAGES --> $(PACKAGES) )
   $(error Error, aparentemente no existe tgtk.pc en la ruta de pkgconfig )
endif

ifeq ($(findstring gtk+,$(PACKAGES)),)
   ifeq ($(AUTO_INST),yes)
     include $(ROOT)config/links.mk
     # Descargar Paquetes Externos
     ifeq ($(TGTK_DOWN),yes)
       include $(ROOT)config/download.mk
     endif
     # Descomprime Paquetes Externos
     ifeq ($(TGTK_UNZIP),yes)
       include $(ROOT)config/unzip.mk
     endif
   else
   $(info ----------------------------------------)
   $(info *  ERROR GTK+ No Encontrado!           *)
   $(info ----------------------------------------)
   $(error Error, aparentemente no existe o no localiza GTK+ )
   endif
endif

ifneq ($(GTK_MAJOR_VERSION),3)
   ifeq ($(findstring libglade-2.0,$(PACKAGES)),)
      $(info ----------------------------------------)
      $(info *  ERROR LibGlade No Encontrado!       *)
      $(info ----------------------------------------)
      $(error Error, aparentemente no existe o no localiza LibGlade )
   endif
endif

