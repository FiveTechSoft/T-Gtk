
/* $Id: events.c,v 1.22 2011-09-15 23:50:41 xthefull Exp $*/
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

static void LoadHashSignal();
static long G_GetHashPos( PHB_ITEM pHash, const char * szcKey );

/*
 * Gestion de Eventos general de T-Gtk a nivel de Clases.
 */                                                 //,  ->Codeblock
HB_FUNC( HARB_SIGNAL_CONNECT ) // widget, señal, Self, method a saltar, Connect_Flags, child
{
   GtkWidget *widget = ( GtkWidget * ) hb_parptr( 1 );
   gchar *cStr =  (gchar *) hb_parc( 2 );
   gchar *cStr2 = NULL;
   gint iPos = 0;
   gint iReturn;
   PHB_ITEM pSelf, pBlock;
   PHB_ITEM pValue;
   gint ConnectFlags = ISNIL( 5 ) ? (GConnectFlags) 0 :  (GConnectFlags) hb_parni( 5 );
   gchar *cMethod = "onInternalError"; // =  (gchar *) hb_parc( 4 );
   long lPosDef, lPosAct;
   TGtkActionParce * pActionParce;
   const gchar *gtk_class_name = NULL;
    
    
   if( ! phActionParce )
      LoadHashSignal();
    
   lPosAct = 0;
   lPosDef = 0;
   if( ISCHAR( 2 ) )
   {     
      lPosDef = G_GetHashPos( phpredefine, cStr );
      if( lPosDef > 0 )
      { 
         gtk_class_name = G_OBJECT_TYPE_NAME( ( GtkWidget * )widget );
         cStr2 = ( char * ) hb_xgrab( hb_parclen( 2 ) + 2 );
         memcpy( cStr2, hb_parc( 2 ), hb_parclen( 2 ) );
         memcpy( cStr2 + hb_parclen( 2 ), "-1", 3 );
         lPosAct = G_GetHashPos( phActionParce, cStr2 );
         hb_xfree( cStr2 );
         pValue       = hb_hashGetValueAt( phActionParce, lPosAct );
         pActionParce = ( TGtkActionParce * ) hb_itemGetPtr( pValue );

         if( !( g_ascii_strcasecmp( gtk_class_name, pActionParce->gtkclassname ) == 0 ) )
         lPosAct = G_GetHashPos( phActionParce, cStr );
         hb_itemRelease( pValue );
      }else
	 lPosAct = G_GetHashPos( phActionParce, cStr );

   }
    
   iPos = lPosAct;
   
   if ( iPos > 0 )
   {
      /* Si es Self, es el nombre del method, de lo contrario, puede ser un codeblock */
      pValue = hb_hashGetValueAt( phActionParce, iPos );
      pActionParce = ( TGtkActionParce * ) hb_itemGetPtr( pValue );
      
       
      if( ISOBJECT( 3 ) )
         cMethod = ISNIL( 4 ) ? pActionParce->method : (gchar *) hb_parc( 4 ); //This row is need for optimizations. when release a cmedhod in prg source is not work

      // Si pasamos un bloque de codigo, entonces, cMethod es igual a la se�al encontrada.
      // Asi, en el CALLBACK podemos seleccionar el codeblock de la se�al que nos interesa.
      if( ISBLOCK( 4 ) )
         cMethod = pActionParce->name;
       
      iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                       pActionParce->name,
                                       pActionParce->callback,
                                       cMethod,
                                       NULL, ConnectFlags );
      
      if( pValue )
         hb_itemRelease( pValue );
      
      hb_retni( iReturn );
   }
   else
      hb_errRT_BASE_Ext1( EG_ARG, 5001, GetGErrorMsg( 5001, NULL ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, 1, hb_paramError( 2 ) );

   
   if( ISOBJECT( 3 ) ) 
   {
      if( g_object_get_data( G_OBJECT( widget ), "Self" ) == NULL )
      {
         pSelf = hb_itemNew( hb_param( 3, HB_IT_OBJECT ) );
         // pSelf = hb_gcGripGet( hb_param( 3, HB_IT_OBJECT ) );
         g_object_set_data_full( G_OBJECT (widget), "Self", pSelf,
                                  (GDestroyNotify) liberate_block_memory );
         //Debug
         //g_print("\nEn har_e %d %s classname %s \n", GPOINTER_TO_UINT( pSelf ), array[ iPos ] , hb_objGetClsName( pSelf ) );
	  
       }
   }else{
      /*Nota:
       * A diferencia de cuando disponemos de Self, necesitamos guardar cada bloque                       
       * por se�al, de lo contrario, solamente la primera declarada, funcionara...
       * Para ello, aprovechamos el nombre de la se�al, contenido en el array,
       * para guardar el codeblock segun la se�al.
       **/
      if( ISBLOCK( 4 ) ) 
      {      
         if( lPosAct > 0 && g_object_get_data( G_OBJECT( widget ), pActionParce->name ) == NULL )
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
            g_object_set_data_full( G_OBJECT (widget), pActionParce->name, pBlock,
                                  (GDestroyNotify) liberate_block_memory );

         }
      }else{
         hb_errRT_BASE_Ext1( EG_ARG, 5003, GetGErrorMsg( 5003, NULL ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS ); 
      }
   }

}


