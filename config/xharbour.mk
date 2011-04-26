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
  XHARBOUR_PATH  =\xhb_mingw

  ifeq ($(XHB_BIN_INSTALL),)
    export XHB_BIN_INSTALL =$(XHARBOUR_PATH)\bin
  endif
  ifeq ($(XHB_INC_INSTALL),)
    export XHB_INC_INSTALL =$(XHARBOUR_PATH)\include
  endif
  ifeq ($(XHB_LIB_INSTALL),)
    export XHB_LIB_INSTALL =$(XHARBOUR_PATH)\lib
  endif
else
# Ruta en GNU/Linux:
  XHARBOUR_PATH  =/usr

  ifeq ($(XHB_BIN_INSTALL),)
    export XHB_BIN_INSTALL =$(XHARBOUR_PATH)/bin
  endif
  ifeq ($(XHB_INC_INSTALL),)
    export XHB_INC_INSTALL =$(XHARBOUR_PATH)/include/xharbour
  endif
  ifeq ($(XHB_LIB_INSTALL),)
    export XHB_LIB_INSTALL =$(XHARBOUR_PATH)/lib/xharbour
  endif
endif
##############################################

##############################################
#  Librerias para xHarbour
##############################################


# Librerias para Multihilo:
ifeq ($(HB_MT),MT)
  ifeq ($(XHB_LIBS_MT),)
    export XHB_LIBS_MT = -lvmmt -lrtlmt -lrddmt -lppmt \
                         -ldbfntxmt -ldbfcdxmt -lpthread
  endif
else
  ifeq ($(XHB_LIBS_MT),)
    export XHB_LIBS_MT = -lvm -lrtl -lrdd -lpp \
                         -ldbfntx -ldbfcdx
  endif
endif


# Windows:
ifeq ($(HB_MAKE_PLAT),win)
# GT Driver:
  XHB_GT_LIBS=-lgtwvt -lgtwin
  
  ifeq ($(XHB_LIBFILES_),)
    export XHB_LIBFILES_ = $(XHB_LIBS_MT) -llang -lmacro -ldbffpt -lhbsix -lhsx \
                 -lpcrepos -lcommon -lm $(XHB_GT_LIBS) -lstdc++ -lhbzip -lhbsix
  endif

# GNU/Linux:
else
# GT Driver:
  XHB_GT_LIBS=-lgtstd -lgttrm

  ifeq ($(XHB_LIBFILES_),)
    export XHB_LIBFILES_ = $(XHB_LIBS_MT) -llang -lmacro -lpp -ldbffpt -lcommon -lm -lhsx \
                 -lpcrepos $(XHB_GT_LIBS) -lcodepage -lct -ltip -lhbsix
  endif

endif

ifeq ($(XBASE_COMPILER),XHARBOUR)
  export HB_BIN_INSTALL =$(XHB_BIN_INSTALL)
  export HB_INC_INSTALL =$(XHB_INC_INSTALL)
  export HB_LIB_INSTALL =$(XHB_LIB_INSTALL)

  export HB_LIBFILES_ =$(XHB_LIBFILES_)
endif

#/eof
