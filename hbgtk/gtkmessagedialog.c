/* $Id: gtkmessagedialog.c,v 1.4 2008-10-07 17:07:54 riztan Exp $*/
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
 *  - MsgYesNo()  // Ser¡a lo mismo que MsgNoYes() cambiando el foco del
 */               // boton y devolviendo lo contrario

#include <gtk/gtk.h>
#include "hbapi.h"

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


HB_FUNC( GTK_MESSAGE_DIALOG_NEW ) // cText, msgtype, buttons -> dialog
{
   GtkWidget *dialog;
   //gchar *msg = g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );
   gchar *msg   = hb_parc( 1 );
   gint msgtype = hb_parni( 2 );
   gint buttons = hb_parni( 3 );

   dialog = gtk_message_dialog_new( NULL, GTK_DIALOG_MODAL,
                                    msgtype, buttons, msg );


   hb_retni( (ULONG) dialog );
}

/*
 * Funciones de creacion de mensajes para compatibilidad FiveWin
 */

void msgbox( gint msgtype, gchar *message, gchar *title, gboolean lmarkup )
{
   GtkWidget *dialog;
//   g_convert( message, -1,"UTF-8","ISO-8859-1", NULL,NULL,NULL );
   
   dialog  = gtk_message_dialog_new( NULL, GTK_DIALOG_MODAL,
                                     msgtype, GTK_BUTTONS_OK, message );

//   g_convert( title, -1,"UTF-8","ISO-8859-1", NULL,NULL,NULL );

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


HB_FUNC( MSG_INFO ) // cMessage, cTitle, lmarkup -> 0
{
   gchar * message, * title;
   gboolean lmarkup;

   if( ISNIL( 3 ) )
      lmarkup = TRUE;
   else
      lmarkup = !hb_parl( 3 ) ;

   if( ISNIL( 1 ) )
       message = "";
   else
       message = ( gchar * ) hb_parc( 1 );
   
   if( ISNIL( 2 ) )
       title = "Info";
   else
       title = ( gchar * ) hb_parc( 2 );
           
   msgbox( GTK_MESSAGE_INFO, message, title, lmarkup );
   hb_retni( 0 ); // Si devuelvo nada, Harbour devuelve por nosotros NIL
}                 // pero a mi me gusta devolver 0, al estilo que todo va bien


HB_FUNC( MSG_STOP ) // cMessage, cTitle, lMarkup -> 0
{
   gchar * message, * title;
   gboolean lmarkup;

   if( ISNIL( 1 ) )
       message = "";
   else
       message = ( gchar * ) hb_parc( 1 );
   
   if( ISNIL( 2 ) )
       title = "Stop";
   else
       title = ( gchar * ) hb_parc( 2 );
       
   if( ISNIL( 3 ) )
      lmarkup = TRUE;
   else
      lmarkup = !hb_parl( 3 ) ;

   msgbox( GTK_MESSAGE_ERROR, message, title, lmarkup );
   hb_retni( 0 );
}

/* 03-10-2005 Funcion Alert()
 * Reescrita para utilizar con errorsys de la RTL de [x]Harbour
 * y ser compatible con la GUI de T-Gtk.
 * Para mostrar mensajes de usuario, utilizar MsgAlert()
 */
HB_FUNC( ALERT ) // cMessage, aButtons -> nOption
{
   PHB_ITEM buttons;
   GtkWidget *dialog, *label;
   gchar *message;
   gint result;
   
   if( ISNIL( 1 ) )
       message = "";
   else
       message = ( gchar * ) hb_parc( 1 );
  
   label = gtk_label_new (message);
   gtk_widget_show (label);

   if( ISNIL( 2 ) )
       dialog = gtk_dialog_new_with_buttons (message, NULL, GTK_DIALOG_MODAL,
                                             GTK_STOCK_QUIT, GTK_ALERT_QUIT, NULL);
   else
       if( ISARRAY( 2 ) )
           buttons = hb_param( 2, HB_IT_ARRAY );
           if( hb_arrayLen(buttons) > 2 )
               dialog = gtk_dialog_new_with_buttons ("T-Gtk error system", NULL, 
                                                     GTK_DIALOG_MODAL,
                                                     GTK_STOCK_REFRESH, GTK_ALERT_RETRY, 
                                                     GTK_STOCK_CANCEL, GTK_ALERT_DEFAULT,
                                                     GTK_STOCK_QUIT, GTK_ALERT_QUIT, NULL);
           else
               dialog = gtk_dialog_new_with_buttons ("T-Gtk error system", NULL, 
                                                     GTK_DIALOG_MODAL,
                                                     GTK_STOCK_REFRESH, GTK_ALERT_RETRY, 
                                                     GTK_STOCK_QUIT, GTK_ALERT_QUIT, NULL);

   gtk_container_set_border_width( GTK_CONTAINER (GTK_DIALOG (dialog)->vbox), 20 );
   gtk_widget_set_usize( dialog, 350, 150 );
   gtk_container_add( GTK_CONTAINER (GTK_DIALOG (dialog)->vbox), label );

   result = gtk_dialog_run( GTK_DIALOG (dialog) );
   gtk_widget_destroy( dialog );

   hb_retni( result );
}

HB_FUNC( MSG_ALERT ) // cMessage, cTitle, lMarkup -> 0
{
   gchar * message, * title;
   gboolean lmarkup = hb_parl( 3 );

   if( ISNIL( 1 ) )
       message = "";
   else
       message = ( gchar * ) hb_parc( 1 );
   
   if( ISNIL( 2 ) )
       title = "Alert";
   else
       title = ( gchar * ) hb_parc( 2 );
   msgbox( GTK_MESSAGE_WARNING, message, title, lmarkup );
   hb_retni( 0 );
}

HB_FUNC( MSG_NOYES ) // cMessage, cTitle, lResponse, lMarkup, cIconFile -> logical
{
   GtkWidget *dialog;
   gchar    *msg      = hb_parc( 1 );
   gchar    *title    = hb_parc( 2 );
   gboolean lresponse = hb_parl( 3 );
   gboolean lmarkup;
   gchar    *icon_file= hb_parc( 5 );


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


   dialog = gtk_message_dialog_new( NULL, GTK_DIALOG_MODAL,
                                    GTK_MESSAGE_QUESTION,
                                    GTK_BUTTONS_YES_NO, msg );
   
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
   
   hb_retl( ( response == GTK_RESPONSE_YES) );
}


HB_FUNC( MSG_OKCANCEL ) // cMessage, cTitle, lResponse, lMarkup, cIconFile -> logical
{
   GtkWidget *dialog;
   gchar    *msg       = hb_parc( 1 );
   gchar    *title     = hb_parc( 2 );
   gboolean lresponse  = hb_parl( 3 );
   gboolean lmarkup;
   gchar    *icon_file = hb_parc( 5 );

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


   dialog = gtk_message_dialog_new( NULL, GTK_DIALOG_MODAL,
                                    GTK_MESSAGE_QUESTION,
                                    GTK_BUTTONS_OK_CANCEL, msg );

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
   
   hb_retl( ( response == GTK_RESPONSE_OK) );
}
