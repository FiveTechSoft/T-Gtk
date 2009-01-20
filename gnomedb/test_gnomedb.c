/* Compilar como ;
  cc -Wall -o gnomedb test_gnomedb.c `pkg-config --cflags --libs libgnomedb-3.0`
*/

#include <libgnomedb/libgnomedb.h>

int
main (int argc, char *argv[])
{
        gnome_db_init ("LibgnomedbTest", "1.0", argc, argv);

        /* create a login dialog window to let the user select a data source (or declare a new one)
         * and specify a username and password if necessary
         */
        GtkWidget *logindlg;
        
/*Muestra como crear un datasource */
gda_config_save_data_source 
        ("foo",
         "MySQL",
         "DATABASE=test",
         "description of foo",
         "rafa",
         "password", 1);

logindlg = gnome_db_login_dialog_new ("Select the Data Source to connect to");
        if (!gnome_db_login_dialog_run (GNOME_DB_LOGIN_DIALOG(logindlg))) {
                g_print ("Login cancelled!\n");
                exit (0);
        }

        GdaClient *client;
        GdaConnection *cnc;
        GError *error = NULL;

        /* Create a GdaClient object which is the central object which manages all connections */
        client = gda_client_new();

        /* Open the connection to the database, using the DSN, 
         * username and password given by the GnomeDbLoginDialog 
         */
        cnc = gda_client_open_connection (client,
                                          gnome_db_login_dialog_get_dsn (GNOME_DB_LOGIN_DIALOG (logindlg)),
                                          gnome_db_login_dialog_get_username (GNOME_DB_LOGIN_DIALOG (logindlg)),
                                          gnome_db_login_dialog_get_password (GNOME_DB_LOGIN_DIALOG (logindlg)),
                                          GDA_CONNECTION_OPTIONS_DONT_SHARE,
                                          &error);
        if (!cnc) {
                g_print ("Could not open connection to DSN '%s' with provided username and password: %s\n",
                         gnome_db_login_dialog_get_dsn (GNOME_DB_LOGIN_DIALOG (logindlg)),
                         error && error->message ? error->message : "No detail");
                exit (1);
        }
        gtk_widget_destroy (logindlg);

        GdaDataModel *data_model;
        GtkWidget *grid;
        GdaCommand *command;
        gchar *sql;

        /* Create a command to execute some SQL */
        // sql = "SELECT * FROM customers"; // for sqlite3
        sql = "SELECT * FROM emple e LIMIT 0,1000";
        command = gda_command_new (sql, GDA_COMMAND_TYPE_SQL, GDA_COMMAND_OPTION_STOP_ON_ERRORS);

        data_model = gda_connection_execute_select_command (cnc, command, NULL, &error);
        if (!data_model) {
                g_print ("Could not execute the SQL command: %s\n",
                         error && error->message ? error->message : "No detail");
                gda_connection_close (cnc);
                exit (1);
        }

        /* Create a main window and show the data model in a grid */
        GtkWidget *window;
        window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
        gtk_signal_connect( GTK_OBJECT( window ), "destroy", GTK_SIGNAL_FUNC( gtk_main_quit ),GTK_OBJECT( window ) );

//        grid = gnome_db_grid_new (data_model);
        grid = gnome_db_form_new (data_model);

        gtk_container_add (GTK_CONTAINER (window), grid);

        gtk_widget_show_all (window);
        gtk_main();
        g_object_unref (data_model);
        gda_connection_close (cnc);

        return 0;
}
