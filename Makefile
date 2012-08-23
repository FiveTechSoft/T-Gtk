##################################
#  T-Gtk makefile principal
##################################
export ROOT := ./
export TGTK_DIR :=$(shell pwd)

include $(ROOT)/config/global.mk

all:
	make -C src/gclass
	make -C hbgtk
#	make -C hbgtk/lang
ifeq ($(VTE),yes)
	make -C src/vte
endif
ifeq ($(GNOMEDB),yes)
	make -C gnomedb
endif
ifeq ($(GTK_EXTRA),yes)
	make -C gtkextra
endif
ifeq ($(CURL),yes)
	make -C curl-hb
endif
ifeq ($(SQLITE),yes)
	make -C src/sqlite3
endif
ifeq ($(MYSQL),yes)
	make -C src/mysql
endif
ifeq ($(DOLPHIN),yes)
	make -C tdolphin
endif
ifeq ($(POSTGRE),yes)
	make -C src/pgsql
endif


clean:
	make -C src/gclass clean
	make -C hbgtk clean
#	make -C hbgtk/lang clean
#	make -C tests clean
ifeq ($(VTE),yes)
	make -C src/vte clean
endif
ifeq ($(GNOMEDB),yes)
	make -C gnomedb clean
endif
ifeq ($(GTK_EXTRA),yes)
	make -C gtkextra clean
endif
ifeq ($(CURL),yes)
	make -C curl-hb clean
endif
ifeq ($(SQLITE),yes)
	make -C src/sqlite3 clean
endif
ifeq ($(MYSQL),yes)
	make -C src/mysql clean
endif
ifeq ($(DOLPHIN),yes)
	make -C tdolphin clean
endif
ifeq ($(POSTGRE),yes)
	make -C src/pgsql clean
endif


install: all
	make -C src/gclass install
	make -C hbgtk install
#	make -C hbgtk/lang install
ifeq ($(VTE),yes)
	make -C src/vte install
endif
ifeq ($(GNOMEDB),yes)
	make -C gnomedb install
endif
ifeq ($(GTK_EXTRA),yes)
	make -C gtkextra install
endif
ifeq ($(CURL),yes)
	make -C curl-hb install
endif
ifeq ($(SQLITE),yes)
	make -C src/sqlite3 install
endif
ifeq ($(MYSQL),yes)
	make -C src/mysql install
endif
ifeq ($(DOLPHIN),yes)
	make -C tdolphin install
endif
ifeq ($(POSTGRE),yes)
	make -C src/pgsql install
endif

.PHONY: clean install

