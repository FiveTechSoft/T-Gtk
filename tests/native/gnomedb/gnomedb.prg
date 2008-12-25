*
 * $Id: gnomedb.prg,v 1.1 2008-12-25 19:01:13 xthefull Exp $
 * Ejemplo de uso de GNOMEDB y LIBGDA
 * Porting Harbour to GTK+ power !
 * (C) 2008. Rafa Carmona -TheFull-
*/
#include "gtkapi.ch"
#include "gnomedb.ch"

function Main(  )

  local hWnd
  local logindlg
  Local client // GdaClient *client;
  Local cnc    // GdaConnection *cnc;
  Local aError // GError *error = NULL;
  Local data_model, sql, command
  Local grid

  /* Init GnomeDB*/
   gnome_db_init ("TestHarbour", "1.0")

   Create_DataSource()
   logindlg := login()

   /* Create a GdaClient object which is the central object which manages all connections */
   client := gda_client_new()

   /* Open the connection to the database, using the DSN,
    * username and password given by the GnomeDbLoginDialog
    */
   cnc := gda_client_open_connection (client,;
                gnome_db_login_dialog_get_dsn( logindlg ),;
                gnome_db_login_dialog_get_username( logindlg ),;
                gnome_db_login_dialog_get_password( logindlg ),;
                GDA_CONNECTION_OPTIONS_DONT_SHARE, @aError )

   if !Empty( aError )  // Miramos si existe algun tipo de error
      MsgStop( cValtoChar( aError[1] ) + aError[2] )
   else
      MsgInfo( "Conexion establecida!!", "Conectado.." )
   endif

   gtk_widget_destroy( logindlg )


   /* Create a command to execute some SQL */
   sql := "SELECT * FROM emple e LIMIT 0,1000"
   command := gda_command_new (sql, GDA_COMMAND_TYPE_SQL, GDA_COMMAND_OPTION_STOP_ON_ERRORS)

   aError := NIL
   data_model := gda_connection_execute_select_command ( cnc, command, NIL, @aError )

   if empty( data_model )
      MsgStop( "Could not execute the SQL command:" + cValtoChar( aError[1] ) + " "+ aError[2] )
      gda_connection_close( cnc )
      quit
   endif


/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

/* Method Activate */
   gtk_window_set_title( hWnd, "Gnome-DB [x]Harbour from T-Gtk" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 250, 250 )

   grid = gnome_db_grid_new(data_model)
   gtk_container_add(GTK_CONTAINER (hwnd), grid)
   gtk_widget_show_all(hwnd)

   gtk_Main()
   g_object_unref (data_model)
   gda_connection_close (cnc)

return NIL

//--------------------------------------------------------------------------//
//Salida controlada del programa.
//--------------------------------------------------------------------------//
Function Salida( widget )
gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

//--------------------------------------------------------------------------//
// Select Data Source connect.
//--------------------------------------------------------------------------//
static function Login()
Local logindlg

   logindlg = gnome_db_login_dialog_new ("T-GTK.Select the Data Source to connect to")
   if !gnome_db_login_dialog_run( logindlg )
      g_print ("Login cancelled!\n")
      quit
   endif
   
   //Show information input
   // Msginfo( gnome_db_login_dialog_get_dsn( logindlg ) )
   // Msginfo( gnome_db_login_dialog_get_username( logindlg ) )
   // Msginfo( gnome_db_login_dialog_get_password( logindlg ) )

return logindlg
//--------------------------------------------------------------------------//
/*view ~/libgda/config */
//--------------------------------------------------------------------------//
static function Create_DataSource()

gda_config_save_data_source("tgtk",;
                            "MySQL",;
                            "DATABASE=test",;
                            "description of foo",;
                            "username",;
                            "password", 0)

return nil

function GError() ; return array( 2 ) 
