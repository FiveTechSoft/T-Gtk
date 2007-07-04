/* $Id: gassistant.prg,v 1.2 2007-07-04 10:46:08 xthefull Exp $*/
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
    (c)2007 Rafael Carmona <thefull@wanadoo.es>
*/

#include "gtkapi.ch"
#include "hbclass.ch"

#if GTK_CHECK_VERSION( 2,10,0 )
CLASS GASSISTANT FROM GWINDOW
    DATA bCancel, bClose, bPrepare, bApply
    
    METHOD New()
    METHOD Append( oWidget, cTitle ) 
    METHOD SetComplete( oWidget, lComplete ) INLINE gtk_assistant_set_page_complete( ::pWidget, oWidget:pWidget, lComplete )
    METHOD GetCurrentPage()                  INLINE gtk_assistant_get_current_page( ::pWidget ) + 1
    METHOD SetCurrentPage( nPage_number )    INLINE gtk_assistant_set_current_page(::pWidget, nPage_Number + 1 )
    METHOD GetNumberPages()                  INLINE gtk_assistant_get_n_pages( ::pWidget )
    METHOD SetType( nType, oWidget )         INLINE gtk_assistant_set_page_type( ::pWidget, oWidget:pWidget, nType )
    METHOD GetType( oWidget )                INLINE gtk_assistant_get_page_type( ::pWidget, oWidget:pWidget )
    METHOD SetTitle( cTitle, oWidget )       INLINE gtk_assistant_set_page_title( ::pWidget, oWidget:pWidget, cTitle )
    METHOD GetTitle( oWidget ) INLINE gtk_assistant_get_page_title( ::pWidget, oWidget:pWidget )
    METHOD SetPageHeaderImage( uImage, oWidget ) 
    METHOD GetPageHeaderImage( oWidget ) INLINE gtk_assistant_get_page_header_image( ::pWidget, oWidget:pWidget )
    METHOD SetPageSideImage( uImage, oWidget )    
    METHOD GetPageSideImage( oWidget ) INLINE gtk_assistant_get_page_side_image( ::pWidget, oWidget:pWidget )
    
    METHOD AddWidget( oWidget )    INLINE gtk_assistant_add_action_widget( ::pWidget, oWidget:pWidget )
    METHOD RemoveWidget( oWidget ) INLINE gtk_assistant_remove_action_widget( ::pWidget, oWidget:pWidget )
    METHOD UpdateButtons() INLINE gtk_assistant_update_buttons_state( ::pWidget )
    METHOD GetChildWidget( nPage_Number ) INLINE gtk_assistant_get_nth_page( ::pWidget, nPage_Number - 1 )
    METHOD OnApply( oSender ) 
    METHOD OnClose( oSender ) 
    METHOD OnCancel( oSender ) 
    METHOD OnPrepare( oSender, pPage ) 

ENDCLASS

METHOD New( bCancel, bClose, bPrepare, bApply, nWidth, nHeight, cId, uGlade ) CLASS GASSISTANT
       DEFAULT ::bCancel  := bCancel ,;
               ::bClose   := bClose ,;
               ::bPrepare := bPrepare ,;
               ::bApply   := bApply

       if cId == NIL
          ::pWidget := gtk_assistant_new()
       else
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       endif
       
       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::Connect( "cancel" )
       ::Connect( "close" )
       ::Connect( "prepare" )
       ::Connect( "apply" )
       ::Connect( "delete-event" )
       ::Connect( "destroy" )

RETURN Self

METHOD Append( oWidget, nType, cTitle, uImage, uImage_Side, lComplete ) CLASS gAssistant
  Local pPixbuf

  gtk_assistant_append_page( ::pWidget, oWidget:pWidget )

  if !Empty( cTitle  )
     gtk_assistant_set_page_title( ::pWidget, oWidget:pWidget, cTitle )
  endif
  
  if !Empty( nType )
     gtk_assistant_set_page_type( ::pWidget, oWidget:pWidget, nType )
  endif
  
  ::SetPageHeaderImage( uImage, oWidget )
  ::SetPageSideImage( uImage_Side, oWidget )

  ::SetComplete( oWidget, lComplete )

RETURN NIL

METHOD SetPageHeaderImage( uImage, oWidget )  CLASS GASSISTANT
  Local pPixbuf

  if !Empty( uImage )
     if Valtype( uImage ) = "O"
        pPixbuf := uImage:GetPixbuf()
     else
        pPixbuf := gdk_pixbuf_new_from_file( uImage )
     endif
      gtk_assistant_set_page_header_image( ::pWidget, oWidget:pWidget, pPixbuf )
      g_object_unref( pPixbuf )
  endif

RETURN NIL

METHOD SetPageSideImage( uImage, oWidget )  CLASS GASSISTANT
  Local pPixbuf

  if !Empty( uImage )
     if Valtype( uImage ) = "O"
        pPixbuf := uImage:GetPixbuf()
     else
        pPixbuf := gdk_pixbuf_new_from_file( uImage )
     endif
     gtk_assistant_set_page_side_image( ::pWidget, oWidget:pWidget, pPixbuf )
     g_object_unref( pPixbuf )
  endif

RETURN NIL

            

METHOD OnApply( oSender ) CLASS GASSISTANT
   
   IF oSender:bApply != NIL
      return Eval( oSender:bApply , oSender )
   ENDIF

RETURN NIL

METHOD OnClose( oSender ) CLASS GASSISTANT
   
   IF oSender:bClose != NIL
      return Eval( oSender:bClose , oSender )
   ENDIF

RETURN NIL

METHOD OnCancel( oSender ) CLASS GASSISTANT
   
   IF oSender:bCancel != NIL
      return Eval( oSender:bCancel , oSender )
   ENDIF

RETURN NIL

METHOD OnPrepare( oSender, pPage ) CLASS GASSISTANT
   
   IF oSender:bPrepare != NIL
      return Eval( oSender:bPrepare , oSender, pPage )
   ENDIF

RETURN NIL

#else
  CLASS GASSISTANT FROM GWINDOW
        METHOD NEW( ) INLINE ( MsgStop( "Not avaliable GtkAssistant..." ), gtk_main_quit() )
  ENDCLASS
#endif
