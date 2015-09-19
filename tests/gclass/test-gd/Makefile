# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ROOT = ../../../
SETTINGS=$(ROOT)config/settings/minimal.mk

TARGET = test
SOURCES = test.prg

RESOURCE_FILE = resource.rc

### incluir soporte de LibGD ###
export LIBGD =yes

include $(ROOT)Rules.make

