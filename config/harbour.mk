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
  HARBOUR_PATH  =\harbour-project

  ifeq ($(HB_BIN_INSTALL),)
    export HB_BIN_INSTALL =$(HARBOUR_PATH)\bin\win\mingw
  endif
  ifeq ($(HB_INC_INSTALL),)
    export HB_INC_INSTALL =$(HARBOUR_PATH)\include
  endif
  ifeq ($(HB_LIB_INSTALL),)
    export HB_LIB_INSTALL =$(HARBOUR_PATH)\lib\win\mingw
  endif
  # -- Version = [ 2.0 | 2.1 ]
  ifeq ($(HB_VERSION),)
    export HB_VERSION =2.1
  endif
else
# Ruta en GNU/Linux:
  HARBOUR_PATH  =/usr/local

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
  ifeq ($(HB_VERSION),)
    export HB_VERSION =2.1
  endif
endif
##############################################

##############################################
#  Librerias para Harbour
##############################################

#Determinar version de Harbour.
ifneq ($(HB_VERSION),)
   ifeq ($(HB_VERSION),2.0)
      export HB_VERSION=20
   else
      ifeq ($(HB_VERSION),2.1)
         export HB_VERSION=21
      endif
   endif
else
   export HB_VERSION=21
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
    export HB_LIBFILES_ = $(HB_LIBS_MT) -lhbrtl -lhblang -lhbrdd -lhbmacro -lhbpp -lhbxpp \
                 -lhbsix -lhbdebug -lhbcommon -lrddntx -lrddfpt -lrddcdx \
                 -lhbsix -lxhb -lhbpp -lhbcpage -lhbwin -lhbpcre $(HB_GT_LIBS)
  endif

# GNU/Linux:
else
# GT Driver:
  ifeq ($(HB_GT_LIBS),)
    HB_GT_LIBS=-lgtstd -lgtcgi -lgtpca -lgttrm
  endif

  ifeq ($(HB_LIBFILES_),)
    export HB_LIBFILES_ = $(HB_LIBS_MT) -lhbcplr -lhbpp -lhbcommon -lhbextern -lhbdebug -lhbvm \
                 -lhbrtl -lhblang -lhbcpage -lhbrdd -lrddntx \
                 -lrddnsx -lrddcdx -lrddfpt \
                 -lhbsix -lhbhsx -lhbusrrdd -lhbuddall -lhbrtl \
                 -lhbmacro -lhbcplr -lhbpp -lhbcommon -lhbpcre $(HB_GT_LIBS) \
                 -lxhb -lhbxpp -lhbssl -lhbtipssl
  endif

endif

# Otros:
export HB_CFLAGS += -D_HB_API_INTERNAL_ -DHB_ARRAY_USE_COUNTER_OFF \
                    -D__COMPATIBLE_HARBOUR__


