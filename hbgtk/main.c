/* $Id: main.c,v 1.2 2010-05-26 10:16:44 xthefull Exp $*/
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

// Punto de entrada a GTK+/Gnome para [x]Harbour


#include <gtk/gtk.h>
//#include <gnome.h>
#include "hbapi.h"
#include "hbvm.h"

#ifdef HAVEBONOBO
  #include <libbonobo.h>
  #include <libbonoboui.h>
#endif

int _CRT_glob = 0;

int main( int argc, char * argv[] )
{

#ifdef _GTK_THREAD_
   if( ! g_thread_supported() )
         g_thread_init( NULL );

   gdk_threads_init();
   gdk_threads_enter();
   g_print("activado soporte multitarea.. \n");
#endif
#if GTK_MAJOR_VERSION < 3
   gtk_set_locale();
#endif
   if( gtk_init_check( &argc, &argv ) )
   {
      /* gnome_init( "T-Gtk","0.1",argc, argv); --> Entrada a gnome desactivada
      #ifdef HAVEBONOBO
         CORBA_ORB orb;
         orb = bonobo_activation_init( argc, argv );
         if (bonobo_init( &argc, argv ) == FALSE) {
            g_error("No se pudo inicializar Bonobo\n");
         }
         bonobo_activate();
         g_warning( "Activate BONOBO" );
      #endif
       */

      hb_cmdargInit( argc, argv );
      hb_vmInit( TRUE );
      hb_vmQuit();
      return 0; // Esta linea NUNCA se ejecutara.
   }
   else
   {
      fprintf( stderr, "%s\n", "No a sido posible inicializar GTK+" );
   }

   return 1;
}

char ** __crt0_glob_function( char * _arg )
{
   /* This function disables command line wildcard expansion. */
   HB_SYMBOL_UNUSED( _arg );

   return 0;
}
