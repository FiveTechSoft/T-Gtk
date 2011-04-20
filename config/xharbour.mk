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

  export XHB_BIN_INSTALL =$(XHARBOUR_PATH)\bin
  export XHB_INC_INSTALL =$(XHARBOUR_PATH)\include
  export XHB_LIB_INSTALL =$(XHARBOUR_PATH)\lib
else
# Ruta en GNU/Linux:
  XHARBOUR_PATH  =/usr

  export XHB_BIN_INSTALL =$(XHARBOUR_PATH)/bin
  export XHB_INC_INSTALL =$(XHARBOUR_PATH)/include/xharbour
  export XHB_LIB_INSTALL =$(XHARBOUR_PATH)/lib/xharbour
endif
##############################################

##############################################
#  Librerias para xHarbour
##############################################


# Librerias para Multihilo:
ifeq ($(HB_MT),MT)
   export XHB_LIBS_MT = -lvmmt -lrtlmt -lrddmt -lppmt \
                       -ldbfntxmt -ldbfcdxmt -lpthread
else
   export XHB_LIBS_MT = -lvm -lrtl -lrdd -lpp \
                       -ldbfntx -ldbfcdx
endif


# Windows:
ifeq ($(HB_MAKE_PLAT),win)
# GT Driver:
  XHB_GT_LIBS=-lgtwvt -lgtwin

  export XHB_LIBFILES_ = $(XHB_LIBS_MT) -llang -lmacro -ldbffpt -lhbsix -lhsx \
                 -lpcrepos -lcommon -lm $(XHB_GT_LIBS) -lstdc++ -lhbzip -lhbsix

# GNU/Linux:
else
# GT Driver:
  XHB_GT_LIBS=-lgtstd -lgttrm

  export XHB_LIBFILES_ = $(XHB_LIBS_MT) -llang -lmacro -lpp -ldbffpt -lcommon -lm -lhsx \
                 -lpcrepos $(XHB_GT_LIBS) -lcodepage -lct -ltip -lhbsix

endif

ifeq ($(XBASE_COMPILER),XHARBOUR)
  export HB_BIN_INSTALL =$(XHB_BIN_INSTALL)
  export HB_INC_INSTALL =$(XHB_INC_INSTALL)
  export HB_LIB_INSTALL =$(XHB_LIB_INSTALL)

  export HB_LIBFILES_ =$(XHB_LIBFILES_)
endif

