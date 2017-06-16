/* $Id: events.c,v 1.22 2011-09-15 23:41:34 xthefull Exp $*/
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
/*
 *   KERNEL T-GTK [ Control conexion de se�ales de GTK+ ]
 *  (c)2003 Rafa Carmona
 */

HB_FUNC( HARB_SIGNAL_CONNECT ) // widget, señal, Self, method a saltar, Connect_Flags, child
{
    GtkWidget *widget = ( GtkWidget * ) hb_parptr( 1 );
    gchar *cStr =  (gchar *) hb_parc( 2 );
    gint iPos = -1;
    gint x;
    gint iReturn;
    PHB_ITEM pSelf, pBlock;
    gint num_elements = sizeof( array )/ sizeof( TGtkActionParce );
    gint num_predefine = sizeof( predefine )/ sizeof( TGtkPreDfnParce );
    gint ConnectFlags = ISNIL( 5 ) ? (GConnectFlags) 0 :  (GConnectFlags) hb_parni( 5 );
    gchar *cMethod = "onInternalError"; // =  (gchar *) hb_parc( 4 );
    const gchar *gtk_class_name = NULL;

    // Check before seek in base array for possible signals, distints callbacks
    for ( x = 0;  x < num_predefine; x++ ) {
        if( g_ascii_strcasecmp( cStr, predefine[x].signalname ) == 0 ) {
            gtk_class_name = GTK_OBJECT_TYPE_NAME( widget ); // get name class_gtk
            break;
        }
    }

    // Find signal for process.
    for ( x = 0;  x < num_elements; x++ ) {
        // Si es encuentrada, y no tiene .gtkclassname y no hay existe signal en struct predefine
        if( g_ascii_strcasecmp( cStr, array[x].name ) == 0 && ! array[x].gtkclassname && ! gtk_class_name )
        {
            //g_print( "pos  %d %s \n", x, GTK_OBJECT_TYPE_NAME( widget ) );
            iPos = x;
            break;
        }

        // Si existe se�al en la struct predefine, gtk_class_name vale ahora el nombre del widget ,y ademas esta en array[x].gtkclassname.
        if( gtk_class_name && array[x].gtkclassname ){
            if ( g_ascii_strcasecmp( gtk_class_name, array[x].gtkclassname ) == 0 && g_ascii_strcasecmp( cStr, array[x].name ) == 0  )  {
                 //g_print( "pos class %d %s \n", x, GTK_OBJECT_TYPE_NAME( widget ));
                 iPos = x;
                 break;
            }
        }

        // Si existe se�al en la struct predefine, , pero en el array  no existe, guardamos posicion PERO no salimos
        if( gtk_class_name && ! array[x].gtkclassname ){
            if( g_ascii_strcasecmp( cStr, array[x].name ) == 0 ) {
                // g_print( "pos 3 %d %s \n", x, GTK_OBJECT_TYPE_NAME( widget ));
                iPos = x;
                  //break;
            }
        }
    }

    /* Si es Self, es el nombre del method, de lo contrario, puede ser un codeblock */
    if( ISOBJECT( 3 ) )
       cMethod = ISNIL( 4 ) ? array[ iPos ].method : (gchar *) hb_parc( 4 ); //This row is need for optimizations. when release a cmedhod in prg source is not work

    // Si pasamos un bloque de codigo, entonces, cMethod es igual a la se�al encontrada.
    // Asi, en el CALLBACK podemos seleccionar el codeblock de la se�al que nos interesa.
    if( ISBLOCK( 4 ) )
      cMethod = array[ iPos ].name;

    if ( iPos != -1 ){
      iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                       array[ iPos ].name,
                                       array[ iPos ].callback,
                                       cMethod,
                                       NULL, ConnectFlags );
      hb_retni( iReturn );
      }
   else
      g_print( "Attention, %s signal not support! Information method-%s, post-%i \n", cStr, cMethod, iPos);

    if( ISOBJECT( 3 ) ) {
       if( g_object_get_data( G_OBJECT( widget ), "Self" ) == NULL )
         {
          pSelf = hb_itemNew( hb_param( 3, HB_IT_OBJECT ) );
         // pSelf = hb_gcGripGet( hb_param( 3, HB_IT_OBJECT ) );
          g_object_set_data_full( G_OBJECT (widget), "Self", pSelf,
                                  (GDestroyNotify) liberate_block_memory );
          //Debug
          //g_print("\nEn har_e %d %s classname %s \n", GPOINTER_TO_UINT( pSelf ), array[ iPos ] , hb_objGetClsName( pSelf ) );
         }
    }


    /*Nota:
     * A diferencia de cuando disponemos de Self, necesitamos guardar cada bloque
     * por se�al, de lo contrario, solamente la primera declarada, funcionara...
     * Para ello, aprovechamos el nombre de la se�al, contenido en el array,
     * para guardar el codeblock segun la se�al.
     * */
    if( ISBLOCK( 4 ) ) {
      if( g_object_get_data( G_OBJECT( widget ), array[ iPos ].name ) == NULL )
        {
         // g_print( "Es un bloque de codigo\n");
         //pBlock = hb_gcGripGet( hb_param( 4, HB_IT_BLOCK | HB_IT_BYREF ) );
         //pBlock = hb_itemNew( hb_stackItemFromBase( 4 ) );
         // hb_stackItemFromBase(), significa que te devuelva un ITEM,
         // del STACK, partiendo de la BASE
         // y por BASE se entiende la funci�n actual
         pBlock = hb_itemNew( hb_param( 4, HB_IT_BLOCK | HB_IT_BYREF ));
         /**
         * Atencion !
         * Cualquier salida via gtk_main_quit() provocara que no se llame nunca
         * a la 'callback' destroy. Hay que 'cerrar' los contenedores para que
         * emitan la se�al 'destroy' y se pueda autollamar a la funcion de
         * liberacion de memoria liberate_block_memory
          **/
          g_object_set_data_full( G_OBJECT (widget), array[ iPos ].name, pBlock,
                                  (GDestroyNotify) liberate_block_memory );

        }
    }

}

//eof
