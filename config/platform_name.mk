#
# Rutina para generar archivo setenv.mk
#

$(info )
$(info Ejecutando config/platform_name.mk )

#PLATFORM_NAME :=$(HB_MAKE_PLAT)$(HB_MAKE_ISSUE)$(DIRSEP)$(HOST_PLAT)$(DIRSEP)
PLATFORM_NAME :=$(HB_MAKE_PLAT)_$(HOST_PLAT)$(DIRSEP)
ifeq ($(HB_MAKE_PLAT),linux)
   PLATFORM_NAME :=$(HB_MAKE_ISSUE)$(DIRSEP)$(HOST_PLAT)$(DIRSEP)
endif

export PLATFORM_NAME

#eof
