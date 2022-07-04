##################################
#  T-Gtk  #  Initial Detection   #
##################################

$(info )
$(info * Ejecutando config/detect.mk )

#lc (lowercase)
export lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

# Make platform detection
ifneq ($(findstring COMMAND,$(SHELL)),)
   HB_MAKE_PLAT := dos
   HOST_PLAT := x86
else
   ##ifeq ($(findstring sh.exe,$(SHELL ver)),)
   #
   # $(shell ver)  -- Aplica en Windows  (en minusculas)
   #
   ifneq ($(findstring Windows,$(shell ver)),)
      HB_MAKE_PLAT := win
      HOST_PLAT :=$(PROCESSOR_ARCHITECTURE)
      ifneq ($(findstring XP,$(shell ver )),)
         HB_MAKE_ISSUE :=XP
      endif
      ifneq ($(findstring Microsoft,$(shell ver )),)
         HB_MAKE_ISSUE :=win
      endif
   else
      ifneq ($(findstring CMD.EXE,$(SHELL)),)
         HB_MAKE_PLAT :=os2
      else
         ifneq ($(findstring /bin/sh,$(SHELL)),)
           HB_MAKE_PLAT := linux
           HB_MAKE_ISSUE:=$(shell cat /etc/issue | cut -d\  -f1,2 | tr -s " " "_" | tr -s "/" "-" )
           HB_COMPILER  := gcc
           HOST_PLAT := $(shell uname -p)
           ifeq ($(HOST_PLAT),unknown)
             HOST_PLAT := $(shell uname -m)
           endif
         else
           $(error Plataforma no detectada o no soportada.. )
         endif
      endif
   endif
endif
$(info Plataforma detectada: $(HB_MAKE_PLAT) )
$(info Plataforma detectada (HOST): $(HOST_PLAT) )

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
export HB_MAKE_ISSUE
export HOST_PLAT
export DIRSEP


#Detectando %PROGRAMFILES% en Windows.
ifeq ($(HB_MAKE_PLAT),win)
  ifeq ($(PROGRAMFILES),)
     export PROGRAMFILES :=$(shell echo %PROGRAMFILES%)
  endif
endif


#export GTK_MAJOR_VERSION = 2
#export GTK_MINOR_VERSION = 0

# Intentamos detectar dependencias varias...
# ejemplo libgttrm puede depender de libgpm (soporte de mouse)
ifneq ($(HB_MAKE_PLAT),win)
   ifneq ($(findstring libgpm,$(shell dpkg --get-selections | grep "libgpm-dev" )),)
      export OS_LIBS := -lgpm
   endif

   ifneq ($(findstring libssl,$(shell dpkg --get-selections | grep "libssl-dev" )),)
      export OS_LIBS += -lssl
   endif

   ifneq ($(findstring libgtk-3-dev,$(shell dpkg --get-selections | grep "libgtk-3" )),)
      export GTK_MAJOR_VERSION = 3
      export GTK_MINOR_VERSION = $(shell dpkg -s libgtk-3-0 | grep '^Version' | cut -c12)
   endif

   ifneq ($(findstring libgtk2.0-dev,$(shell dpkg --get-selections | grep "libgtk2.0-dev" )),)
      export GTK_MAJOR_VERSION = 2
      export GTK_MINOR_VERSION = $(shell dpkg -s libgtk2.0-dev | grep '^Version' | cut -c12)
   endif


endif


