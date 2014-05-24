##################################
#
# Makefile para T-GTK codigo de C
#
ROOT = ../
include $(ROOT)config/global.mk
include $(ROOT)$(SETENV)

TARGET =libcurl-hb.a
SOURCE_TYPE=c
CSOURCES =easy.c

CFLAGS+=-I. -I$(ROOT)include $(shell pkg-config --cflags libcurl)

ifeq ($(HB_MAKE_PLAT),win)
   ifeq ($(notdir $(wildcard $(subst \,/,./libcurl.a))),)
      $(info Generando libcurl.a )
      $(shell dlltool -d libcurl.def -D libcurl.dll -k -l libcurl.a -S as.exe )
   endif
endif

include $(TGTK_DIR)/Rules.make
