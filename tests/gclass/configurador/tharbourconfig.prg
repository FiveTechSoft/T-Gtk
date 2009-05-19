/*
 * $Id: tharbourconfig.prg,v 1.2 2009-05-19 21:32:08 xthefull Exp $
 * Clase que nos permite dotar de librerias nuevas sin tener que compilar de nuevo el
 * configurador, solamente cambiando el config.xml, obtenemos lo deseado.
 * Porting Harbour to GTK+ power !
 * (C) 2009. Rafa Carmona -TheFull-
*/
#include "gclass.ch"
#include "hbclass.ch"
#include "hbxml.ch"

CLASS THarbourConfig
      DATA cXml, oDoc, cResponse
      DATA aLibs
      METHOD New() CONSTRUCTOR
      METHOD GetLibs() INLINE ::aLibs
ENDCLASS

METHOD New( cFile ) CLASS THarbourConfig
   Local oNode, oIter, oNodeLib, cLib, cForce

   DEFAULT cFile := "config.xml"

   ::aLibs := {}
   ::cXml := memoread( cFile )
   ::oDoc := TXmlDocument():New( ::cXml )

   if ::oDoc:nStatus != HBXML_STATUS_OK
      ::lEstado := .F.
      ::cResponse := "Error While Processing File: " + AllTrim( Str( ::oDoc:nLine ) ) + " # "+;
                     "Error: " + HB_XmlErrorDesc( ::oDoc:nError ) + " # " +;
                     "Tag Error on tag: " + ::oDoc:oErrorNode:cName + " # " +;
                     "Tag Begin on line: " + AllTrim( Str( ::oDoc:oErrorNode:nBeginLine ) )

      return Self
   endif

   oNode := ::oDoc:FindFirst( "harbour" )

   if oNode != NIL
     oIter := TXmlIteratorRegex( oNode )
     oNodeLib := oIter:Find( "^lib$")   // Exactamente lib
     while oNodeLib != NIL
           cLib   :=  cValtoChar( oNodeLib:GetAttribute( "name" ) )
           cForce :=  cValtoChar( oNodeLib:GetAttribute( "force" ) )
           AADD( ::aLibs, { iif( cForce = "yes", .T., .F. ), cLib }  )
          oNodeLib := oIter:Next() // Siguiente libreria
     end while

   endif

RETURN Self
