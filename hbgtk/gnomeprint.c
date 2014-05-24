/*
 *  API libgnomeprint for [x]Harbour.
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Authors:
 *    Rafa Carmona( thefull@wanadoo.es )
 *
 *  Copyright 2004 Rafa Carmona
 */


//#ifdef HB_OS_LINUX
#if SUPPORT_PRINT_LINUX

#include <hbapi.h>
#include <gtk/gtk.h>
#include <libgnomeprint/gnome-print.h>
#include <libgnomeprint/gnome-print-job.h>
#include <libgnomeprint/gnome-print-pango.h>
#include <libgnomeprintui/gnome-print-dialog.h>

#if GTK_CHECK_VERSION(2,8,0)

/****************************************************************************
 * API gnome-print-job
 ****************************************************************************/
// Crea un nuevo trabajo de impresion
HB_FUNC( GNOME_PRINT_JOB_NEW )
{
  GnomePrintJob * job;
  GnomePrintConfig * config = NULL;

  if( hb_parnl( 1 )  );
      config = ( GnomePrintConfig * ) hb_parnl( 1 );

  job = gnome_print_job_new( config );
  hb_retnl( ( glong ) job );
}

// coge configuracion de la impresion
HB_FUNC( GNOME_PRINT_JOB_GET_CONFIG )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   GnomePrintConfig * config;

   config = gnome_print_job_get_config( job ) ;
   hb_retnl( ( glong ) config );
}

// Coge el contexto de la impresion.
// Si el retorno es NULL, se a producido un error.
HB_FUNC( GNOME_PRINT_JOB_GET_CONTEXT )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   hb_retnl( ( glong ) gnome_print_job_get_context( job ) );
}

// Cierra el trabajo de impresion, listo para imprimir o preview.
// Para ser llamado despues de la ultima orden de dibujo.
HB_FUNC( GNOME_PRINT_JOB_CLOSE )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   gnome_print_job_close( job );
}

// Imprime las pagina del trabajo de impresion al dispositivo fisico.
// Devuelve GNOME_PRINT_OK si va bien o GNOME_PRINT_ERROR_UNKNOWM si falla
HB_FUNC( GNOME_PRINT_JOB_PRINT )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   hb_retni( (gint) gnome_print_job_print( job ) );
}

// Render la salida a un contexto especifico( con layout, ignora copies )
HB_FUNC( GNOME_PRINT_JOB_RENDER )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 2 );
   gnome_print_job_render( job, ctx );
}

HB_FUNC( GNOME_PRINT_JOB_RENDER_PAGE )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 2 );
   gint page = hb_parni( 3 );
   gboolean pageops = hb_parl( 4 );
   hb_retni( gnome_print_job_render_page( job, ctx, page, pageops ) );
}

HB_FUNC( GNOME_PRINT_JOB_GET_PAGES )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   hb_retni( gnome_print_job_get_pages( job ) );
}

// Obsolete, not implement
// HB_FUNC( GNOME_PRINT_JOB_GET_PAGE_SIZE_FROM_CONFIG )

HB_FUNC( GNOME_PRINT_JOB_PRINT_TO_FILE )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   hb_retni( gnome_print_job_print_to_file( job, (gchar*)hb_parc( 2 ) ) );
}

/****************************************************************************
 * API gnome-print-config
 ****************************************************************************/
HB_FUNC( GNOME_PRINT_CONFIG_DEFAULT )
{
  hb_retnl( (glong) ((GnomePrintConfig *) gnome_print_config_default()) );
}

HB_FUNC( GNOME_PRINT_CONFIG_REF )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  config = gnome_print_config_ref( config );
  hb_retnl( (glong) config );
}

HB_FUNC( GNOME_PRINT_CONFIG_UNREF )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  config = gnome_print_config_unref( config );
  hb_retnl( (glong) config );
}

HB_FUNC( GNOME_PRINT_CONFIG_DUP )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  config = gnome_print_config_dup( config );
  hb_retnl( (glong) config );
}

HB_FUNC( GNOME_PRINT_CONFIG_GET )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar * key = hb_parc( 2 );
  hb_retc( (guchar*) gnome_print_config_get( config,key ) );
}

