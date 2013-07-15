#include <gtk/gtk.h>
#include <hbapi.h>

#ifdef _GTK2_

static BOOL lStatus = FALSE;


GtkBuilder  * _gtk_builder_new()
{
  return  gtk_builder_new();
}


HB_FUNC( GTK_BUILDER_NEW ) //fname,root,domain
{
  GtkBuilder  *pBuilder;
  pBuilder = _gtk_builder_new( );
  hb_retptr( ( GtkBuilder * ) pBuilder );
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

#endif
