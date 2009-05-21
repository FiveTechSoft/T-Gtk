/*
 * $Id: tharbourconfig.prg,v 1.3 2009-05-21 07:50:18 xthefull Exp $
 * Clase que nos permite dotar de librerias nuevas sin tener que compilar de nuevo el
 * configurador, solamente cambiando el config.xml, obtenemos lo deseado.
 * Porting Harbour to GTK+ power !
 * (C) 2009. Rafa Carmona -TheFull-
*/
#include "gclass.ch"
#include "hbclass.ch"
#include "hbxml.ch"

// Clase base para configuraciones
CLASS gConfigXml STATIC
      DATA oDoc, cXml, cResponse, cFile
      DATA cNode, cFind
      DATA lOk INIT .T.
      METHOD New() CONSTRUCTOR
ENDCLASS

METHOD New( ) CLASS gConfigXml

   ::cXml := memoread( ::cFile )
   ::oDoc := TXmlDocument():New( ::cXml )

   if ::oDoc:nStatus != HBXML_STATUS_OK
      ::lOk := .F.
      ::cResponse := "Error While Processing File: " + AllTrim( Str( ::oDoc:nLine ) ) + " # "+;
                     "Error: " + HB_XmlErrorDesc( ::oDoc:nError ) + " # " +;
                     "Tag Error on tag: " + ::oDoc:oErrorNode:cName + " # " +;
                     "Tag Begin on line: " + AllTrim( Str( ::oDoc:oErrorNode:nBeginLine ) )
      return Self
   endif


RETURN Self

// Configurador para Harbour
CLASS gConfigHarbour FROM gConfigXml
      DATA aLibs
      METHOD Create() CONSTRUCTOR
      METHOD New() CONSTRUCTOR
      METHOD GetLibs() INLINE ::aLibs
ENDCLASS

METHOD Create() CLASS gConfigHarbour
   ::aLibs   := {}
   ::cNode := "harbour"
   ::cFind   := "^lib$"
   ::cFile   := "config.xml"
RETURN Self

METHOD New( ) CLASS gConfigHarbour
   Local oNode, oIter, oNodeLib, cLib, cCheck

   ::Super:New( )

   if ::lOk
      oNode := ::oDoc:FindFirst( ::cNode )
      if oNode != NIL
         oIter := TXmlIteratorRegex( oNode )
         oNodeLib := oIter:Find( ::cFind )   // Exactamente lib
         while oNodeLib != NIL
               cLib   :=  cValtoChar( oNodeLib:GetAttribute( "name" ) )
               cCheck :=  cValtoChar( oNodeLib:GetAttribute( "check" ) )
               AADD( ::aLibs, { iif( cCheck = "yes", .T., .F. ), cLib }  )
               oNodeLib := oIter:Next() // Siguiente libreria
         end while
      endif
    endif

RETURN Self

// Configurador para librerias sistemas
CLASS gConfigGTK FROM gConfigXml
      DATA aLibs
      METHOD Create() CONSTRUCTOR
      METHOD New() CONSTRUCTOR
      METHOD GetLibs() INLINE ::aLibs
ENDCLASS

METHOD Create() CLASS gConfigGTK
   ::aLibs   := {}
   ::cNode := "gtk"
   ::cFind   := "^lib$"
   ::cFile   := "config.xml"
RETURN Self

METHOD New( ) CLASS gConfigGTK
   Local oNode, oIter, oNodeLib, cLib, cForce, cCheck
   Local lExiste := .F.

   ::Super:New( )

   if ::lOk
      oNode := ::oDoc:FindFirst( ::cNode )
      if oNode != NIL
         oIter := TXmlIteratorRegex( oNode )
         oNodeLib := oIter:Find( ::cFind )   // Exactamente lib
         while oNodeLib != NIL
               cLib   :=  cValtoChar( oNodeLib:GetAttribute( "name" ) )
               cForce :=  cValtoChar( oNodeLib:GetAttribute( "force" ) )
               cCheck :=  cValtoChar( oNodeLib:GetAttribute( "check" ) ) // Nos va a permitir seleccionarla o no
               if cforce = "yes"
                  cCheck := "yes"  // Implicitamente, si la libreria es obligatoria.
               endif
               // Vamos a intentar descubrir si la tenemos en el sistema
               if !empty( run3me( 'pkg-config --list-all | grep ^' + alltrim( cLib ) ) )
                  lExiste := .T.
                else
                  lExiste := .F.
                  cCheck := "no"
               endif

               AADD( ::aLibs, { iif( cCheck = "yes", .T., .F. ), cLib, iif( cForce = "yes", "Obligatoria", "Opcional" ), lExiste }  )

               oNodeLib := oIter:Next() // Siguiente libreria
         end while
      endif
    endif

RETURN Self
