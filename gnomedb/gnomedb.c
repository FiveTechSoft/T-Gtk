/* $Id: gnomedb.c,v 1.2 2009-01-20 01:27:41 riztan Exp $*/
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
    (c)2008 Rafael Carmona <rafa.tgtk at gmail.com>
*/
#include <hbapi.h>

#ifdef _GNOMEDB_
#include <libgnomedb/libgnomedb.h>


// -------------------------------------------------------------------------------
// Initialization of the libgnomedb library
// -------------------------------------------------------------------------------
HB_FUNC( GNOME_DB_INIT ) 
{
  const gchar *app_id  = hb_parc( 1 ) ;
  const gchar *version = hb_parc( 2 ) ;
  gnome_db_init( app_id, version,0, NULL );
}

/* Not necessary 
   gnome_db_main_run ()
   gnome_db_main_quit ()
*/

/*
************************************************************
  Datasources and connection related widgets
************************************************************
[OK]GnomeDbLoginDialog — Login dialog widget
TODO:
[START] GnomeDbLogin — Login widget

GnomeDbProviderSelector — A combo box style widget to select a provider
GnomeDbDataSourceSelector — A combo box style widget to select a data source
GnomeDbDsnSpec — a form to enter information required to open a connection
GnomeDbDsnEditor — A form to modify datasource information
GnomeDbDsnAssistant — an assistant to create a new datasource
GnomeDbConnectionProperties — Shows the properties of a GdaConnection object
GnomeDbServerOperation — Allow to set the contents of a GdaServerOperation object
GnomeDbTransastionStatus — Displays the transaction status of a connection
*/

// -------------------------------------------------------------------------------
// GnomeDbLoginDialog — Login dialog widget
// -------------------------------------------------------------------------------
// GtkWidget*          gnome_db_login_dialog_new           (const gchar *title);
HB_FUNC( GNOME_DB_LOGIN_DIALOG_NEW )
{
   GtkWidget * login;
   const gchar *title =  hb_parc(1);
   login = gnome_db_login_dialog_new( title );

   hb_retnl( (glong) login );
}

//gboolean            gnome_db_login_dialog_run           (GnomeDbLoginDialog *dialog);
HB_FUNC( GNOME_DB_LOGIN_DIALOG_RUN )
{
   GnomeDbLoginDialog *dialog = GNOME_DB_LOGIN_DIALOG( hb_parnl( 1 ) );
   hb_retl( gnome_db_login_dialog_run( dialog ) );
}

//const gchar*        gnome_db_login_dialog_get_dsn       (GnomeDbLoginDialog *dialog);
HB_FUNC( GNOME_DB_LOGIN_DIALOG_GET_DSN )
{
   GnomeDbLoginDialog *dialog = GNOME_DB_LOGIN_DIALOG( hb_parnl( 1 ) );
   hb_retc( ( const gchar * )gnome_db_login_dialog_get_dsn( dialog ) );
}


// const gchar*        gnome_db_login_dialog_get_username  (GnomeDbLoginDialog *dialog);
HB_FUNC( GNOME_DB_LOGIN_DIALOG_GET_USERNAME )
{
   GnomeDbLoginDialog *dialog = GNOME_DB_LOGIN_DIALOG( hb_parnl( 1 ) );
   hb_retc( gnome_db_login_dialog_get_username( dialog ) );
}


//const gchar*        gnome_db_login_dialog_get_password  (GnomeDbLoginDialog *dialog);
HB_FUNC( GNOME_DB_LOGIN_DIALOG_GET_PASSWORD )
{
   GnomeDbLoginDialog *dialog = GNOME_DB_LOGIN_DIALOG( hb_parnl( 1 ) );
   hb_retc( gnome_db_login_dialog_get_password( dialog ) );
}

//GnomeDbLogin*       gnome_db_login_dialog_get_login_widget (GnomeDbLoginDialog *dialog);
HB_FUNC( GNOME_DB_LOGIN_DIALOG_GET_LOGIN_WIDGET )
{
   GnomeDbLogin * login;
   GnomeDbLoginDialog *dialog = GNOME_DB_LOGIN_DIALOG( hb_parnl( 1 ) );
   login = gnome_db_login_dialog_get_login_widget( dialog );

   hb_retnl( (glong) login );
}
// -------------------------------------------------------------------------------
// GnomeDbLogin — Login widget
// -------------------------------------------------------------------------------
/*
GtkWidget*          gnome_db_login_new                  (const gchar *dsn);
const gchar*        gnome_db_login_get_dsn              (GnomeDbLogin *login);
void                gnome_db_login_set_dsn              (GnomeDbLogin *login,
                                                         const gchar *dsn);
const gchar*        gnome_db_login_get_username         (GnomeDbLogin *login);
void                gnome_db_login_set_username         (GnomeDbLogin *login,
                                                         const gchar *username);
const gchar*        gnome_db_login_get_password         (GnomeDbLogin *login);
void                gnome_db_login_set_password         (GnomeDbLogin *login,
                                                         const gchar *password);
void                gnome_db_login_set_enable_create_button
                                                        (GnomeDbLogin *login,
                                                         gboolean enable);
gboolean            gnome_db_login_get_enable_create_button
                                                        (GnomeDbLogin *login);
void                gnome_db_login_set_show_dsn_selector
                                                        (GnomeDbLogin *login,
                                                         gboolean show);
gboolean            gnome_db_login_get_show_dsn_selector
                                                        (GnomeDbLogin *login);
*/

// GtkWidget*          gnome_db_grid_new                   (GdaDataModel *model);
HB_FUNC( GNOME_DB_GRID_NEW )
{
 GtkWidget * grid;
 GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
 grid = gnome_db_grid_new( model );
 hb_retnl( (glong) grid );
}

#endif
