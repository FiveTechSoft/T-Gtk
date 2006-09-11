/* $Id: testclass.prg,v 1.1 2006-09-11 16:48:16 xthefull Exp $*/
/**
 * Test de Comandos de la clase DbfGrid
 * Browse a la dbf !
 * (C) 2005 Rafa Carmona 
*/
 #include "gclass.ch"
 
 static Pixbuf1

function main()
  Local oWnd, oBrw, oLabel , oBox, Image
  Local a 
  Local aFields 

  pixbuf1 := gdk_pixbuf_new_from_file( "../../images/header.png" )

  USE ../../CUSTOMER.DBF NEW SHARED ALIAS "CUSTUM"
  aFields := array( fcount() )
  afields( aFields )

  DEFINE WINDOW oWnd TITLE "Browse Native of T-Gtk" SIZE 600,300
      
      DEFINE BOX oBox VERTICAL OF oWnd

        DEFINE BROWSE oBrw ;
            FIELDS UTF_8( Field->First ), Field->Last ;
            HEADERS "Primero","Ultimo" ;
            ALIAS "CUSTUM" ;
            COLSIZES 150,100 ;
            FONT "Tahoma Italic 10" ;
            ON CHANGE oLabel:SetText( "Registro actual:" + cValToChar( Recno() ) );
            COLORS "black", {|| MyColorFon() } ;
            OF oBox EXPAND FILL  // Fijaos Expand y Fill ;-)
           
           ADD COLUMN TO BROWSE oBrw ;
               DATA Field->Set ;
               HEADER "SET" ;
               COLORS "black", {|| MyColorFon() } ;
               TYPE COL_TYPE_RADIO ;
               SIZE 50
           
           ADD COLUMN TO BROWSE oBrw ;
               DATA Field->Street;
               HEADER "Street" ;
               HEADER_PICTURE "../../images/header.png" ;
               COLOR "red","black"  ;
               SIZE 150
           
           ADD COLUMN TO BROWSE oBrw ;
               DATA CogePicture() ;
               HEADER "Imagenes al vuelo" ;
               TYPE COL_TYPE_BITMAP ;
               COLORS "black", {|| MyColorFon() } ;
         
        DEFINE LABEL oLabel PROMPT "Registro actual:" + cValToChar( Recno() ) OF oBox

        oBrw:bKeyEvent := {|o,nkey| if( nKey == K_ENTER, MsgInfo( "HOLA" ), ) }

   ACTIVATE WINDOW oWnd CENTER
   
   // Desferenciamos pixbufs
   gdk_pixbuf_unref( pixbuf1 )

return nil

 STATIC FUNCTION MyColorFon()
    Local cColor
  
    if ( ( "CUSTUM" )->( OrdKeyNo() )%2 <> 0 )
       cColor := "gray"
    else
       cColor := "yellow"
    endif

Return cColor

/* 
   Simple, fácil y potente.
   Hemos implementado en las columnas, la posibilidad de que el picture sea
   un fichero, poniendo simplemente una cadena de texto, o , para ser mucho
   más rápido y mas eficiente ahorrando memoria, es pasarle el puntero del pixbuf
   que hemos cargado previamente.
 
   ¿ Puedes ver la diferencia ?
   Mientras que la viendo 20 filas, cargamos 10 PICTURES IGUALES! en el caso del texo,
   con el pixbuf, solamente ocupará en memoria UN PICTURE, independientemente de los
   que veamos. 
   
   Es por ello, que he implementado esa caracteristica.

 */
STATIC FUNCTION COGEPICTURE()
    Local cPicture
  
    if ( ( "CUSTUM" )->( OrdKeyNo() )%2 <> 0 )
       cPicture := pixbuf1        // Asigmos el puntero del pixbuf
    else
       cPicture := "../../images/browse.png"  // Aqui , se cargará la imagen desde el DISCO!
    endif

Return cPicture
