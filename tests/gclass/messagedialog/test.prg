#include "gclass.ch"


Function Main()


//  MsgAlert en sus dos formas.  (Por defecto no activa lenguaje de marcas)

   MsgAlert("Funcion <b>MsgAlert</b> Por Defecto <b>NO Activa</b> lenguaje de Marcas" ,"MsgAlert. NO Activado Markup ")
   MsgAlert("Funcion <b>MsgAlert</b> Por Defecto <b>NO Activa</b> lenguaje de Marcas" ,"MsgAlert. Activado Markup " MARKUP )


//  MsgInfo en sus formas.       (Por defecto tiene activado lenguaje de marcas)

   MsgInfo("Funcion <b>MsgAlert</b> Por Defecto <b>Activa</b> lenguaje de Marcas" , "MsgInfo. Activado Markup (Por Defecto)" ) 
   MsgInfo("Funcion <b>MsgAlert</b> Por Defecto <b>Activa</b> lenguaje de Marcas" , "MsgInfo. Desactivado Markup" NO_MARKUP ) 


//  MsgNoYes en sus formas.      (Por defecto tiene activado lenguaje de marcas)

   MsgYesNo( "Funcion <b>MsgYesNo</b>. Opcion <b><span size='15000'>Si</span></b> por Defecto" ,"MsgYesNo. Activado Markup (Por Defecto)" )
   MsgYesNo( "Funcion <b>MsgYesNo</b>. Opcion <b>Si</b> predeterminada" ,"MsgYesNo. Desactivado Markup" NO_MARKUP )

   MsgNoYes( "Funcion <b>MsgNoYes</b>. Opcion <b><span size='15000'>No</span></b> por Defecto" ,"MsgYesNo. Activado Markup (Por Defecto)" )
   MsgNoYes( "Funcion <b>MsgNoYes</b>. Opcion <b>No</b> predeterminada" ,"MsgYesNo. Desactivado Markup" NO_MARKUP )


//  MsgOkCancel  (Por defecto tiene activado lenguaje de marcas)
   MsgOkCancel( "Funcion <b>MsgOkCancel</b>. Opcion <b>Aceptar</b> predeterminada.", "MsgOkCancel. Activado Markup (por defecto)" )
   MsgOkCancel( "Funcion <b>MsgOkCancel</b>. Opcion <b>Aceptar</b> predeterminada.", "MsgOkCancel. Desactivado Markup" NO_MARKUP)

   MsgCancelOk( "Funcion <b>MsgCancelOk</b>. Opcion <b>Cancelar</b> predeterminada.", "MsgOkCancel Activado Markup (por defecto)" )
   MsgCancelOk( "Funcion <b>MsgCancelOk</b>. Opcion <b>Cancelar</b> predeterminada.", "MsgOkCancel. Desactivado Markup" NO_MARKUP)
/* 

   MsgOkCancel( "<b>Probando</b> Ok por Defecto" )
   MsgCancelOk( "<b>Probando</b> Cancel por Defecto" )


   MsgStop( '<span foreground="blue" size="15000"><b>'+oObject:ClassName()+'</b></span>' )
*/

return

