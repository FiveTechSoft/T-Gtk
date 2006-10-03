#include <gtk/gtk.h>
#include "hbapi.h"

#if GTK_CHECK_VERSION(2,6,0)

HB_FUNC( GTK_ABOUT_DIALOG_NEW )
{
  GtkWidget * dialog = gtk_about_dialog_new();
  hb_retnl( (glong) dialog );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_NAME )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_name( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_NAME )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_name( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_VERSION )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_version( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_VERSION )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_version( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_COPYRIGHT )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_copyright( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_COPYRIGHT )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_copyright( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_COMMENTS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_comments( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_COMMENTS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_comments( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_LICENSE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_license( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_LICENSE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_license( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_WEBSITE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_website( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_WEBSITE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_website( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_WEBSITE_LABEL )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_website_label( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_WEBSITE_LABEL )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_website_label( dialog, szText );
}

/* TODO:
 * 
HB_FUNC( GTK_ABOUT_DIALOG_SET_ARTISTS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY ); // array
  gint iLenCols = hb_arrayLen( pArray );        // columnas
  gint iCol;                                    // contador
  const gchar *artist[ iLenCols + 1];           // array 
  const gchar *a[] = { "pepe", "hjose", NULL }; // array de tipos
  
  g_print( "\nlongitud del array %d \n", iLenCols );

  for( iCol = 0; iCol < iLenCols; iCol++ )
   {
     artist[ iCol ]  = ( const gchar * ) hb_arrayGetC( pArray, iCol + 1 );
     g_print( "%s \n",artist[ iCol ] );
   }
   artist[ iCol + 1] = NULL;
   
   g_print( "final" );
   
   //gtk_about_dialog_set_artists( dialog, a );  
   gtk_about_dialog_set_artists( dialog, artist  );

}
*/

HB_FUNC( GTK_SHOW_ABOUT_DIALOG )
{
  GtkWindow  * parent ;
  parent = ISNIL( 1 ) ? NULL : GTK_WINDOW( hb_parnl( 1 ) );
  gtk_show_about_dialog( parent, NULL );
}
#endif

