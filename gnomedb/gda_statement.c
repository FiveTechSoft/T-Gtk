/* $Id: gda_statement.c,v 1.0 2012-07-06 22:40:16 riztan Exp $*/
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
#include <libgda/libgda.h>

HB_FUNC( GDA_STATEMENT_NEW )
{
   hb_retptr( (GdaStatement *) gda_statement_new() );
}

HB_FUNC( GDA_STATEMENT_COPY )
{
   GdaStatement *orig = (GdaStatement *) hb_parptr( 1 );
   hb_retptr( (GdaStatement *) gda_statement_copy( orig ) );
}


HB_FUNC( GDA_STATEMENT_SERIALIZE )
{
   GdaStatement *stmt = (GdaStatement *) hb_parptr( 1 );
   hb_retc( gda_statement_serialize( stmt ) );
}

HB_FUNC( GDA_STATEMENT_IS_USELESS )
{
   GdaStatement *stmt = (GdaStatement *) hb_parptr( 1 );
   hb_retl( gda_statement_is_useless( stmt ) );
}

#endif
//oef
