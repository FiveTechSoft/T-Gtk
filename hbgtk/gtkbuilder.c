#include <gtk/gtk.h>
#include <hbapi.h>


static BOOL lStatus = FALSE;


GtkBuilder  * _gtk_builder_new()
{
  return  gtk_builder_new();
}


HB_FUNC( GTK_BUILDER_NEW ) //fname,root,domain
{
  GtkBuilder  *pBuilder;
  if( hb_parc( 1 ) ){
     GtkBuilder * pBuilder = gtk_builder_new();
     const * filename = hb_parc( 1 );
     if( _gtk_builder_add_from_file( pBuilder, ( const gchar *) filename ) ){
        hb_retptr( pBuilder );
     } else {
       g_print( "Carga de gtkbuilder no es correcta\n");
     }

  }else{
     pBuilder = _gtk_builder_new( );
     hb_retptr( ( GtkBuilder * ) pBuilder );
  }
}


//-------------

BOOL _gtk_builder_add_from_file( GtkBuilder * pBuilder, const gchar * filename )
{
  return ( BOOL )  gtk_builder_add_from_file( pBuilder, filename, NULL );
}

HB_FUNC( GTK_BUILDER_ADD_FROM_FILE )
{
 
  GtkBuilder * pBuilder    = hb_parptr( 1 );
  const gchar *filename = ( const gchar * ) hb_parc( 2 );
  
  hb_retl( _gtk_builder_add_from_file( pBuilder, filename ) );
  
}



//-------------

HB_FUNC( GTK_BUILDER_GET_OBJECT )
{
  GObject * object;
  GtkBuilder * pBuilder = hb_parptr( 1 );
  const gchar *name = ( const gchar * ) hb_parc( 2 );
  
  object = gtk_builder_get_object (pBuilder, name);
  
  hb_retptr( object );

}


BOOL SetGtkBuilder( BOOL l )
{
  BOOL lOldStatus = lStatus;
  
  lStatus = l;
  
  return lOldStatus;
  
}

BOOL GetGtkBuilderSts()
{
  return lStatus;
}

HB_FUNC( SETGTKBUILDER )
{
   SetGtkBuilder( hb_parl( 1 ) );
}


HB_FUNC( GTK_BUILDER_NEW_FROM_FILE )
{
  const gchar * filename = ( gchar * ) hb_parc( 1 );
  GtkBuilder * builder = gtk_builder_new_from_file( filename );
  hb_retptr( ( GtkBuilder * ) builder );
}


HB_FUNC( GTK_BUILDER_NEW_FROM_RESOURCE )
{
  const gchar * resource_path = ( gchar * ) hb_parc( 1 );
  GtkBuilder * builder = gtk_builder_new_from_resource( resource_path );
  hb_retptr( ( GtkBuilder * ) builder );
}


HB_FUNC( GTK_BUILDER_NEW_FROM_STRING )
{
  const gchar * string = ( gchar * ) hb_parc( 1 );
  gssize length = (gsize) hb_parni( 2 );
  GtkBuilder * builder = gtk_builder_new_from_string( string, length );
  hb_retptr( ( GtkBuilder * ) builder );
}


HB_FUNC( GTK_BUILDER_CONNECT_SIGNALS )
{
  GtkBuilder * builder = (GtkBuilder *) hb_parptr( 1 );
  gpointer   user_data = hb_parptr( 2 );
  gtk_builder_connect_signals( builder, user_data );
}

//eof