HB_FUNC( GNOME_PRINT_CONFIG_SET )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  const guchar * key   = (guchar*) hb_parc( 2 );
  const guchar * value = (guchar*) hb_parc( 3 );
  hb_retl( gnome_print_config_set( config, key, value ) );
}

// Las funciones tipo GET el tercer parametro es pasado por referencia
// para restaurar el valor devuelto.
// A su vez la funcion retorna si a tenido exito o no
HB_FUNC( GNOME_PRINT_CONFIG_GET_BOOLEAN )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar    * key   = hb_parc( 2 );
  gboolean  val;
  gboolean bResult = gnome_print_config_get_boolean( config, key, &val);
  hb_storl( ( gboolean ) val, 3 );
  hb_retl( bResult );
}

HB_FUNC( GNOME_PRINT_CONFIG_GET_INT )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar * key   = hb_parc( 2 );
  gint   val;
  gboolean bResult = gnome_print_config_get_int( config, key, &val);
  hb_storni( ( gint ) val, 3 );
  hb_retl( bResult );
}

HB_FUNC( GNOME_PRINT_CONFIG_GET_DOUBLE )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar * key   = hb_parc( 2 );
  gdouble val;
  gboolean bResult = gnome_print_config_get_double( config, key, &val);
  hb_stornd( ( gdouble ) val, 3 );
  hb_retl( bResult );
}

// TODO: Falta pasar pointer the struct GnomePrintUnit
HB_FUNC( GNOME_PRINT_CONFIG_GET_LENGTH ) // pConfig, key, @val-> logical
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar  * key   = hb_parc( 2 );
  gdouble  val;
  gboolean bResult = gnome_print_config_get_length( config, key, &val, NULL);
  hb_stornd( ( gdouble ) val, 3 );
  hb_retl( bResult );
}

HB_FUNC( GNOME_PRINT_CONFIG_SET_BOOLEAN )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar  * key = hb_parc( 2 );
  gboolean  val = hb_parl( 3 );
  hb_retl( gnome_print_config_set_boolean( config, key, val) );
}

HB_FUNC( GNOME_PRINT_CONFIG_SET_INT )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar  * key = hb_parc( 2 );
  gint      val = hb_parni( 3 );
  hb_retl( gnome_print_config_set_int( config, key, val) );
}

HB_FUNC( GNOME_PRINT_CONFIG_SET_DOUBLE )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar  * key = hb_parc( 2 );
  gdouble   val = hb_parnd( 3 );
  hb_retl( gnome_print_config_set_double( config, key, val) );
}

// TODO: Falta pasar pointer the struct GnomePrintUnit
HB_FUNC( GNOME_PRINT_CONFIG_SET_LENGTH)
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  guchar  * key = hb_parc( 2 );
  gdouble   val = hb_parnd( 3 );
  hb_retl( gnome_print_config_set_length( config, key, val, NULL ) );
}

HB_FUNC( GNOME_PRINT_CONFIG_DUMP )
{
  GnomePrintConfig * config = ( GnomePrintConfig * ) hb_parnl( 1 );
  gnome_print_config_dump( config );
}


/****************************************************************************
 * API gnome-print
 ****************************************************************************/

HB_FUNC( GNOME_PRINT_CONTEXT_NEW )
{
  GnomePrintContext * ctx ;
  GnomePrintConfig  * config = (GnomePrintConfig *) hb_parnl( 1 );
  ctx = gnome_print_context_new( config );
  hb_retnl( (glong) ctx );
}

HB_FUNC( GNOME_PRINT_CONTEXT_CLOSE )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_context_close( ctx ) );
}

HB_FUNC( GNOME_PRINT_BEGINPAGE )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_beginpage( ctx , hb_parc( 2 ) ) );
}

HB_FUNC( GNOME_PRINT_SHOWPAGE )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_showpage( ctx ) );
}

HB_FUNC( GNOME_PRINT_SHOW )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_show( ctx, (guchar*) hb_parc( 2) ) );
}

HB_FUNC( GNOME_PRINT_SETFONT )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  GnomeFont * font = ( GnomeFont *) hb_parnl( 2 );
  hb_retni( gnome_print_setfont( ctx, font ) );
}

HB_FUNC( GNOME_PRINT_MOVETO )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_moveto( ctx, (gdouble) hb_parnd( 2 ),
                                     (gdouble) hb_parnd( 3 ) ) );
}

