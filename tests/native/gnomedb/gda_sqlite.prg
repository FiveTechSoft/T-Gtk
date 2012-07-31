/*
 * $Id: gda_sqlite.prg,v 1.1 2012-07-31 05:05:14 riztan Exp $
 * Ejemplo de uso de GNOMEDB y LIBGDA
 * Porting Harbour to GTK+ power !
 * (C) 2008. Rafa Carmona -TheFull-  <rafa.tgtk at gmail.com>
 * (C) 2012. Riztan Gutierrez <riztan at t-gtk.org>
*/

#include "gtkapi.ch"

function Main(  )
   local hWnd
   local logindlg
   local client   // GdaClient *client;
   local cnc      // GdaConnection *cnc;
   local aError   // GError *error = NULL;
   local data_model, sql, command
   local grid
   local parser


   /* create connection to database from string */
   cnc := gda_connection_open_from_string( "SQLite", "DB_Dir=.;DB_NAME=example_db",nil, ;
                                           GDA_CONNECTION_OPTIONS_NONE, @aError )

   if !Empty( aError )  // Miramos si existe algun tipo de error
      MsgStop( cValtoChar( aError[1] ) + aError[2] )
   else
      MsgInfo( "Conexion establecida!!", "Conectado.." )
   endif


   /* Create a command to execute some SQL */
   //sql := "SELECT * FROM emple e LIMIT 0,1000"
   //command := gda_command_new (sql, GDA_COMMAND_TYPE_SQL, GDA_COMMAND_OPTION_STOP_ON_ERRORS)

   aError := NIL
   //data_model := gda_execute_select_command ( cnc, command, NIL, @aError )

   parser := gda_connection_create_parser( cnc )

   if hb_ispointer( parser )
      g_object_set_data_full(cnc, "parser", parser)
   endif


  run_sql_non_select( cnc, "DROP table IF EXISTS products" )
  create_table( cnc, parser )
  insert_data( cnc ) 
  display_products_contents( cnc, "select * from products" )

  gda_connection_close( cnc )

/*
   if empty( data_model )
      MsgStop( "Could not execute the SQL command:" + cValtoChar( aError[1] ) + " "+ aError[2] )
      gda_connection_close( cnc )
      quit
   endif
*/

return nil

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

/* Method Activate */
   gtk_window_set_title( hWnd, "Gnome-DB [x]Harbour from T-Gtk" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 250, 250 )

   //grid = gnome_db_grid_new(data_model)
   gtk_container_add(GTK_CONTAINER (hwnd), grid)
   gtk_widget_show_all(hwnd)

   gtk_Main()
   g_object_unref (data_model)
   //gda_connection_close (cnc)

return NIL

//--------------------------------------------------------------------------//
//Salida controlada del programa.
//--------------------------------------------------------------------------//
Function Salida( widget )
gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.


function GError() ; return array( 2 ) 


/* nueva implementacion */

Procedure create_table( pCnc, parser)
   local stmt
   local cSQL
   local table

   cSQL := "CREATE table products (ref string not null primary key, "+;
                        "name string not null, price real, fecha date )" 

   stmt := gda_sql_parser_parse_string( parser, cSQL )
   table := gda_sql_table_new( stmt )

//? gda_statement_serialize( stmt )

   run_sql_non_select( pCnc, "DROP TABLE IF EXISTS products" ) 
   run_sql_non_select( pCnc, cSQL ) 
return



procedure insert_data( pCnc )
   local aData,aStruct,i,aError:=ARRAY(4),res
   local v1,v2,v3

   aStruct := { "ref", "name", "price_is_null", "price" }
   aData   := {{'1', 'chair', .f., 2},;
               {'2', 'table', .f., 5.4}}

   res := gda_connection_insert_row_into_table( pCnc, ;
                            "products", @aError,      ;
                            "ref", aData[2,1],        ;
                            "name", aData[2,2],       ;
                            "price", aData[2,4],      ;
                            "fecha", DTOC(date()) )
return



procedure display_products_contents( pCnc, sql )
   local parser, stmt, aError:=ARRAY(4), datamodel
   local cResult

   parser := g_object_get_pointer( pCnc, "parser" )

   stmt := gda_sql_parser_parse_string( parser, sql )
   datamodel := gda_connection_statement_execute_select( pCnc, stmt, nil, @aError )

   cResult :=  gda_data_model_dump_as_string( datamodel )

   QOUT(cResult)

return



function run_sql_non_select( pCnc, cSql )
   local stmt
   local nRows
   local pParser
   local remain, error := ARRAY(4)

   pParser :=  g_object_get_pointer( pCnc, "parser")

   stmt := gda_sql_parser_parse_string( pParser, cSql,@remain,@error )

   nRows := gda_connection_statement_execute_non_select( pCnc, stmt, , , @error )
return 


//EOF
