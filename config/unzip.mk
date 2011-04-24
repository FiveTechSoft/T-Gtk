#
# Descompresion de Componentes Externos.
#

ifeq ($(HB_MAKE_PLAT),win)
ifeq ($(TGTK_UNZIP),yes)

$(info )
$(info Ejecutando config/unzip.mk)

# Verificamos la existencia del 7z.exe
 EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat \
	 $(TGTK_DIR)

 $(info * Verificando existencia de descompresor )
 #$(info $(EXECUTE) $(TGTK_BIN)\bin)
 $(shell $(EXECUTE) $(TGTK_BIN)\bin\7z.exe)
 ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
   $(info --------------- )
   $(info *  ATENCION   * )
   $(info --------------- )
   $(info No es posible localizar 7z.exe )
   $(info Necesario para descomprimir los paquetes descargados. )
   $(info ---------------------- )
   ifeq ($(AUTO_INST),yes)
      $(shell cmd /C start http://downloads.sourceforge.net/sevenzip/7z920.msi)
   endif
   $(info Debera realizar la extraccion manualmente y colocar los archivos )
   $(info en $(TGTK_BIN). )
   $(info --------------- )
   export TGTK_UNZIP :=no
 endif


ifneq ($(notdir $(wildcard $(DIR_DOWN)/*)),)

  ifeq ($(findstring yes,$(shell type $(TGTK_DIR)\config\unziped.log)),yes)
    TGTK_UNZIP :=no
    $(info * Actividad ya realizada.. )
  endif

  EXECUTE :=cmd /C start 7z x -y -o

  ifeq ($(TGTK_UNZIP),yes)
    $(info Descomprimiendo gLib for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(GLIB_BIN_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(GLIB_DEV_FILE).zip )

    $(info Descomprimiendo Pkg-Config for Windows ... )
    #$(info $(EXECUTE)$(DIR_DOWN) $(DIR_DOWN)\$(PKGCONFIG_BIN_FILE).tar.gz)
    #$(shell $(EXECUTE)$(DIR_DOWN) $(DIR_DOWN)\$(PKGCONFIG_BIN_FILE).tar.gz )
    #$(info $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(PKGCONFIG_BIN_FILE).zip)
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(PKGCONFIG_BIN_FILE).zip )

    $(info Descomprimiendo GDK-PixBuf for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(GDK_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(GDK_BIN_FILE).zip )

    $(info Descomprimiendo Pango for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(PANGO_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(PANGO_BIN_FILE).zip )

    $(info Descomprimiendo FreeType for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(FTYPE_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(FTYPE_BIN_FILE).zip )

    $(info Descomprimiendo FontConfig for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(FONT_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(FONT_BIN_FILE).zip )

    $(info Descomprimiendo LibPNG for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(PNG_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(PNG_BIN_FILE).zip )

    $(info Descomprimiendo Cairo for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(CAIRO_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(CAIRO_BIN_FILE).zip )

    $(info Descomprimiendo ATK for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(ATK_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(ATK_BIN_FILE).zip )

    $(info Descomprimiendo GTK+ Runtime for Windows ... )
#    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(GTK22_BIN_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(GTK+_FILE).zip )

    $(info Descomprimiendo GTK+ Development for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(GTK+_DEV_FILE).zip )

    $(info Descomprimiendo LibXML-2 for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(XML_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(XML_BIN_FILE).zip )

    $(info Descomprimiendo Glade for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(LIBGLADE_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(LIBGLADE_BIN_FILE).zip )
    #$(shell $(DIR_DOWN)\$(GLADE_BIN_FILE).exe )

    $(info Descomprimiendo ZLIB for Windows ... )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(ZLIB_DEV_FILE).zip )
    $(shell $(EXECUTE)$(TGTK_BIN) $(DIR_DOWN)\$(ZLIB_BIN_FILE).zip )

    export TGTK_UNZIP :=no
    $(shell echo yes > $(TGTK_DIR)\config\unziped.log)
  endif

   
else
   $(info * ------------------------------------ )
   $(info * No hay archivos para descomprimir...)
   $(info * ------------------------------------ )
endif



endif
endif

#/eof
