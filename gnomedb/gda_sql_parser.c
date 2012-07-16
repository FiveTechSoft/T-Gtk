/* $Id: gda_sql_parser.c,v 1.0 2012-07-06 22:40:16 riztan Exp $*/
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
    (c)2012 Rafael Carmona <rafa.tgtk at gmail.com>
    (c)2012 Riztan Gutierrez <riztan at gmail.com>
*/

#ifdef _GDA_

#include <hbapi.h>
#include <hbapiitm.h>
#include <hbapierr.h>

// Functions LIBGDA
#include <glib.h>
#include <glib-object.h>
#include <libgda/libgda.h>
#include <sql-parser/gda-sql-parser.h>

#include <hbgda.h>

HB_FUNC( GDA_SQL_PARSER_PARSE_STRING )
{
   GdaSqlParser *parser = (GdaSqlParser *) hb_parptr( 1 );
   const gchar *sql = hb_parc( 2 );
   const gchar *remain; 
   GError *error = NULL;

   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );

   hb_retptr( (GdaStatement *) gda_sql_parser_parse_string( parser, sql, &remain, &error ) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}

#endif
//eof
