/* $Id: gdialog.prg,v 1.5 2010-12-24 01:06:17 dgarciagil Exp $*/
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
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GDialog FROM GWINDOW
      DATA bYes, bNo, bOk, bCancel, bClose, bApply, bHelp
      DATA aResponse 
      DATA nId INIT 0
      DATA nCount  INIT 0
      DATA lglade INIT .F.

      METHOD New( cTitle, nWidth, nHeight, cId, cGlade, oWnd, cIconName, cIconFile, oParent )
      METHOD Activate(  )
      METHOD AddButton( cText, nResponse, bAction )
      METHOD Separator( lShow )   INLINE gtk_dialog_set_has_separator( ::pWidget, lShow )
      METHOD SetIconName( cText ) INLINE gtk_window_set_icon_name ( ::pWidget, cText )
      METHOD SetIconFile( cText ) INLINE gtk_window_set_icon ( ::pWidget, cText )

      //Signals
      METHOD OnResponse( oSender, nResponse )
      METHOD OnClose( oSender ) VIRTUAL

ENDCLASS

METHOD NEW( cTitle, nWidth, nHeight, cId, uGlade, nType_Hint, ;
            cIconName, cIconFile, oParent ) CLASS GDIALOG

       if cId == NIL
          ::pWidget := gtk_dialog_new( )
       else
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
          // connect_destroy_widget( ::pWidget ) // Conectarmos seal de destroy automaticamente
          ::lGlade := .T.
       endif

       if cTitle != NIL
          ::cTitle( cTitle )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif
       
       if nType_Hint != NIL
          ::SetTypeHint( nType_Hint )
       endif

       if cIconName = NIL
          if cIconFile = NIL
             ::SetIconName( GTK_STOCK_PREFERENCES )
          else
             ::SetIconFile( cIconFile )
          endif
       else
          ::SetIconName( cIconName )
       endif

       if oParent != NIL
          gtk_window_set_transient_for( ::pWidget, oParent:pWidget )  
       endif
        
       ::Connect( "response" )
       ::Connect( "delete-event" )
       ::Connect( "destroy" )
       ::Connect( "key-press-event" )

       ::aResponse := {}
       ::nCount++

RETURN Self

METHOD Activate(  bYes, bNo, bOk, bCancel, bClose, bApply, bHelp, bEnd, lCenter,;
                 lResizable , lNoModal, lNoSeparator, lRun ) CLASS GDIALOG

       DEFAULT lNoModal := .F.,;
               lCenter := .T.,;
               lResizable := .F.,;
               lRun := .F. 

       if bEnd != NIL
          ::bEnd := bEnd
       endif

       if lNoSeparator
          ::Separator( .F. )
       endif

       if !Empty( bYes )
          ::bYes := bYes
          if !::lGlade
              gtk_dialog_add_button( ::pWidget, GTK_STOCK_YES, GTK_RESPONSE_YES )
          endif
       endif

       if !Empty( bNo )
          ::bNo := bNo
          if !::lGlade
             gtk_dialog_add_button( ::pWidget, GTK_STOCK_NO, GTK_RESPONSE_NO )
          endif
       endif

       if !Empty( bOk )
          ::bOk := bOk
          if !::lGlade
             gtk_dialog_add_button( ::pWidget, GTK_STOCK_OK, GTK_RESPONSE_OK )
          endif
       endif

       if !Empty( bCancel )
          ::bCancel := bCancel
          if !::lGlade
             gtk_dialog_add_button( ::pWidget, GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL )
          endif
       endif

       if !Empty( bClose )
          ::bClose := bClose
          if !::lGlade
              gtk_dialog_add_button( ::pWidget, GTK_STOCK_CLOSE, GTK_RESPONSE_CLOSE )
          endif
       endif

       if !Empty( bApply )
          ::bApply := bApply
          if !::lGlade
             gtk_dialog_add_button( ::pWidget, GTK_STOCK_APPLY, GTK_RESPONSE_APPLY )
          endif
       endif

       if !Empty( bHelp )
          ::bHelp := bHelp
          if !::lGlade
             gtk_dialog_add_button( ::pWidget, GTK_STOCK_HELP, GTK_RESPONSE_HELP )
          endif
       endif

       // Si se declara por glade, esto es Ignorado por glade.
       if !::lGlade
          if lCenter
             ::Center()
          endif
          if !lResizable
             ::SetResizable( .F. )
          endif
          if !lNoModal 
             ::Modal( .T. )
          endif
       endif

       ::Show()

       /* Atencion, no es buena idea HACER un dialogo como ventana PRINCIPAL */
       IF !::lInitiate
          ::lInitiate := .T.
          ::ldestroy_Gtk_Main := .T.
          Gtk_Main()                
       ELSE
          IF lRun 
             ::nId := 1
             gtk_dialog_run( ::pWidget )
          ENDIF
       ENDIF
       
RETURN NIL

METHOD OnResponse( oSender, nResponse ) CLASS GDIALOG
       Local uRes := 0

       DO CASE

        CASE nResponse == GTK_RESPONSE_NONE  
             gtk_widget_destroy( oSender:pWidget )
             return .F.

          CASE nResponse == GTK_RESPONSE_OK
               if !Empty( oSender:bOk )
                  Eval( oSender:bOk, oSender )
               endif
        
          CASE nResponse == GTK_RESPONSE_CANCEL
               if !Empty( oSender:bCancel )
                  Eval( oSender:bCancel, oSender )
               endif

          CASE nResponse == GTK_RESPONSE_CLOSE
               if !Empty( oSender:bClose )
                   Eval( oSender:bClose, oSender )
               endif

          CASE nResponse == GTK_RESPONSE_YES
               if !Empty( oSender:bYes )
                  Eval( oSender:bYes, oSender)
               endif

          CASE nResponse == GTK_RESPONSE_NO
               if !Empty( oSender:bNo )
                  Eval( oSender:bNo, oSender )
               endif

          CASE nResponse == GTK_RESPONSE_APPLY
               if !Empty( oSender:bApply )
                  Eval( oSender:bApply, oSender )
               endif

          CASE nResponse == GTK_RESPONSE_HELP
               if !Empty( oSender:bHelp )
                  Eval( oSender:bHelp, oSender )
               endif

          OTHERWISE
               uRes := AScan( oSender:aResponse, { | aElem | aElem[1] == nResponse } )
               if uRes != 0
                  Eval( oSender:aResponse[ uRes, 2] )
               endif
       ENDCASE
       
       IF nResponse != 0
          oSender:nId := nResponse
          if ! Empty( oSender:pWidget )
             gtk_widget_destroy( oSender:pWidget )
          endif
       ENDIF

RETURN .F.

METHOD AddButton( cText, bAction ) CLASS GDIALOG

       gtk_dialog_add_button( ::pWidget, cText, ::nCount )
       AADD( ::aResponse, { ::nCount, bAction } )
       ::nCount++

RETURN NIL