//Fill hash from signals array
static void LoadHashSignal()
{

   long lLen = sizeof( predefine ) / sizeof( TGtkPreDfnParce );   

   if( ! phpredefine )
      phpredefine = hb_hashNew( NULL );
      
   hb_hashPreallocate( phpredefine, lLen );

   while( lLen-- )
   {
      char * pszKey;
      PHB_ITEM pKey, pValue;
      pszKey = ( char * ) hb_xgrab( strlen( predefine[ lLen ].signalname ) + 1 );
      hb_strncpyLower( pszKey, predefine[ lLen ].signalname, strlen( predefine[ lLen ].signalname ) );
      pKey   = hb_itemPutC( NULL, pszKey ); 
      pValue = hb_itemPutPtr( NULL, &predefine[ lLen ] );
      hb_hashAdd( phpredefine, pKey, pValue );
      hb_itemRelease( pKey );
      hb_itemRelease( pValue );
      hb_xfree( ( void *) pszKey );
   }   
  
   //Action
   lLen = sizeof( array ) / sizeof( TGtkActionParce );

   phActionParce = hb_hashNew( NULL );
      
   hb_hashPreallocate( phActionParce, lLen );

   while( lLen-- )
   {
      char * pszKey;
      PHB_ITEM pKey, pValue;
      
      if( array[ lLen ].gtkclassname )
      {
         pszKey = ( char * ) hb_xgrab( strlen( array[ lLen ].name ) + 2);
         hb_strncpyLower( pszKey, array[ lLen ].name, strlen( array[ lLen ].name ) );
	 memcpy( pszKey+strlen( pszKey ), "-1", 3 );
      }else
      {
         pszKey = ( char * ) hb_xgrab( strlen( array[ lLen ].name ) + 1);
         hb_strncpyLower( pszKey, array[ lLen ].name, strlen( array[ lLen ].name ) );   
      }
      
      pKey   = hb_itemPutC( NULL, pszKey );
      pValue = hb_itemPutPtr( NULL, &array[ lLen ] );
      hb_hashAdd( phActionParce, pKey, pValue );
      hb_itemRelease( pKey );
      hb_itemRelease( pValue );
      hb_xfree( ( void *) pszKey );
   }
   
}


static long G_GetHashPos( PHB_ITEM pHash, const char * cStr )
{
   long lPos=-1;
   
   if( cStr ){
     char * pszKey = ( char * ) hb_xgrab( strlen( cStr ) + 1 );
     PHB_ITEM pKey; 
     hb_strncpyLower( pszKey, cStr, strlen( cStr ) );
     pKey = hb_itemPutC( NULL, pszKey );
     hb_hashScan( pHash, pKey, ( GTKSIZE *) &lPos );
     hb_itemRelease( pKey );
     hb_xfree( pszKey );
   }
   
   return lPos;

}  


//eof
