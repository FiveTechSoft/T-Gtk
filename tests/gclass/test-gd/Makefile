# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../
SETTINGS=$(ROOT)config/settings/minimal.mk

TARGET = test
SOURCES = test.prg test_gdapi.prg test_animgif.prg \
	  test_class.prg test_barcode.prg test_barcode2.prg \
	  test_antialia.prg test_counter.prg

#RESOURCE_FILE = resource.rc

### incluir soporte de LibGD ###
export LIBGD =yes

include $(ROOT)Rules.make