HB_FUNC( GNOME_PRINT_TRANSLATE )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_translate( ctx, hb_parnd( 2 ), hb_parnd( 3 ) ) );
}

HB_FUNC( GNOME_PRINT_SETRGBCOLOR )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_setrgbcolor( ctx,
                                     hb_parnd( 2 ),
                                     hb_parnd( 3 ),
                                     hb_parnd( 4) ) );
}

HB_FUNC( GNOME_PRINT_NEWPATH )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_newpath( ctx ) );
}

HB_FUNC( GNOME_PRINT_CLOSEPATH )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_closepath( ctx ) );
}

HB_FUNC( GNOME_PRINT_STROKEPATH )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_strokepath( ctx ) );
}

HB_FUNC( GNOME_PRINT_STROKE )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_stroke( ctx ) );
}

HB_FUNC( GNOME_PRINT_ARCTO ) // ctx, x,y,radius,angle1,angle2,direction
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_arcto( ctx ,
                               hb_parnd( 2 ),
                               hb_parnd( 3 ),
                               hb_parnd( 4 ),
                               hb_parnd( 5 ),
                               hb_parnd( 6 ),
                               hb_parni( 7 ) ) );
}

HB_FUNC( GNOME_PRINT_LINETO ) // ctx, x,y
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_lineto( ctx, hb_parnd( 2 ), hb_parnd( 3 ) ) );
}

HB_FUNC( GNOME_PRINT_SETLINEWIDTH ) // ctx, witdh
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_setlinewidth( ctx, hb_parnd( 2 ) ) );
}

HB_FUNC( GNOME_PRINT_ROTATE ) // ctx, theta
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_rotate( ctx, hb_parnd( 2 ) ) );
}

HB_FUNC( GNOME_PRINT_FILL ) // ctx
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_fill( ctx ) );
}

HB_FUNC( GNOME_PRINT_CLIP ) // ctx
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_clip( ctx ) );
}

HB_FUNC( GNOME_PRINT_EOCLIP ) // ctx
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_eoclip( ctx ) );
}

HB_FUNC( GNOME_PRINT_CURVETO ) // ctx, x1,y1,x2,y2,x3,y3
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_curveto( ctx ,
                               hb_parnd( 2 ),
                               hb_parnd( 3 ),
                               hb_parnd( 4 ),
                               hb_parnd( 5 ),
                               hb_parnd( 6 ),
                               hb_parnd( 7 ) ) );
}

HB_FUNC( GNOME_PRINT_SETOPACITY ) // ctx, opacity
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_setopacity( ctx , hb_parnd( 2 ) ) );
}

HB_FUNC( GNOME_PRINT_SETMITERLIMIT ) // ctx, limit
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_setmiterlimit( ctx , hb_parnd( 2 ) ) );
}

HB_FUNC( GNOME_PRINT_SETLINEJOIN ) // ctx, jointype
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_setlinejoin( ctx , hb_parni( 2 ) ) );
}

HB_FUNC( GNOME_PRINT_SETLINECAP ) // ctx, captype
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_setlinecap( ctx , hb_parni( 2 ) ) );
}

HB_FUNC( GNOME_PRINT_SCALE ) // ctx, sx,sy
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_scale( ctx, hb_parnd( 2 ), hb_parnd( 3 ) ) );
}

HB_FUNC( GNOME_PRINT_GSAVE )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_gsave( ctx ) );
}

HB_FUNC( GNOME_PRINT_GRESTORE )
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_grestore( ctx ) );
}

HB_FUNC( GNOME_PRINT_LINE_STROKED ) // ctx, x0,y0, x1, y1
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_line_stroked( ctx ,
                               hb_parnd( 2 ),
                               hb_parnd( 3 ),
                               hb_parnd( 4 ),
                               hb_parnd( 5 ) ) );
}

HB_FUNC( GNOME_PRINT_RECT_STROKED ) // ctx, x, y, width, height
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_rect_stroked( ctx ,
                               hb_parnd( 2 ),
                               hb_parnd( 3 ),
                               hb_parnd( 4 ),
                               hb_parnd( 5 ) ) );
}

