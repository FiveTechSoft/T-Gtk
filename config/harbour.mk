###################################################
# Please, use tool /utils/config_system/configure # 
# for create this file                            #
# OR modify correct the paths.                    #
###################################################

##############################################
# System Configure of T-Gtk.
# (c)2004-11 gTXBASE Team.
# 
##############################################

##############################################
# INDICAR RUTA DEL COMPILADOR XBASE
ifeq ($(HB_MAKE_PLAT),win)
# Ruta en Windows:
  ifeq ($(HARBOUR_PATH),)    
    HARBOUR_PATH  =\harbour-project
  endif

  ifeq ($(HB_BIN_INSTALL),)
    export HB_BIN_INSTALL =$(HARBOUR_PATH)\bin\win\mingw
  endif
  ifeq ($(HB_INC_INSTALL),)
    export HB_INC_INSTALL =$(HARBOUR_PATH)\include
  endif
  ifeq ($(HB_LIB_INSTALL),)
    export HB_LIB_INSTALL =$(HARBOUR_PATH)\lib\win\mingw
  endif
  # -- Version = [ 3.0 | 3.1 ]
  #ifeq ($(HB_VERSION),)
  #  export HB_VERSION =31
  #endif
else
# Ruta en GNU/Linux:
  ifeq ($(HARBOUR_PATH),)    
    HARBOUR_PATH  =/usr/local
  endif

  ifeq ($(HB_BIN_INSTALL),)
    export HB_BIN_INSTALL =$(HARBOUR_PATH)/bin
  endif
  ifeq ($(HB_INC_INSTALL),)
    export HB_INC_INSTALL =$(HARBOUR_PATH)/include/harbour
  endif
  ifeq ($(HB_LIB_INSTALL),)
    export HB_LIB_INSTALL =$(HARBOUR_PATH)/lib/harbour
  endif
  # -- Version = [ 2.0 | 2.1 ]
  #ifeq ($(HB_VERSION),)
    #export HB_VERSION =2.1
  #endif
endif
##############################################

##############################################
#  Librerias para Harbour
##############################################

#Determinar version de Harbour.
#ifneq ($(HB_VERSION),)
#   ifeq ($(HB_VERSION),2.0)
#      export HB_VERSION=20
#   else
#      ifeq ($(HB_VERSION),2.1)
#         export HB_VERSION=21
#      endif
#   endif
#else
#   export HB_VERSION=31
#endif


ifeq ($(HB_VERSION),)
  ifneq ($(notdir $(wildcard $(subst \,/,$(HB_BIN_INSTALL)harbour))),)
     ifeq ($(HB_MAKE_PLAT),win)
       VARTEMP:=$(word 2,$(shell $(HB_BIN_INSTALL)$(DIRSEP)harbour -build ) )
       VARTEMP:=$(subst .,,$(VARTEMP))
       VARTEMP:=$(subst 0dev,,$(VARTEMP))
       ifneq ($(VARTEMP),)
         HB_VERSION =$(VARTEMP)
       endif
     endif
  endif

  ifeq ($(HB_MAKE_PLAT),linux)
    $(shell echo `harbour -build` | cut -c9-11 > $(ROOT)config/hbversion )
    HB_VERSION =$(subst .,,$(shell cat $(ROOT)config/hbversion))
  endif

  export HB_VERSION
endif




# Librerias para Multihilo:
ifeq ($(HB_MT),MT)
   export HB_LIBS_MT = -lhbvmmt
else
   export HB_LIBS_MT = -lhbvm
endif

# Windows:
ifeq ($(HB_MAKE_PLAT),win)
# GT Driver:
  ifeq ($(HB_GT_LIBS),)
    HB_GT_LIBS=-lgtwin -lgtwvt
  endif

  ifeq ($(HB_LIBFILES_),)
    export HB_LIBFILES_ = $(HB_LIBS_MT) -lhbcplr -lhbrtl -lhblang \
	         -lhbrdd -lhbmacro -lhbpp -lhbxpp \
                 -lhbsix -lhbdebug -lhbcommon -lrddntx -lrddfpt -lrddcdx \
                 -lxhb -lhbpp -lhbcpage -lhbwin -lhbpcre \
                 -lhbnetio $(HB_GT_LIBS) #-lhbzlib presenta conflicto con libz
  endif

# GNU/Linux:
else


# GT Driver:
  ifeq ($(HB_GT_LIBS),)
    HB_GT_LIBS=-lgtstd -lgtcgi -lgtpca -lgttrm
  endif

  ifeq ($(HB_LIBFILES_),)
    export HB_LIBFILES_ += $(HB_LIBS_MT) -lhbcplr -lhbpp -lhbcommon -lhbextern -lhbdebug -lhbvm \
                 -lhbrtl -lhblang -lhbcpage -lhbrdd -lrddntx \
                 -lrddnsx -lrddcdx -lrddfpt \
                 -lhbsix -lhbhsx -lhbusrrdd -lhbuddall -lhbrtl \
                 -lhbmacro -lhbcplr -lhbpp -lhbcommon $(HB_GT_LIBS) \
                 -lxhb -lhbxpp -lhbtip -lhbnetio -lhbct
  endif

endif



# Soporte SSL
ifneq ($(findstring libssl-dev,$(shell ls $(HB_LIB_INSTALL) | grep "libhbssl" )),)
   export HB_LIBFILES_ += -lhbssl -lhbtipssl
else
   $(info ! Compilación sin soporte para SSL (secure sockets layer).  )
endif

# Soporte a Graphic Library (LibGD)
ifeq ($(LIBGD), yes)
   ifeq ($(HB_MAKE_PLAT),win)
      export HB_LIBFILES_ += -lhbgd -lhbct -lgd.dll
   else
      export HB_LIBFILES_ += -lhbgd
   endif
endif

# Otros:
export HB_CFLAGS += -D_HB_API_INTERNAL_ -DHB_ARRAY_USE_COUNTER_OFF \
                    -D__COMPATIBLE_HARBOUR__ \
                    -DHB_LEGACY_TYPES_ON 
#                    -DHB_LEGACY_ON 


# Ruta a contrib/xhb para evitar error por no encontrar hbcompat.ch
#HB_INC_3RD = -I$(subst include,contrib$(DIRSEP)xhb ,$(HB_INC_INSTALL))  
#HB_INC_3RD += -I$(subst include,contrib$(DIRSEP)hbtip ,$(HB_INC_INSTALL)) 
ifeq ($(HB_MAKE_PLAT),win)
   HB_INC_3RD_PATH = $(HARBOUR_PATH)/contrib
else
   HB_INC_3RD_PATH = $(HARBOUR_PATH)/share/harbour/contrib
endif
HB_INC_3RD += -I$(HB_INC_3RD_PATH)/xhb
HB_INC_3RD += -I$(HB_INC_3RD_PATH)/hbtip


export HB_INC_3RD

