/* $Id: g_utils.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

    
HB_FUNC( HB_G_FIND_PROGRAM_IN_PATH )
{
  gchar * command_line = (gchar *) hb_parc(1);
  gchar * valret = g_find_program_in_path(command_line);
  hb_retc( valret );
}  
 
HB_FUNC( HB_G_GET_CURRENT_DIR )
{
  hb_retc( g_get_current_dir() );
}   

HB_FUNC( HB_G_GET_HOME_DIR )
{
  G_CONST_RETURN gchar * valret = g_get_home_dir();
  hb_retc( g_strdup (valret) );
}   

HB_FUNC( HB_G_GET_TMP_DIR )
{
  G_CONST_RETURN gchar * valret = g_get_tmp_dir();
  hb_retc( g_strdup (valret) );
}   

HB_FUNC( HB_G_GET_USER_NAME )
{
  G_CONST_RETURN gchar * valret = g_get_user_name();
  hb_retc( g_strdup (valret) );
}   

HB_FUNC( HB_G_GET_REAL_NAME )
{
  G_CONST_RETURN gchar * valret = g_get_real_name();
  hb_retc( g_strdup (valret) );
}   
 
HB_FUNC( HB_G_GETENV )
{
  gchar * command_line = (gchar *) hb_parc(1);
  G_CONST_RETURN gchar * valret = g_getenv(command_line);
  hb_retc( g_strdup (valret) );
}  
 
HB_FUNC( HB_G_PATH_GET_BASENAME )
{
  gchar * command_line = (gchar *) hb_parc(1);
  hb_retc( g_path_get_basename(command_line) );
}   
 
HB_FUNC( HB_G_GET_PRGNAME ) //-> programa en ejecucion
{
  hb_retc( g_get_prgname() );
}    

HB_FUNC( HB_G_GET_APPLICATION_NAME ) //-> human-readable application name
{
  G_CONST_RETURN gchar * valret = g_get_application_name();
  hb_retc( g_strdup (valret) );
}     

HB_FUNC( HB_NOR )
{
   LONG lRet = 0;
   LONG i = 0;

   while( i < hb_pcount() )
      lRet |= ( LONG ) hb_parnl( ++i );

   hb_retnl( lRet );
}

//----------------------------------------------------------------------------//

HB_FUNC( HB_NAND )
{
   LONG lRet = -1;
   LONG i = 0;
   while( i < hb_pcount() )
        lRet &= hb_parnl( ++i );

   hb_retnl( lRet );
}

//eof
