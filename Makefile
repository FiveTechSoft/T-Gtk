##################################
#  T-Gtk makefile principal
##################################
export ROOT := ./

include $(ROOT)/config/global.mk

all:
	make -C src/gclass
	make -C hbgtk
	make -C hbgtk/lang

clean:
	make -C src/gclass clean
	make -C hbgtk clean
	make -C hbgtk/lang clean
	make -C tests clean


install: all
	make -C src/gclass install
	make -C hbgtk install
	make -C hbgtk/lang install

.PHONY: clean install