HB_FUNC( GNOME_PRINT_RECT_FILLED ) // ctx, x, y, width, height
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  hb_retni( gnome_print_rect_filled( ctx ,
                               hb_parnd( 2 ),
                               hb_parnd( 3 ),
                               hb_parnd( 4 ),
                               hb_parnd( 5 ) ) );
}

// TODO:
/*
gint        gnome_print_bpath               (GnomePrintContext *pc,
                                             const ArtBpath *bpath,
                                             gboolean append);
gint        gnome_print_vpath               (GnomePrintContext *pc,
                                             const ArtVpath *vpath,
                                             gboolean append);
gint        gnome_print_setdash             (GnomePrintContext *pc,
                                             gint n_values,
                                             const gdouble *values,
                                             gdouble offset);
gint        gnome_print_concat              (GnomePrintContext *pc,
                                             const gdouble *matrix);
gint        gnome_print_show_sized          (GnomePrintContext *pc,
                                             const guchar *text,
                                             gint bytes);
gint        gnome_print_glyphlist           (GnomePrintContext *pc,
                                             GnomeGlyphList *glyphlist);
gint        gnome_print_grayimage           (GnomePrintContext *pc,
                                             const guchar *data,
                                             gint width,
                                             gint height,
                                             gint rowstride);
gint        gnome_print_rgbimage            (GnomePrintContext *pc,
                                             const guchar *data,
                                             gint width,
                                             gint height,
                                             gint rowstride);
gint        gnome_print_rgbaimage           (GnomePrintContext *pc,
                                             const guchar *data,
                                             gint width,
                                             gint height,
                                             gint rowstride);
*/

HB_FUNC( GNOME_PRINT_RGBIMAGE ) // context, pixbuf, width, height, rowstride
{
  GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
  const guchar *data = ( guchar * ) hb_parnl( 2 );
  hb_retni( gnome_print_rgbimage( ctx, data, hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ) ) );
}

/****************************************************************************
 * API gnome-font
 ****************************************************************************/
HB_FUNC( GNOME_FONT_FIND_CLOSEST )
{
   GnomeFont * font;
   font = gnome_font_find_closest( (guchar*) hb_parc( 1 ),(gdouble) hb_parnd(2) );
   hb_retnl( (glong) font );
}
//TODO:
/*
  Rest of API the gnome-font
*/
/****************************************************************************
 * API gnome-font-face
 ****************************************************************************/
HB_FUNC( GNOME_FONT_FACE_FIND_CLOSEST )
{
   GnomeFontFace * font;
   font = gnome_font_face_find_closest( (guchar*) hb_parc( 1 ) );
   hb_retnl( (glong) font );
}
//TODO:
/*
  Rest of API the gnome-font-face
*/

/****************************************************************************
 * Pango Integration libgnomeprint 2.8, -->pango =>1.5
 ****************************************************************************/

HB_FUNC( GNOME_PRINT_PANGO_CREATE_LAYOUT )
{
   GnomePrintContext * ctx = ( GnomePrintContext * ) hb_parnl( 1 );
   PangoLayout * layout = gnome_print_pango_create_layout( ctx );
   hb_retnl( (glong) layout );
  //Free with g_object_unref() when you are done with it.
}


/****************************************************************************
 * Function para facilitar la seleccion del tipo de impresion.
 * Se podria implementar facilmente en harbour, pero he querido hacerlo
 * en C por pura cuestion de velocidad.
 ****************************************************************************/
HB_FUNC( GTK_PRINT_DIALOG_NEW )
{
   GtkWidget * dialog;
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );
   GnomePrintConfig * config;
   gint copies;
   gint result;

   dialog = gnome_print_dialog_new( job, hb_parc( 2 ), 0 );
   config = gnome_print_job_get_config(job);

   // Vamos a poner en el dialogo el numero correcto de copias.
   gnome_print_config_get_int(config, GNOME_PRINT_KEY_NUM_COPIES, &copies );
   gnome_print_dialog_set_copies ( (GnomePrintDialog*) dialog, copies, 0);

   gtk_window_set_position( GTK_WINDOW( dialog ), GTK_WIN_POS_CENTER );
   gtk_widget_show( dialog );
   result = gtk_dialog_run( GTK_DIALOG( dialog ) );

   hb_retl( result != GNOME_PRINT_DIALOG_RESPONSE_CANCEL );
}

#endif
#endif