# Atención, la ruta include/lib de tdolphin tiene que estar definida, aqui o en rules.make
ROOT = ../../../
include $(ROOT)config/global.mk

TARGET = helpdesk
SOURCES = helpdesk.prg \
          gmante.prg \
          mnt_categoria.prg \
          mnt_cadena.prg \
          mnt_departamentos.prg \
          mnt_status.prg \
          mnt_establecimientos.prg \
          mnt_tipoconexion.prg \
          mnt_usuarios.prg \
          funciones.prg \
          add_incidencia.prg \

PRGFLAGS=-I$(TGTK_DIR)/tdolphin/include
#LIBS=-L/home/rafa/repositorios/subversion/tdolphindevel/lib/HARBOUR/gcc/dolphin -ldolphin
ifneq ($(HB_MAKE_PLAT),win)
   LIBFILES_ =-lmysqlclient
endif
LIBFILES_ +=-L./ -ltdolphin -lhbct

include $(ROOT)Rules.make

