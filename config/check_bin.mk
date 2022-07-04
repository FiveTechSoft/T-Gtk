#
# Revisa que los paquetes estan en TGTK_BIN o GTK_PATH
# Si, AUTO_INST esta seteado a yes, puede intentar descargar y descomprimir
#
ifeq ($(HB_MAKE_PLAT),win)

$(info )
$(info * Ejecutando config/check_bin.mk)

# lc -> lowercase 
lc = $(strip $(subst /,\,$(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,\
     $(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,\
     $(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,\
     $(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,\
     $(subst Y,y,$(subst Z,z,$(subst Ñ,ñ,$1)))))))))))))))))))))))))))))

# Verificamos que la ruta GTK_PATH o TGTK_BIN estan en el PATH
$(info * Buscando GTK_PATH ($(GTK_PATH)\bin) en la Variable de Entorno PATH.)
$(info --------------------------------------------------------------- )
ifeq ($(findstring $(call lc,$(GTK_PATH)\bin),$(call lc,$(PATH))),)
  $(info ** No Encontrado valor de GTK_PATH en path.)
   $(info -------------- )
   $(info *  ATENCION  * )
   $(info -------------- )
   $(info * Es Necesario tener en el path la ruta de   )
   $(info * GTK+ "$(GTK_PATH)\bin"                     )
   $(info * Ejecute: SET PATH=%PATH%;$(GTK_PATH)\bin   )
   $(info * definida en setenv.mk                      )
   $(info * No sera posible localizar pkg-config.exe   )
   $(info * Por favor, revise variables PATH.          )
   $(info -------------- )
   $(error )
else
  $(info * Encontrada $(GTK_PATH)\bin en el path!)
endif

# Ahora Buscamos la Ruta TGTK_BIN
$(info * Buscando TGTK_BIN ($(TGTK_BIN)\bin) en la Variable de Entorno PATH.)
ifeq ($(findstring $(call lc,$(TGTK_BIN)\bin),$(call lc,$(PATH))),)
   $(info ** No Encontrado valor de TGTK_BIN en path. )
   $(info -------------- )
   $(info *  ATENCION  * )
   $(info -------------- )
   $(info * Es importante tener en la variable PATH    )
   $(info * la ruta $(TGTK_BIN) definida en setenv.mk  )
   $(info * Por favor, revise las rutas y variables.   )
   $(info -------------- )
   $(shell notepad $(TGTK_DIR)\setenv.mk )
   $(error )
else
   $(info * Encontrada $(TGTK_BIN)\bin en el path!)
endif



# Buscamos pkg-config.exe en las rutas de GTK_PATH o TGTK_BIN

EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)\config\check_bin.bat $(TGTK_DIR) 

$(info * Buscando pkg-config.exe en GTK_PATH ->$(GTK_PATH)\bin)
$(shell $(EXECUTE) $(GTK_PATH)\bin\pkg-config.exe)

$(info buscando valor $(TGTK_DIR)\config\control.log )
ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
  $(info * No encontrado... )
  
  $(info * Buscando pkg-config.exe en TGTK_BIN ->$(TGTK_BIN)\bin)
  $(shell $(EXECUTE) $(TGTK_BIN)\bin\pkg-config.exe)

  ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
    $(info No Encontrado... )

    ifeq ($(AUTO_INST),yes)
      include $(ROOT)config/links.mk
      # Descargar Paquetes Externos
      ifeq ($(TGTK_DOWN),yes)
        include $(ROOT)config/download.mk
      endif
      # Descomprime Paquetes Externos
      ifeq ($(TGTK_UNZIP),yes)
        ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\unzip.log)),yes)
           include $(ROOT)config/unzip.mk
           $(shell echo yes > $(TGTK_DIR)\config\unzip.log)
        endif
      endif
    else
      $(info -------------- )
      $(info *  ATENCION  * )
      $(info -------------- )
      $(info * Es importante disponer del programa pkg-config  )
      $(info * es posible intentar obtenerlo desde internet.  )
      $(info -------------- )
      $(info Para intentar descargar, se debe setear las variables:) 
      $(info .   SET AUTO_INST=yes )
      $(info .   SET TGTK_DOWN=yes )
      $(info $(PKG_CONFIG_PATH))
    endif

  else
     $(info * Encontrado pkg-config.exe en $(TGTK_BIN)!)
  endif
else
  $(info * Encontrado pkg-config.exe $(GTK_PATH)!)
endif



# Buscamos wget
EXECUTE :=cmd /C start /MIN /WAIT $(TGTK_DIR)/config/check_bin.bat $(TGTK_DIR) 

$(info * Buscando wget.exe en TGTK_BIN ->$(TGTK_BIN))
$(info Invocando $(TGTK_BIN)\bin\wget.exe)
#$(shell $(EXECUTE) $(TGTK_BIN)\bin\wget.exe)

ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
  $(info * No encontrado... )

  $(info * Buscando wget.exe en TGTK_DIR\pkg_install\miscelan_bin ->$(TGTK_DIR)\pkg_install\miscelan_bin)
  $(info Invocando $(TGTK_DIR)\pkg_install\miscelan_bin\wget.exe)
  $(shell $(EXECUTE) $(TGTK_DIR)\pkg_install\miscelan_bin\wget.exe)

  ifneq ($(findstring yes,$(shell type $(TGTK_DIR)\config\control.log)),yes)
    $(info No Encontrado... )

#    ifeq ($(shell wget --version ),)
#      ifeq ($(AUTO_INST),yes)
#        $(info Debe descargar y descomprimir wget en una ruta como $(TGTK_BIN) )

#        $(shell cmd /C start http://users.ugent.be/~bpuype/cgi-bin/fetch.pl?dl=wget/wget.exe)
#        $(shell cmd /C start http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip)
#        $(shell cmd /C start http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip)

#      else
##        $(info ***************************************************** )
#	$(info   Por favor, debe setear la variable AUTO_INST=yes    )
#	$(info   para intentar obtener las dependencias necesarias.  )
#        $(info ***************************************************** )
#	$(error )
#      endif
#    endif

  endif

endif


endif
#/eof
