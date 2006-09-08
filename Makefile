##################################
#  T-Gtk makefile principal
##################################
all:
	make -C src/gclass
	make -C hbgtk

clean:
	make -C src/gclass clean
	make -C hbgtk clean
	make -C tests clean


install: all
	make -C src/gclass install
	make -C hbgtk install

.PHONY: clean install

