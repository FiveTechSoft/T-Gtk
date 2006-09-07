/* $Id: gdlgfile.prg,v 1.1 2006-09-07 17:02:43 xthefull Exp $*/
/*
    LGPL Licence.
    
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
*/

/*
  Prototipo de la clase gDlgFile

  Explicacion por si parece un poco complicado de entender.
  Como podemos observar, en el dialogo de seleccion de archivos, tenemos
  los botones de Ok y cancelar.
  Nosotros necesitamos conectar las señales de "clicked" para los botones,
  pero tenemos que gestionarlos desde esta clase, no desde la clase de los
  botones.
  La solucion es bien sencilla:
       ::Connect( "clicked" , "OnClickedBtnOk", ::oBtn_Ok:pWidget )
  y NO oBtn:Connect!!!
  ¿ Porque de eso ?

  Por que en el METHOD OnClickedBtnOk(), el parametro oSender sera el
  objeto de la clase gDlgFile!!! de lo contrario , nos devolveria
  el objeto de la clase Button, que realmente no nos sirve para nada ;-)

  Y tambien debemos de tener en cuenta, que entramos en otro bucle
  de procesos, Gtk_Main(), para 'parar' , y esperar para obtener el
  nombre seleccionado.

  Toda esta complicacion se salva llamando simplemente a la funcion:
  ChooseFile()

  Ya se que es un pelin dificil de entender, pero si lo explico aqui,
  seguro que no tendre que volver a pensarlo otra vez ;-)


*/
#INCLUDE "gclass.ch"
#include "hbclass.ch"

CLASS GDLGFILE FROM GDIALOG
      DATA oBtn_Ok      // Los botones se trataran como objetos
      DATA oBtn_Cancel
      DATA cFileName

      METHOD New( cTitle )
      METHOD SetFile( cFileDefault ) INLINE gtk_file_selection_set_filename( ::pWidget, cFileDefault )
      METHOD SetComplete( pattern )  INLINE gtk_file_selection_complete( ::pWidget, pattern )

      METHOD OnClickedBtnOk( oSender )
      METHOD OnClickedBtnCancel( oSender )
      METHOD OnDestroy( oSender )

END CLASS

METHOD New( cTitle, cFileDefault, cPattern, lNoModal, cId, uGlade ) CLASS GDLGFILE

       DEFAULT cTitle := "Seleccione archivo",;
               lNoModal := .F.

       ::cFileName := ""

       ::pWidget := gtk_file_selection_new( cTitle )

       IF !Empty( cFileDefault )
           ::SetFile( cFileDefault )
       ENDIF
       
       ::Connect( "destroy" )

       ::oBtn_Ok     := gButton():Object_Empty()
       ::oBtn_Cancel := gButton():Object_Empty()
       ::oBtn_Ok:pWidget     := __get_pointer_btn_ok_file( ::pWidget )
       ::oBtn_Cancel:pWidget := __get_pointer_btn_cancel_file( ::pWidget )

       ::Connect( "clicked" , "OnClickedBtnOk", ::oBtn_Ok:pWidget )
       ::Connect( "clicked" , "OnClickedBtnCancel", ::oBtn_Cancel:pWidget )
       ::Connect( "destroy" , , ::oBtn_Ok:pWidget )
       ::Connect( "destroy" , , ::oBtn_Cancel:pWidget )

       ::Show()

       IF cPattern != NIL
          ::SetComplete( cPattern )
       ENDIF

        if !lNoModal
          ::Modal( TRUE )
       endif

       // Entramos en un nuevo bucle de mensajes, para poder devolver el nombre
       // en un momento dado.
       Gtk_Main()

RETURN Self

METHOD OnClickedBtnOk( oSender ) CLASS GDLGFILE
       oSender:cFileName := gtk_file_selection_get_filename( oSender:pWidget )
       oSender:End()
RETURN .F.

METHOD OnClickedBtnCancel( oSender ) CLASS GDLGFILE
       oSender:cFileName := ""
       oSender:End()
RETURN .F.

METHOD OnDestroy( oSender ) CLASS GDLGFILE
       gtk_main_quit()
RETURN .F.

// Devuelve fichero seleccionado...s
// cTitle := Titulo del dialogo
// cFileDefault := Directorio o fichero por defecto.
// cPattern := Ficheros que podemos filtrar, por ejemplo "*.zip"
Function ChooseFile( cTitle, cFileDefault, cPattern )
         Local oFile := gDlgFile():New( cTitle , cFileDefault, cPattern )
RETURN oFile:cFileName

