#
# Utilidad de t-gtk para Descargar Componentes Externos
#

ifeq ($(HB_MAKE_PLAT),win)

#EXECUTE :=cmd /C start /WAIT $(TGTK_DIR)\pkg_install\miscelan_bin\wget
EXECUTE :=$(TGTK_DIR)\pkg_install\miscelan_bin\wget

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
    $(shell $(EXECUTE) $(GLIB_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(GLIB_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando PkgConfig. )
    $(shell $(EXECUTE) $(PKGCONFIG_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando GDK+PixBuf. )
    $(shell $(EXECUTE) $(GDK_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(GDK_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando Pango. )
    $(shell $(EXECUTE) $(PANGO_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(PANGO_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando FreeType-2. )
    $(shell $(EXECUTE) $(FTYPE_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(FTYPE_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando FontConfig. )
    $(shell $(EXECUTE) $(FONT_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(FONT_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando LibPNG. )
    $(shell $(EXECUTE) $(PNG_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(PNG_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando Cairo. )
    $(shell $(EXECUTE) $(CAIRO_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(CAIRO_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando ATK. )
    $(shell $(EXECUTE) $(ATK_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(ATK_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando GTK+. )
#    $(shell $(EXECUTE) $(GTK22_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(GTK+_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(GTK+_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando LibXML-2. )
    $(shell $(EXECUTE) $(XML_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(XML_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando LibXML2-2. )
    $(shell $(EXECUTE) $(XML2_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(XML2_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(info )
    $(info Descargando Glade. )
    $(shell $(EXECUTE) $(LIBGLADE_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(LIBGLADE_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(GLADE_BIN_LNK) -c -nd -P $(DIR_DOWN))

    $(info )
    $(info Descargando ZLib. )
    $(shell $(EXECUTE) $(ZLIB_DEV_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(ZLIB_BIN_LNK) -c -nd -P $(DIR_DOWN))

    $(info )
    $(info Descargando GetText. )
    $(shell $(EXECUTE) $(GETTEXT_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(GETTEXT_DEV_LNK) -c -nd -P $(DIR_DOWN))

ifeq ($(GTKSOURCEVIEW),yes)
    $(info )
    $(info Descargando GTK SourceView. )
    $(shell $(EXECUTE) $(SRCVIEW_BIN_LNK) -c -nd -P $(DIR_DOWN))
    $(shell $(EXECUTE) $(SRCVIEW_DEV_LNK) -c -nd -P $(DIR_DOWN))
endif

    $(info )
    $(info Descargando OpenSSL. )
    $(shell $(EXECUTE) $(OPENSSL_INST_LNK) -c -nd -P $(DIR_DOWN))

ifeq ($(CURL),yes)
    $(info )
    $(info Descargando LibCURL. )
    $(shell $(EXECUTE) $(LIBCURL_INST_LNK) -c -nd -P $(DIR_DOWN))
endif

    export TGTK_DOWN :=no
    $(shell echo yes > $(TGTK_DIR)\config\downloaded.log)
  endif

endif

#/eof

