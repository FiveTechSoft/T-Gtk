##################################
#  T-Gtk  #  Initial Detection   #
##################################

# Make platform detection
ifneq ($(findstring COMMAND,$(SHELL)),)
   HB_MAKE_PLAT := dos
else
   ifneq ($(findstring sh.exe,$(SHELL)),)
      HB_MAKE_PLAT := win
   else
      ifneq ($(findstring CMD.EXE,$(SHELL)),)
         HB_MAKE_PLAT := os2
      else
         HB_MAKE_PLAT := unix
         HB_COMPILER  := gcc
      endif
   endif
endif
# Directory separator default
ifeq ($(DIRSEP),)
   DIRSEP := /
   ifeq ($(HB_MAKE_PLAT),win)
      DIRSEP := $(subst /,\,\)
   endif
endif
# Path separator default
ifeq ($(PTHSEP),)
   # small hack, it's hard to detect what is real path separator because
   # some shells in MS-DOS/Windows translates MS-DOS style paths to POSIX form
   ifeq ($(subst ;,:,$(PATH)),$(PATH))
      PTHSEP := :
   else
      PTHSEP := ;
   endif
endif

export HB_MAKE_PLAT
export DIRSEP

export PACKAGES :=$(shell pkg-config --list-all  )

ifeq ($(findstring tgtk,$(PACKAGES)),)
   $(info ----------------------------------------)
   $(info *  ERROR T-GTK No Encontrado!          *)
   $(info ----------------------------------------)
   $(error Error, aparentemente no existe tgtk.pc en la ruta de pkgconfig )
endif

ifeq ($(findstring gtk+,$(PACKAGES)),)
   $(info ----------------------------------------)
   $(info *  ERROR GTK+ No Encontrado!           *)
   $(info ----------------------------------------)
   $(error Error, aparentemente no existe o no localiza GTK+ )
endif

ifeq ($(findstring libglade-2.0,$(PACKAGES)),)
   $(info ----------------------------------------)
   $(info *  ERROR LibGlade No Encontrado!       *)
   $(info ----------------------------------------)
   $(error Error, aparentemente no existe o no localiza LibGlade )
endif

# Intentamos detectar dependencias a algunas GT... 
# ejemplo libgttrm puede depender de libgpm (soporte de mouse)
ifneq ($(HB_MAKE_PLAT),win)
   ifneq ($(findstring libgpm,$(shell dpkg --get-selections | grep "libgpm-dev" )),)
      export OS_GT_LIBS := -lgpm
   endif
endif

