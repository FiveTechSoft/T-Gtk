/* $Id: msgbox.c,v 1.2 2008-10-16 14:55:00 riztan Exp $*/
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
#include <gtk/gtk.h>
#include "hbapi.h"
#include "t-gtk.h"

#define GTK_MSGBOX_OK        1
#define GTK_MSGBOX_CANCEL    2
#define GTK_MSGBOX_CLOSE     4
#define GTK_MSGBOX_ABORT     8
#define GTK_MSGBOX_RETRY     16
#define GTK_MSGBOX_YES       32
#define GTK_MSGBOX_NO        64

#define _(s) gettext(s)


HB_FUNC( MSGBOX ) // cText, iButtons, iBoxType , cTitle
{
   GtkWidget *gbox;

   GtkWidget *wParent = get_win_parent();

   gchar * msg   = ( gchar * ) hb_parc( 1 );
   gchar * title = ( gchar * ) hb_parc( 4 );
   gint iButtons = hb_parni( 2 );
   gint iBoxtype = hb_parni( 3 );
   gint iResponse;
   
   if( iBoxtype == 0 )
   {
      iBoxtype = GTK_MESSAGE_INFO;
   }

   gbox = gtk_message_dialog_new( GTK_WINDOW( wParent ),
                                  GTK_DIALOG_DESTROY_WITH_PARENT,
                                  iBoxtype,
                                  GTK_BUTTONS_NONE, "%s", msg );
   
   gtk_window_set_type_hint( GTK_WINDOW( gbox ), GDK_WINDOW_TYPE_HINT_MENU );
   
   if( title );
      gtk_window_set_title( GTK_WINDOW( gbox ), title );

   if( iButtons == 0 )
   {
      iButtons = GTK_MSGBOX_OK;
   }

   if ( (iButtons & GTK_MSGBOX_OK) == GTK_MSGBOX_OK )
   {
      gtk_dialog_add_button( GTK_DIALOG( gbox ), GTK_STOCK_OK, GTK_MSGBOX_OK );
   }

   if ( (iButtons & GTK_MSGBOX_YES) == GTK_MSGBOX_YES )
   {
      gtk_dialog_add_button( GTK_DIALOG( gbox ), GTK_STOCK_YES, GTK_MSGBOX_YES );
   }

   if ( (iButtons & GTK_MSGBOX_NO) == GTK_MSGBOX_NO )
   {
      gtk_dialog_add_button( GTK_DIALOG( gbox ), GTK_STOCK_NO, GTK_MSGBOX_NO );
   }

   if ( (iButtons & GTK_MSGBOX_OK) == GTK_MSGBOX_ABORT )
   {
      gtk_dialog_add_button( GTK_DIALOG( gbox ), "Abort", GTK_MSGBOX_ABORT );
   }

   if ( (iButtons & GTK_MSGBOX_OK) == GTK_MSGBOX_RETRY )
   {
      gtk_dialog_add_button( GTK_DIALOG( gbox ), "Retry", GTK_MSGBOX_RETRY );
   }

   if ( (iButtons & GTK_MSGBOX_CLOSE) == GTK_MSGBOX_CLOSE )
   {
      gtk_dialog_add_button( GTK_DIALOG( gbox ), GTK_STOCK_CLOSE, GTK_MSGBOX_CLOSE );
   }

   if ( (iButtons & GTK_MSGBOX_CANCEL) == GTK_MSGBOX_CANCEL )
   {
      gtk_dialog_add_button( GTK_DIALOG( gbox ), GTK_STOCK_CANCEL, GTK_MSGBOX_CANCEL );
   }

   gtk_window_set_policy( GTK_WINDOW( gbox ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( gbox ), GTK_WIN_POS_CENTER );

   iResponse = gtk_dialog_run( GTK_DIALOG( gbox ) );
   hb_retni( iResponse == GTK_RESPONSE_NONE ? GTK_MSGBOX_CANCEL : iResponse );
   gtk_widget_destroy( gbox );
}
