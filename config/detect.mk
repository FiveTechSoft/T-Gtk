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

