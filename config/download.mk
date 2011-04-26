#
# Utilidad de t-gtk para Descargar Componentes Externos
#

ifeq ($(HB_MAKE_PLAT),win)

EXECUTE :=cmd /C start /WAIT wget

$(info )
$(info Ejecutando config/download.mk)

  ifeq ($(GTK+_BIN_LNK),)
    include $(ROOT)config/links.mk
  endif
  ifeq ($(findstring yes,$(shell type $(TGTK_DIR)\config\downloaded.log)),yes)
    $(info * La Descarga ya se realizo... )
    TGTK_DOWN :=no
  endif

  ifeq ($(TGTK_DOWN),yes)
    $(info )
    $(info Descargando GLib. )
    $(shell wget $(GLIB_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(GLIB_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando PkgConfig. )
    $(shell wget $(PKGCONFIG_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando GDK+PixBuf. )
    $(shell wget $(GDK_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(GDK_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando Pango. )
    $(shell wget $(PANGO_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(PANGO_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando FreeType-2. )
    $(shell wget $(FTYPE_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(FTYPE_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando FontConfig. )
    $(shell wget $(FONT_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(FONT_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando LibPNG. )
    $(shell wget $(PNG_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(PNG_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando Cairo. )
    $(shell wget $(CAIRO_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(CAIRO_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando ATK. )
    $(shell wget $(ATK_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(ATK_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando GTK+. )
#    $(shell wget $(GTK22_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(GTK+_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(GTK+_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando LibXML-2. )
    $(shell wget $(XML_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(XML_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando Glade. )
    $(shell wget $(LIBGLADE_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(LIBGLADE_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(GLADE_BIN_LNK) -c -nd -P $(DIR_DOWN))

    $(info )
    $(info Descargando ZLib. )
    $(shell wget $(ZLIB_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(shell wget $(ZLIB_BIN_LNK) -c -nd -P $(DIR_DOWN))

    export TGTK_DOWN :=no
    $(shell echo yes > $(TGTK_DIR)\config\downloaded.log)
  endif

endif

#/eof

