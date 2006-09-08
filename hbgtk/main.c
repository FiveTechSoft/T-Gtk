/* $Id: main.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

int _CRT_glob = 0;

int main( int argc, char * argv[] )
{

   gtk_set_locale();

   if( gtk_init_check( &argc, &argv ) )
   {
      // gnome_init( "T-Gtk","0.1",argc, argv); --> Entrada a gnome desactivada
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
