#include "hbapi.h"
#include "hbapiitm.h"

#ifdef _WEBKIT_
#include <gtk/gtk.h>
#include <webkit/webkit.h>

HB_FUNC( WEBKIT_WEB_VIEW )
{
 hb_retptr( hb_parptr( 1 ) );
}

HB_FUNC( WEBKIT_WEB_VIEW_NEW )
{
   GtkWidget * webkit= webkit_web_view_new();
   hb_retptr( ( GtkWidget * ) webkit );
}

HB_FUNC( WEBKIT_WEB_VIEW_OPEN )
{
   webkit_web_view_open( WEBKIT_WEB_VIEW ( hb_parptr( 1 ) ), hb_parc( 2 ) );
}

/*
Para la version 1.1
void                webkit_web_view_load_uri            (WebKitWebView *web_view,
                                                         const gchar *uri);

HB_FUNC( WEBKIT_WEB_VIEW_LOAD_URI )
{

   webkit_web_view_load_uri( WEBKIT_WEB_VIEW ( hb_parnl( 1 ) ), hb_parc( 2 ) );
}
*/
#endif
