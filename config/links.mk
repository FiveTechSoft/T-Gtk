#
# Variables de enlaces web con herramientas necesarias.
#

ifeq ($(HB_MAKE_PLAT),win)

$(info )
$(info Ejecutando config/links.mk)

# WGET for Windows
#export WGET_BIN_LNK :=http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip
export WGET_BIN_LNK :=http://users.ugent.be/~bpuype/cgi-bin/fetch.pl?dl=wget/wget.exe
# WGet - Dependencias
export WGET_DEP_LNK :=http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip

# gZip (GNU Zip) for Windows
export 7Z_LNK :=http://downloads.sourceforge.net/sevenzip/7z920.msi

# Verificamos o intentamos obtener...
ifeq ($(shell $(TGTK_DIR)\pkg_install\miscelan_bin\wget --version),)
  ifeq ($(notdir $(wildcard $(TGTK_BIN)/wget.exe)),)
    $(info ------------ )
    $(info * ATENCION * )
    $(info ------------ )
    $(info * No existe wget en $(TGTK_BIN) )
    $(info )
    $(info * Intentando obtenerlo desde:      )
    $(info * $(WGET_BIN_LNK) )
    $(info )
    #$(info * Igualmente la dependencia correspondiente:)
    #$(info * $(WGET_DEP_LNK) )
    $(info )
    $(shell cmd /C start $(WGET_BIN_LNK))
    #$(shell cmd /C start $(WGET_DEP_LNK))
    $(info Presione una tecla para continuar... )
    $(shell pause)
  endif
endif


###############
# Dependencias
###############

# glib for Windows
GLIB_BIN_FILE :=glib_2.28.1-1_win32
export GLIB_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/glib/2.28/$(GLIB_BIN_FILE).zip

GLIB_DEV_FILE :=glib-dev_2.28.1-1_win32
export GLIB_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/glib/2.28/$(GLIB_DEV_FILE).zip


# pkg-config for Windows
PKGCONFIG_BIN_FILE :=pkg-config_0.23-3_win32
export PKGCONFIG_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/pkg-config_0.23-3_win32.zip

# GDK-PixBuf for Windows
GDK_DEV_FILE :=gdk-pixbuf-dev_2.22.1-1_win32
export GDK_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/gdk-pixbuf/2.22/$(GDK_DEV_FILE).zip

GDK_BIN_FILE :=gdk-pixbuf_2.22.1-1_win32
export GDK_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/gdk-pixbuf/2.22/$(GDK_BIN_FILE).zip

# Pango for Windows
PANGO_BIN_FILE :=pango_1.28.3-1_win32
export PANGO_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/pango/1.28/$(PANGO_BIN_FILE).zip

PANGO_DEV_FILE :=pango-dev_1.28.3-1_win32
export PANGO_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/pango/1.28/$(PANGO_DEV_FILE).zip

# FreeType for Windows
FTYPE_DEV_FILE :=freetype-dev_2.4.4-1_win32
export FTYPE_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(FTYPE_DEV_FILE).zip

FTYPE_BIN_FILE :=freetype_2.4.4-1_win32
export FTYPE_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(FTYPE_BIN_FILE).zip

# FontConfig for Windows
FONT_DEV_FILE :=fontconfig-dev_2.8.0-2_win32
export FONT_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(FONT_DEV_FILE).zip

FONT_BIN_FILE :=fontconfig_2.8.0-2_win32
export FONT_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(FONT_BIN_FILE).zip

# LibPNG
PNG_DEV_FILE :=libpng-dev_1.4.3-1_win32
export PNG_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(PNG_DEV_FILE).zip

PNG_BIN_FILE :=libpng_1.4.3-1_win32
export PNG_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(PNG_BIN_FILE).zip

# Cairo for Windows
CAIRO_DEV_FILE :=cairo-dev_1.10.2-1_win32
export CAIRO_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(CAIRO_DEV_FILE).zip

CAIRO_BIN_FILE :=cairo_1.10.2-1_win32
export CAIRO_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(CAIRO_BIN_FILE).zip

