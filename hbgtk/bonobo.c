#include "hbapi.h"
#include "hbapiitm.h"

#ifdef _HAVEBONOBO_

#include <libbonobo.h>
#include <libbonoboui.h>

HB_FUNC( BONOBO_INIT )
{
    CORBA_ORB orb;
    
    orb = bonobo_activation_init( 0, NULL );
    if (bonobo_init( 0, NULL ) == FALSE) {
        g_error("No se pudo inicializar Bonobo\n");
     }
    bonobo_activate();
    g_warning( "Activate BONOBO" );
}

HB_FUNC( BONOBO_WIDGET )
{
    GtkWidget * ventana =  GTK_WIDGET( hb_parptr( 1 ) );
   // const gchar* interfaces[] = { "IDL:Bonobo/Control:1.0", NULL };
  //  gchar* seleccionado = bonobo_selector_select_id("Selecciona control", interfaces);
  // if (seleccionado) {
        g_warning( "Seleccionado...\n" );
        GtkWidget* control = bonobo_widget_new_control( hb_parc( 2 ), NULL);
        gtk_container_add(GTK_CONTAINER(ventana), control);
        gtk_widget_show( control );
    //  }

}

HB_FUNC( BONOBO_MAIN_QUIT )
{
  bonobo_main_quit();
}
#endif
