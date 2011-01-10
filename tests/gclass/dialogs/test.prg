/*
 * $Id: test.prg,v 1.1 2006-09-21 09:46:26 xthefull Exp $
 * Ejemplo de Dialogos
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

#define _CODIGO_  1
#define _NOMBRE_  2
#define _ACTIVO_  3
#define _CLASE_   4
#define _EXIT_    5

static aVars, aControls 

function main()

   local oDlg, cResource, oFixed
   
   aControls := array( 5 )
   aVars := array( 5 )
  
    LoadVars( aVars )

   SET RESOURCES cResource FROM FILE "test.glade"
  
   DEFINE DIALOG oDlg ID "test" RESOURCE cResource TITLE "Testing glade dialog class"
   
    DEFINE FIXED oFixed ID "fixed" RESOURCE cResource
    DEFINE ENTRY    aControls[_CODIGO_] VAR aVars[_CODIGO_] ID "entry1" RESOURCE cResource
    DEFINE ENTRY    aControls[_NOMBRE_] VAR aVars[_NOMBRE_] ID "entry2" RESOURCE cResource
    DEFINE COMBOBOX aControls[_CLASE_ ] VAR aVars[_CLASE_ ] ITEMS aVars ID "combox" RESOURCE cResource
    DEFINE CHECKBOX aControls[_ACTIVO_] VAR aVars[_ACTIVO_] ID "check" RESOURCE cResource
    
    DEFINE BUTTON   aControls[_EXIT_] ID "btnexit" RESOURCE cResource ACTION oDlg:End()
 
 // Boton que se añade fuera de la definicion de *.glade //        
    ADD DIALOG oDlg BUTTON "New button" ACTION MsgInfo("Hola mundo :)","HOLA") 
  
 
   ACTIVATE DIALOG oDlg ;
            VALID ( MsgInfo("Salimos"), .t. ) ;
            ON_YES MsgStop( "" )  ;
            ON_OK oDlg:End()

return .t.

static func LoadVars( aVars )

   aVars[_CODIGO_] := "ISBN123456"
   aVars[_NOMBRE_] := "En un lugar de la mancha, de cuyo nombre..."
   aVars[_ACTIVO_] := .t.
   aVars[_CLASE_ ] := "Variable contenida en combobox"
   aVars[_EXIT_  ] := "Opcion limitada a la salida del programa"
   
return .t.



