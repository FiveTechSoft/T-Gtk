/* $Id: gtkdialog.c,v 1.2 2006-11-02 12:33:06 xthefull Exp $*/
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

gint dialog_exit( GtkWidget *widget, gpointer data )
{
  gtk_widget_destroy( widget );
  return TRUE;
}

HB_FUNC( GTK_DIALOG_NEW )
{
  GtkWidget * dialog = gtk_dialog_new();
  hb_retnl( (glong) dialog );
}

HB_FUNC( GTK_DIALOG_RUN ) // nDialog -> nResponse
{
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gint response = gtk_dialog_run( GTK_DIALOG( dialog ) );
  hb_retni( (UINT) response );
}

HB_FUNC( GTK_DIALOG_ADD_BUTTON ) // dialog, label, response -> button
{
  GtkWidget * button = NULL;
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gchar * label      = (gchar *) hb_parc( 2 );
  gint response      = (gint ) hb_parnl( 3 );
  button = gtk_dialog_add_button( GTK_DIALOG(dialog), label, response );
  hb_retnl( (ULONG) button );
}

/*
GTK_DIALOG_NEW_WITH_BUTTONS()

  Esta funcion a nivel fuente de GTK utiliza una lista de parametros variable
  [ va_list() funcion definida en stdarg.h ] que al final lo que hace es
  llamar a gtk_dialog_add_button() para cada boton a crear.

  dialog = gtk_dialog_new_with_buttons( "title", NULL,
                                        GTK_DIALOG_MODAL,
                                        GTK_STOCK_OK, GTK_RESPONSE_ACCEPT,
                                        ..., ...,
                                        ..., ...,
                                        NULL );

  Harbour define sus funciones api a C como void hbfun_xx( void ) por lo que
  no es posible obtener la lista de parametros variable que se le han pasado
  a la funcion C como un tipo va_list().

  Los parametros Harbour se recuperan via estructura PHB_ITEM y pueden ser
  cualquier tipo de dato Harbour (string, array...) por lo que "simular" este
  comportamiento ser¡a a base de arrays, de este modo:

  dialog = ;
  gtk_dialog_new_with_buttons( "title", NIL, GTK_DIALOG_MODAL,;
                               { { GTK_STOCK_OK, GTK_RESPONSE_ACCEPT },
                                 { ..., ... }, {..., ... };
                               } );
  Mediante un array bi-dimensional, con el par _icono_stock, _tipo_de_repuesta.

  De todas formas, creo que es mucho mas facil simular este comportamiento
  desde C, recorriendo la lista de parametros recibidos, creando el botton
  en cada iteraccion, de forma similar a como lo hace GTK.
*/

HB_FUNC( GTK_DIALOG_NEW_WITH_BUTTONS ) // title, parent, flags, list params...
                                       // -> dialog
{
  GtkWidget *dialog = NULL;
  GtkWidget *parent = GTK_WIDGET( hb_parnl( 2 ) );
  gint iParam;
  gint ipCount = hb_pcount();
  gint flags   = (gint) hb_parni( 3 );
  gchar * stock_button;
  gint response;

  dialog = gtk_dialog_new();
  gtk_window_set_title( GTK_WINDOW( dialog ), (gchar *) hb_parc( 1 ) );

  if ( parent )
     gtk_window_set_transient_for( GTK_WINDOW(dialog), GTK_WINDOW(parent) );

  if ( flags & GTK_DIALOG_MODAL )
     gtk_window_set_modal( GTK_WINDOW(dialog), TRUE );

  if ( flags & GTK_DIALOG_DESTROY_WITH_PARENT )
     gtk_window_set_destroy_with_parent( GTK_WINDOW(dialog), TRUE );

  if ( flags & GTK_DIALOG_NO_SEPARATOR )
     gtk_dialog_set_has_separator( GTK_DIALOG(dialog), FALSE );

  for( iParam = 4; iParam <= ipCount; iParam += 2 )
     {
       stock_button = (gchar *) hb_parc(iParam);
       response     = hb_parni(iParam+1);
       gtk_dialog_add_button( GTK_DIALOG(dialog), stock_button, response );
     }
  hb_retnl( (ULONG) dialog );
}

HB_FUNC( GTK_DIALOG_RESPONSE ) // dialog, response -> void
{
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gint response      = (gint ) hb_parnl( 2 );
  gtk_dialog_response( GTK_DIALOG(dialog), response );
}

HB_FUNC( GTK_DIALOG_GET_HAS_SEPARATOR ) // dialog -> lSeparator
{
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gboolean separator = gtk_dialog_get_has_separator( GTK_DIALOG(dialog) );
  hb_retl( separator );
}

HB_FUNC( GTK_DIALOG_SET_HAS_SEPARATOR ) // dialog, lSeparator -> void
{
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gboolean separator = (gboolean ) hb_parl( 2 );
  gtk_dialog_set_has_separator( GTK_DIALOG(dialog), separator );
}

HB_FUNC( GTK_DIALOG_SET_DEFAULT_RESPONSE ) // dialog, nResponse -> void
{
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gint response      = (gint) hb_parni( 2 );
  gtk_dialog_set_default_response( GTK_DIALOG(dialog), response );
}


/*
 * Intento de funciones para convertir estos mensajes en modal
 */


HB_FUNC( GTK_GRAB_ADD ) // nDialog -> void
{
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gtk_grab_add( dialog );
}

HB_FUNC( GTK_GRAB_REMOVE ) // nDialog -> void
{
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  gtk_grab_remove( dialog );
}