# ATK for Windows
ATK_DEV_FILE :=atk-dev_1.32.0-1_win32
export ATK_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/atk/1.32/$(ATK_DEV_FILE).zip

ATK_BIN_FILE :=atk_1.32.0-1_win32
export ATK_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/atk/1.32/$(ATK_BIN_FILE).zip

# GTK+-2.22 for Windows con Dependencias
GTK22_BIN_FILE :=gtk+-bundle_2.22.1-20101227_win32
export GTK22_BIN_LNK :=http://ftp.gnome.org/pub/gnome/binaries/win32/gtk+/2.22/$(GTK22_BIN_FILE).zip

# GTK+-2.24 for Windows
GTK+_DEV_FILE :=gtk+-dev_2.24.0-1_win32
export GTK+_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/gtk+/2.24/$(GTK+_DEV_FILE).zip

GTK+_FILE :=gtk+_2.24.0-1_win32
export GTK+_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/gtk+/2.24/$(GTK+_FILE).zip

# LibXML-2 for Windows
XML_DEV_FILE :=libxml2-dev-2.6.27
export XML_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/old/$(XML_DEV_FILE).zip

XML_BIN_FILE :=libxml2-2.6.27
export XML_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/old/$(XML_BIN_FILE).zip

# LibXML2-2 for Windows
XML2_DEV_FILE :=libxml2-dev_2.7.7-1_win32
export XML2_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(XML2_DEV_FILE).zip

XML2_BIN_FILE :=libxml2_2.7.7-1_win32
export XML2_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(XML2_BIN_FILE).zip


# Glade for Windows
LIBGLADE_DEV_FILE :=libglade-dev_2.6.4-1_win32
export LIBGLADE_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/libglade/2.6/$(LIBGLADE_DEV_FILE).zip

LIBGLADE_BIN_FILE :=libglade_2.6.4-1_win32
export LIBGLADE_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/libglade/2.6/$(LIBGLADE_BIN_FILE).zip

GLADE_BIN_FILE :=glade3-3.6.4-installer
export GLADE_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/glade3/3.6/$(GLADE_BIN_FILE).exe

# ZLIB Win32
ZLIB_DEV_FILE :=zlib-dev_1.2.5-2_win32
export ZLIB_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(ZLIB_DEV_FILE).zip

ZLIB_BIN_FILE :=zlib_1.2.5-2_win32
export ZLIB_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(ZLIB_BIN_FILE).zip

# GetText Win32
GETTEXT_BIN_FILE :=gettext-runtime_0.18.1.1-2_win32
export GETTEXT_BIN_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(GETTEXT_BIN_FILE).zip

GETTEXT_DEV_FILE :=gettext-runtime-dev_0.18.1.1-2_win32
export GETTEXT_DEV_LNK :=http://ftp.gnome.org/pub/GNOME/binaries/win32/dependencies/$(GETTEXT_DEV_FILE).zip

# GtkSourceView Win32
SRCVIEW_BIN_FILE :=gtksourceview-2.10.0
export SRCVIEW_BIN_LNK :=http://ftp.gnome.org/pub/gnome/binaries/win32/gtksourceview/2.10/$(SRCVIEW_BIN_FILE).zip

SRCVIEW_DEV_FILE :=gtksourceview-dev-2.10.0
export SRCVIEW_DEV_LNK :=http://ftp.gnome.org/pub/gnome/binaries/win32/gtksourceview/2.10/$(SRCVIEW_DEV_FILE).zip

#OpenSSL for Windows
OPENSSL_INST_FILE=Win32OpenSSL_Light-1_0_0d.exe
OPENSSL_INST_LNK=http://www.slproweb.com/download/$(OPENSSL_INST_FILE)

#LibCURL for Windows
LIBCURL_INST_FILE=curl-7.22.0-devel-mingw32
LIBCURL_INST_LNK=http://www.gknw.net/mirror/curl/win32/$(LIBCURL_INST_FILE).zip

endif
#/eof
