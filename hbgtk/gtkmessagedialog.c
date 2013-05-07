/* $Id: gtkmessagedialog.c,v 1.7 2010-12-24 22:43:15 dgarciagil Exp $*/
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
    (c)2003 Joaquim Ferrer <quim_ferrer@yahoo.es>
*/
/*
 * GtkMessageDialog. ---------------------------------------------------------
 * Porting Harbour to GTK+ power ! 
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 *
 * Funciones GTK implementadas :
 *  + gtk_message_dialog_new()
 *
 * Funcion para compatibilidad con errorsys de [x]Harbour
 *  + Alert() 
 *
 *  + MsgInfo()
 *  + MsgStop()
 *  + MsgAlert()
 *  + MsgNoYes()
 *  TODO:
 *  - MsgAbout()
 *  - MsgBeep())
 *  - MsgGet()  
 *  - MsgLogo() 
 *  - MsgMeter()
 *  - MsgRun()  
 *  - MsgYesNo()  // Ser�a lo mismo que MsgNoYes() cambiando el foco del
 */               // boton y devolviendo lo contrario

#include <gtk/gtk.h>
#include <hbapi.h>
#include <hbapiitm.h>
#include <hbdate.h>
#include <hbset.h>
#include <hbvm.h>
#ifndef __HARBOUR__
  #include <hbapicls.h>
#endif
#include "t-gtk.h"

/* Iconos en message_dialog() */
#define GTK_MESSAGE_INFO         0
#define GTK_MESSAGE_WARNING      1
#define GTK_MESSAGE_QUESTION     2
#define GTK_MESSAGE_ERROR        3

/* Botones en message_dialog() */
#define GTK_BUTTONS_NONE         0
#define GTK_BUTTONS_OK           1
#define GTK_BUTTONS_CLOSE        2
#define GTK_BUTTONS_CANCEL       3
#define GTK_BUTTONS_YES_NO       4
#define GTK_BUTTONS_OK_CANCEL    5

/* Codigos de respuesta de Alert() */
#define GTK_ALERT_QUIT           1
#define GTK_ALERT_RETRY          0
#define GTK_ALERT_DEFAULT        3

/* Codigos de respuesta de message_dialog() */
#define GTK_MSGBOX_CLOSE        -4
#define GTK_MSGBOX_OK           -5
#define GTK_MSGBOX_CANCEL       -6
#define GTK_MSGBOX_ABORT        -7
#define GTK_MSGBOX_YES          -8
#define GTK_MSGBOX_NO           -9

void ValToChar( PHB_ITEM item )
{

 //          hb_retc( "nil" );

   switch( hb_itemType( item ) )
   {
      case HB_IT_NIL:
           hb_retc( "nil" );
           break;

      case HB_IT_STRING:
           hb_retc( hb_itemGetC( item ) );
           break;

      case HB_IT_INTEGER:
      	   {
      	      char lng[ 15 ];
              sprintf( lng, "%d", hb_itemGetNI( item ) );
              hb_retc( lng );
           }   
           break;

      case HB_IT_LONG:
      	   {
              char dbl[ HB_MAX_DOUBLE_LENGTH ];
              sprintf( dbl, "%f", ( double ) hb_itemGetND( item ) );
              * strchr( dbl, '.' ) = 0;
              hb_retc( dbl );
           }   
           break;

      case HB_IT_DOUBLE:
           {
              char dbl[ HB_MAX_DOUBLE_LENGTH ];
              sprintf( dbl, "%f", hb_itemGetND( item ) );
              hb_retc( dbl );
           }
           break;

      case HB_IT_DATE:
           {
              hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFindName( "DTOC" ) ) );	
              hb_vmPushNil();
              hb_vmPush( item );
              hb_vmDo( 1 );  
           }
           break;

      case HB_IT_LOGICAL:
           hb_retc( hb_itemGetL( item ) ? ".T." : ".F."  );
           break;

      case HB_IT_ARRAY:
           if( hb_objGetClass( item ) == 0 )
              hb_retc( "Array" );
           else
              hb_retc( "Object" );
           break;
           
      case HB_IT_HASH:
         hb_retc( "Hash" );
         break;

      case HB_IT_BLOCK:
         hb_retc( "Block" );         
         break;

      default:
           hb_retc( "ValtoChar not suported type yet" );
  }
}



