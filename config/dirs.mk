#
# Verifica Existencia de Directorios de T-GTK
#
$(info )
$(info Ejecutando config/dirs.mk)
ifeq ($(notdir $(wildcard $(subst \,/,$(TGTK_INST))/*)),)
   $(info * Creando Directorio TGTK_INST --> $(TGTK_INST) )
   exit
   ifeq ($(HB_MAKE_PLAT),win)
      $(shell mkdir $(TGTK_INST))
   else
      $(shell mkdir -p -m 755 $(TGTK_INST))
   endif
endif

ifeq ($(notdir $(wildcard $(subst \,/,$(LIBDIR_TGTK))/*)),)
   $(info * Creando Directorio LIBDIR_TGTK_ --> $(LIBDIR_TGTK_) )
   ifeq ($(HB_MAKE_PLAT),win)
      $(shell mkdir $(LIBDIR_TGTK_))
   else
      $(shell mkdir -p -m 755 $(LIBDIR_TGTK_))
   endif
endif

ifeq ($(notdir $(wildcard $(subst \,/,$(INCLUDE_TGTK_PRG))/*)),)
   $(info * Creando Directorio INCLUDE_TGTK_PRG --> $(INCLUDE_TGTK_PRG) )
   ifeq ($(HB_MAKE_PLAT),win)
      $(shell mkdir $(INCLUDE_TGTK_PRG))
   else
      $(shell mkdir -p -m 755 $(INCLUDE_TGTK_PRG))
   endif
endif


ifeq ($(HB_MAKE_PLAT),win)
  ifeq ($(notdir $(wildcard $(subst \,/,$(TGTK_BIN))\*)),)
    $(info * Creando Directorio TGTK_BIN --> $(TGTK_BIN) )
    $(shell mkdir $(TGTK_BIN))
  endif
  ifeq ($(notdir $(wildcard $(subst \,/,$(TGTK_RUN))\*)),)
    $(info * Creando Directorio TGTK_RUN --> $(TGTK_RUN) )
    $(shell mkdir $(TGTK_RUN))
  endif
endif

