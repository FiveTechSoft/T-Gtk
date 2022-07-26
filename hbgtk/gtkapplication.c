/* $Id: gtkapplication.c,v 1.8 2022-07-25 23:36:21 riztan Exp $*/
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
    (c)2022 Riztan Gutierrez <riztan@gmail.com>
*/
#include <gtk/gtk.h>
#include "hbapi.h"


HB_FUNC( GTK_APPLICATION_NEW )
{
   const gchar * application_id = hb_parc( 1 );
   GApplicationFlags flags = hb_parni( 2 );
   GtkApplication * application = gtk_application_new( application_id, flags );
   hb_retptr( application );
}

/*
HB_FUNC( GTK_APPLICATION_ADD_ACCELERATOR )
{
   GtkApplication * application = hb_parptr( 1 );
   const gchar * accelerator = hb_parc( 2 );
   const gchar * action_name = hb_parc( 3 );
   GVariant * parameter = hb_parptr( 4 );
   gtk_application_add_accelerator( application, accelerator, action_name, parameter );
}
*/

HB_FUNC( GTK_APPLICATION_WINDOW )
{
   GtkApplication * application = hb_parptr( 1 );
   GtkWindow * window =  GTK_WINDOW( hb_parptr( 2 ) );
   gtk_application_add_window( application, window );
}

//-- averiguar como envolver una funcion que retorna **
HB_FUNC( GTK_APPLICATION_GET_ACCELS_FOR_ACTION )
{
   GtkApplication * application = hb_parptr( 1 );
   const gchar * detailed_action_name = hb_parc( 2 );
   hb_retc( gtk_application_get_accels_for_action( application, detailed_action_name ) );
}


HB_FUNC( GTK_APPLICATION_GET_ACTIONS_FOR_ACCEL )
{
   GtkApplication * application = hb_parptr( 1 );
   const gchar * accel = hb_parc( 2 );
   hb_retc( gtk_application_get_actions_for_accel( application, accel ) );
}


HB_FUNC( GTK_APPLICATION_GET_ACTIVATE_WINDOW )
{
   GtkApplication * application = hb_parptr( 1 );
   hb_retptr( gtk_application_get_active_window( application ) );
}


HB_FUNC( GTK_APPLICATION_GET_APP_MENU )
{
   GtkApplication * application = hb_parptr( 1 );
   hb_retptr( gtk_application_get_app_menu( application ) );
}


HB_FUNC( GTK_APPLICATION_GET_MENU_BY_ID )
{
   GtkApplication * application = hb_parptr( 1 );
   const gchar * id = hb_parc( 2 );
   hb_retptr( gtk_application_get_menu_by_id( application, id ) );
}


HB_FUNC( GTK_APPLICATION_GET_MENUBAR )
{
   GtkApplication * application = hb_parptr( 1 );
   GMenuModel * menu = gtk_application_get_menubar( application );
   hb_retptr( menu );
}


HB_FUNC( GTK_APPLICATION_GET_WINDOW_BY_ID )
{
   GtkApplication * application = hb_parptr( 1 );
   guint id = hb_parnd( 2 );
   GtkWindow * window = gtk_application_get_window_by_id( application, id );
   hb_retptr( window );
}


/*
HB_FUNC( GTK_APPLICATION_ )
{
   GtkApplication * application = hb_parptr( 1 );

}


HB_FUNC( GTK_APPLICATION_ )
{
   GtkApplication * application = hb_parptr( 1 );

}


HB_FUNC( GTK_APPLICATION_ )
{
   GtkApplication * application = hb_parptr( 1 );

}


HB_FUNC( GTK_APPLICATION_ )
{
   GtkApplication * application = hb_parptr( 1 );

}
*/
//eof