HB_FUNC( GTK_MESSAGE_DIALOG_NEW ) // cText, msgtype, buttons, parent -> dialog
{
   GtkWidget *dialog;
   //gchar *msg = g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );
   gchar *msg   = str2utf8( ( gchar *) hb_parc( 1 ) );
   gint msgtype = hb_parni( 2 );
   gint buttons = hb_parni( 3 );
   gchar *wParent;

   if ( ISNIL( 4 ) )
      dialog = gtk_message_dialog_new( NULL, GTK_DIALOG_MODAL, msgtype, buttons, "%s", msg );
   else{
      wParent = str2utf8( ( gchar * ) hb_parc( 4 ) );
      dialog = gtk_message_dialog_new( GTK_WINDOW(wParent), GTK_DIALOG_MODAL, msgtype, buttons, "%s", msg );
      SAFE_RELEASE( wParent ); 
    }

   
   
   SAFE_RELEASE( msg );
   
   hb_retptr( ( GtkWidget * ) dialog );
}

/*
 * Funciones de creacion de mensajes para compatibilidad FiveWin
 */

void msgbox( gint msgtype, gchar *message, gchar *title, gboolean lmarkup )
{
   GtkWidget *dialog;
   GtkWidget *wParent = get_win_parent();

//   g_convert( message, -1,"UTF-8","ISO-8859-1", NULL,NULL,NULL );

   dialog  = gtk_message_dialog_new( GTK_WINDOW( wParent ), GTK_DIALOG_MODAL, msgtype, GTK_BUTTONS_OK, "%s", message );

//   g_convert( title, -1,"UTF-8","ISO-8859-1", NULL,NULL,NULL );

   gtk_window_set_modal( GTK_WINDOW( dialog ), TRUE );
   gtk_window_set_policy( GTK_WINDOW( dialog ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( dialog ), GTK_WIN_POS_CENTER );
   gtk_window_set_title( GTK_WINDOW( dialog ), title );
   gtk_window_set_type_hint( GTK_WINDOW( dialog ), GDK_WINDOW_TYPE_HINT_MENU );

   if ( lmarkup ){
      gtk_message_dialog_set_markup (GTK_MESSAGE_DIALOG (dialog), message );
   }

   switch ( msgtype )
   {
      case  GTK_MESSAGE_ERROR:
         gtk_window_set_icon_name (GTK_WINDOW (dialog), "gtk-stop");
         break;

      default:
         gtk_window_set_icon_name (GTK_WINDOW (dialog), "gtk-info");
         break;
   }


   gtk_dialog_run( GTK_DIALOG( dialog ) );
   gtk_widget_destroy( dialog );
}
/*
HB_FUNC( GTK_WINDOW_GET_TRANSIENT_FOR  ) // cMessage, cTitle, lmarkup -> 0
{
   GtkWidget *dialog;

   gchar * widget;

   gtk_window_get_transient_for ( GTK_WINDOW( widget ) );

   hb_retni( (ULONG) dialog );
  
}
*/

HB_FUNC( MSG_INFO ) // cMessage, cTitle, lmarkup -> 0
{
   gchar * message, * title;
   gboolean lmarkup;

   if( ISNIL( 3 ) )
      lmarkup = TRUE;
   else
      lmarkup = !hb_parl( 3 ) ;

   if( ISNIL( 1 ) )
       message = str2utf8( "" );
   else
   {
      if( ! ISCHAR( 1 ) ){
         ValToChar( hb_param( 1, -1 ) ); 
         message = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         message = str2utf8( ( gchar * ) hb_parc( 1 ) );
   }
   
   if( ISNIL( 2 ) )
       title = str2utf8( "Info" );
   else {
      if( ! ISCHAR( 2 ) ){
         ValToChar( hb_param( 2, -1 ) ); 
         title = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         title = str2utf8( ( gchar * ) hb_parc( 2 ) );
   }
           
   msgbox( GTK_MESSAGE_INFO, message, title, lmarkup );
   hb_retni( 0 ); // Si devuelvo nada, Harbour devuelve por nosotros NIL
                  // pero a mi me gusta devolver 0, al estilo que todo va bien
                  
                     
   SAFE_RELEASE( title );
   SAFE_RELEASE( message );                     
}

HB_FUNC( MSG_STOP ) // cMessage, cTitle, lMarkup -> 0
{
   gchar * message, * title;
   gboolean lmarkup;

   if( ISNIL( 1 ) )
       message = str2utf8( "" );
   else
   {
      if( ! ISCHAR( 1 ) ){
         ValToChar( hb_param( 1, -1 ) ); 
         message = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         message = str2utf8( ( gchar * ) hb_parc( 1 ) );
   }
   
   if( ISNIL( 2 ) )
       title = str2utf8( "Info" );
   else {
      if( ! ISCHAR( 2 ) ){
         ValToChar( hb_param( 2, -1 ) ); 
         title = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         title = str2utf8( ( gchar * ) hb_parc( 2 ) );
   }
      
   if( ISNIL( 3 ) )
      lmarkup = TRUE;
   else
      lmarkup = !hb_parl( 3 ) ;

   msgbox( GTK_MESSAGE_ERROR, message, title, lmarkup );

   SAFE_RELEASE( title );
   SAFE_RELEASE( message );         
   hb_retni( 0 );
}

/* 03-10-2005 Funcion Alert()
 * Reescrita para utilizar con errorsys de la RTL de [x]Harbour
 * y ser compatible con la GUI de T-Gtk.
 * Para mostrar mensajes de usuario, utilizar MsgAlert()
 */
HB_FUNC( GTK_ALERT ) // cMessage, aButtons -> nOption
{
   PHB_ITEM buttons;
   GtkWidget *dialog, *label;
   GtkWidget *wParent = get_win_parent();
   gchar *message;
   gint result;
   
   if( ISNIL( 1 ) )
       message = str2utf8( "" );
   else
   {
      if( ! ISCHAR( 1 ) ){
         ValToChar( hb_param( 1, -1 ) ); 
         message = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         message = str2utf8( ( gchar * ) hb_parc( 1 ) );
   }
   

   label = gtk_label_new (message);
   gtk_widget_show (label);

   if( ISNIL( 2 ) )
       dialog = gtk_dialog_new_with_buttons (message, GTK_WINDOW( wParent ), GTK_DIALOG_MODAL,
                                             GTK_STOCK_QUIT, GTK_ALERT_QUIT, NULL);
   else
       if( ISARRAY( 2 ) )
           buttons = hb_param( 2, HB_IT_ARRAY );
           if( hb_arrayLen(buttons) > 2 )
               dialog = gtk_dialog_new_with_buttons ("T-Gtk error system", GTK_WINDOW( wParent ), 
                                                     GTK_DIALOG_MODAL,
                                                     GTK_STOCK_REFRESH, GTK_ALERT_RETRY, 
                                                     GTK_STOCK_CANCEL, GTK_ALERT_DEFAULT,
                                                     GTK_STOCK_QUIT, GTK_ALERT_QUIT, NULL);
           else
               dialog = gtk_dialog_new_with_buttons ("T-Gtk error system", GTK_WINDOW( wParent ), 
                                                     GTK_DIALOG_MODAL,
                                                     GTK_STOCK_REFRESH, GTK_ALERT_RETRY, 
                                                     GTK_STOCK_QUIT, GTK_ALERT_QUIT, NULL);

   #if GTK_MAJOR_VERSION < 3
       gtk_container_set_border_width( GTK_CONTAINER (GTK_DIALOG (dialog)->vbox), 20 );
       gtk_widget_set_usize( dialog, 350, 150 );
       gtk_container_add( GTK_CONTAINER (GTK_DIALOG (dialog)->vbox), label );
   #else
       // TODO: Esto esta para repasar, seguramente cascará, pero necesitamos seguir compilando
       gtk_widget_set_usize( dialog, 350, 150 );
       gtk_container_add( GTK_CONTAINER (GTK_DIALOG (dialog)), label );
   #endif    

   result = gtk_dialog_run( GTK_DIALOG (dialog) );
   gtk_widget_destroy( dialog );

   SAFE_RELEASE( message );

   hb_retni( result );
}

HB_FUNC( MSG_ALERT ) // cMessage, cTitle, lMarkup -> 0
{
   gchar * message, * title;
   gboolean lmarkup = hb_parl( 3 );

   if( ISNIL( 1 ) )
       message = str2utf8( "" );
   else
   {
      if( ! ISCHAR( 1 ) ){
         ValToChar( hb_param( 1, -1 ) ); 
         message = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         message = str2utf8( ( gchar * ) hb_parc( 1 ) );
   }
   
   if( ISNIL( 2 ) )
       title = str2utf8( "Info" );
   else {
      if( ! ISCHAR( 2 ) ){
         ValToChar( hb_param( 2, -1 ) ); 
         title = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         title = str2utf8( ( gchar * ) hb_parc( 2 ) );
   }
   
   msgbox( GTK_MESSAGE_WARNING, message, title, lmarkup );
   
   SAFE_RELEASE( message );
   SAFE_RELEASE( title );
   
   hb_retni( 0 );
}

HB_FUNC( MSG_NOYES ) // cMessage, cTitle, lResponse, lMarkup, cIconFile -> logical
{
   GtkWidget *dialog;
   GtkWidget *wParent = get_win_parent();
   gchar     *msg      ;
   gchar     *title    ;
   gboolean  lresponse = hb_parl( 3 );
   gboolean  lmarkup;
   gchar     *icon_file= ( gchar *) hb_parc( 5 );

   if( ISNIL( 1 ) )
       msg = str2utf8( "" );
   else
   {
      if( ! ISCHAR( 1 ) ){
         ValToChar( hb_param( 1, -1 ) ); 
         msg = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         msg = str2utf8( ( gchar * ) hb_parc( 1 ) );
   }
   
   if( ISNIL( 2 ) )
       title = str2utf8( "Info" );
   else {
      if( ! ISCHAR( 2 ) ){
         ValToChar( hb_param( 2, -1 ) ); 
         title = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         title = str2utf8( ( gchar * ) hb_parc( 2 ) );
   }

  /* 
   gchar *msg   = g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",
                             NULL,NULL,NULL );
   gchar *title = g_convert( hb_parc(2), -1,"UTF-8","ISO-8859-1",
                             NULL,NULL,NULL );
   */
   gint response;

   if( ISNIL( 4 ) )
      lmarkup = TRUE;
   else
      lmarkup = !hb_parl( 4 ) ;


   dialog = gtk_message_dialog_new( GTK_WINDOW( wParent ) , GTK_DIALOG_MODAL,
                                    GTK_MESSAGE_QUESTION,
                                    GTK_BUTTONS_YES_NO, "%s", msg );
   
   gtk_window_set_title( GTK_WINDOW( dialog ), title );
   gtk_window_set_position( GTK_WINDOW( dialog ), GTK_WIN_POS_CENTER );
   gtk_window_set_type_hint( GTK_WINDOW( dialog ), GDK_WINDOW_TYPE_HINT_MENU );

   if( ISNIL( 5 ) )
      gtk_window_set_icon_name (GTK_WINDOW (dialog), "gtk-dialog-question");
   else
      gtk_window_set_icon_from_file ( GTK_WINDOW( dialog ), icon_file , NULL );


   if ( lmarkup ){
      gtk_message_dialog_set_markup( GTK_MESSAGE_DIALOG( dialog ) , msg );  // Habilitando soporte de lenguaje de marcas
   }

   if ( lresponse ) {
      gtk_dialog_set_default_response( GTK_DIALOG( dialog ), GTK_MSGBOX_YES );
   }

   response  = gtk_dialog_run( GTK_DIALOG( dialog ) );
   gtk_widget_destroy( dialog );
   
   SAFE_RELEASE( msg );
   SAFE_RELEASE( title );
   
   hb_retl( ( response == GTK_RESPONSE_YES) );
   
   
}


HB_FUNC( MSG_OKCANCEL ) // cMessage, cTitle, lResponse, lMarkup, cIconFile -> logical
{
   GtkWidget *dialog;
   GtkWidget *wParent = get_win_parent();
   gchar     *msg;
   gchar     *title;
   gboolean  lresponse  = hb_parl( 3 );
   gboolean  lmarkup;
   gchar     *icon_file = ( gchar * ) hb_parc( 5 );


   if( ISNIL( 1 ) )
       msg = str2utf8( "" );
   else
   {
      if( ! ISCHAR( 1 ) ){
         ValToChar( hb_param( 1, -1 ) ); 
         msg = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         msg = str2utf8( ( gchar * ) hb_parc( 1 ) );
   }
   
   if( ISNIL( 2 ) )
       title = str2utf8( "Info" );
   else {
      if( ! ISCHAR( 2 ) ){
         ValToChar( hb_param( 2, -1 ) ); 
         title = str2utf8( ( gchar * ) hb_parc( -1 ) );
      }else
         title = str2utf8( ( gchar * ) hb_parc( 2 ) );
   }

  /* 
   gchar *msg   = g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",
                             NULL,NULL,NULL );
   gchar *title = g_convert( hb_parc(2), -1,"UTF-8","ISO-8859-1",
                             NULL,NULL,NULL );
   */
   gint response;

   if( ISNIL( 4 ) )
      lmarkup = TRUE;
   else
      lmarkup = !hb_parl( 4 ) ;


   dialog = gtk_message_dialog_new( GTK_WINDOW( wParent ), GTK_DIALOG_MODAL,
                                    GTK_MESSAGE_QUESTION,
                                    GTK_BUTTONS_OK_CANCEL, "%s", msg );

   if ( lresponse )
      gtk_dialog_set_default_response (GTK_DIALOG( dialog ), GTK_RESPONSE_OK);
   

   if( ISNIL( 5 ) )
      gtk_window_set_icon_name (GTK_WINDOW (dialog), "gtk-info");
   else
      gtk_window_set_icon_from_file ( GTK_WINDOW( dialog ), icon_file , NULL );
   
   
   gtk_window_set_title( GTK_WINDOW( dialog ), title );
   gtk_window_set_position( GTK_WINDOW( dialog ), GTK_WIN_POS_CENTER );
   gtk_window_set_type_hint( GTK_WINDOW( dialog ), GDK_WINDOW_TYPE_HINT_MENU );

   if ( lmarkup ){
      gtk_message_dialog_set_markup( GTK_MESSAGE_DIALOG( dialog ) , msg );  // Habilitando soporte de lenguaje de marcas
   }

//   gtk_dialog_set_response_sensitive( GTK_MESSAGE_DIALOG( dialog ) , GTK_RESPONSE_OK , TRUE );	


   response  = gtk_dialog_run( GTK_DIALOG( dialog ) );
   gtk_widget_destroy( dialog );
 
   SAFE_RELEASE( msg );
   SAFE_RELEASE( title );
   
   
   hb_retl( ( response == GTK_RESPONSE_OK) );
}
