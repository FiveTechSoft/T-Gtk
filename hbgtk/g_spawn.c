/* $Id: g_spawn.c,v 1.2 2010-12-28 13:40:06 xthefull Exp $*/
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
#include <hbapi.h>
#include <glib.h>

/* Esto es la version reducida del g_spawn_async, y funciona ;-) */
HB_FUNC( WINEXEC )
{
  const gchar * command_line = hb_parc( 1 );
  GError * error;
  hb_retl( g_spawn_command_line_async( command_line, &error ) );
}

HB_FUNC( SHELLEXEC )   //-> path, name_program, params_program
{
  gchar **argv = NULL;
  GError * error;

  if (!g_shell_parse_argv( g_strdup_printf( "%s %s", 
                                            (gchar *) hb_parc(2), 
                                            (gchar *) hb_parc(3) ),
                           NULL, &argv, &error) )
  {
    g_print( "Error parsing command line %s\n", error->message);
    g_error_free( error );
    exit( 1 );
  }

  hb_retl( g_spawn_async ((gchar *) hb_parc(1),
                          argv,
                          NULL,
                          G_SPAWN_SEARCH_PATH,
                          NULL,
                          NULL,
                          NULL,
                          &error) );
  g_strfreev (argv);
}

/* Esto es la version reducida del g_spawn_sync, y funciona ;-) 
 * El WINRUN famaso*/
HB_FUNC( WINRUN )
{
  const gchar * command_line = hb_parc( 1 );
  GError * error;
  /*
   * gchar * standard_output;
   * gchar * standard_error;
   * gint  * exit_status;
   */
  hb_retl(  g_spawn_command_line_sync ( command_line,
                                        NULL,
                                        NULL,
                                        NULL,
                                        &error ) );
}
