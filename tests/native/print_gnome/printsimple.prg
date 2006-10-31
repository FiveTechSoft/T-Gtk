/*
 * Printer multiplataform support
 * PLEASE, view Rules.make
 * GNU/Linux --------------------
 * SUPPORT_PRINT_LINUX=yes
 * SUPPORT_PRINT_WIN32=no
 *
 * Win32 ------------------------
 * SUPPORT_PRINT_LINUX=no
 * SUPPORT_PRINT_WIN32=yes 
 *
 * Demostration print simple under T-Gtk and Harbour
 * (c)2004 Rafa Carmoma
 * (c)2005 Joaquim Ferrer, win32 support
 * cFileNamePrint is name the output file print
 * lDialog if you view select options from dialog
 * lDump if view dump caracterist printer
 */
 
#include "gclass.ch"
#include "gnomeprint.ch"

Function Main( cFileNamePrint, lDialog, lDump )

        local job
        Local gpc
        Local config, lResult
        Local cOutput := ".pdf"
// -->Add by Quim
DEFAULT lDialog := .t.
// <--
        if Empty( cFileNamePrint )
           cFileNamePrint := "output"
        endif

        if Empty( lDialog ) ; lDialog := .F.; else ; lDialog := .T. ; endif
        if Empty( lDump )   ; lDump   := .F.; else ; lDump   := .T. ;endif

        g_type_init ()

        job = gnome_print_job_new( )
        gpc = gnome_print_job_get_context( job )

        config = gnome_print_job_get_config (job)

        if !gnome_print_config_set (config, "Printer", "PDF")
           gnome_print_config_set (config, "Printer", "GENERIC")
           cOutPut := ".ps"
        endif
        gnome_print_job_print_to_file (job, cFileNamePrint + cOutput )

        gnome_print_config_set(config, GNOME_PRINT_KEY_PREFERED_UNIT, "CM")
        gnome_print_config_set(config, GNOME_PRINT_KEY_PAPER_SIZE, "Executive")
        gnome_print_config_set(config, GNOME_PRINT_KEY_NUM_COPIES, "2" )


// Algunas de las opciones que hemos definido son tenidas en cuenta
        // en el dialog, otras, como las copias, las tenemos que meter a mano
        if lDialog
           if !gtk_print_dialog_new( job, " Printer multiplataform support :-) ",;
               nOr( GNOME_PRINT_DIALOG_RANGE,GNOME_PRINT_DIALOG_COPIES ) )
               g_object_unref( config )
               g_object_unref( gpc )
               g_object_unref( job )
               g_print( "Cancelamos impresion" )
               QUIT
           endif
        endif

        if lDump
           Caracteristicas( config )
        endif

        my_draw( gpc )


        gnome_print_job_close (job)
        gnome_print_job_print (job)

        g_object_unref( config )
        g_object_unref( gpc )
        g_object_unref( job )

        if "Linux" $ OS()
           winexec( "kghostview "+ cFileNamePrint + cOutput )
        endif

return nil

STATIC FUNCTION my_draw( gpc )
       Local font
       Local radius := 50

       gnome_print_beginpage (gpc, "1")
       Image( gpc )
       gnome_print_showpage (gpc)
  
       gnome_print_beginpage (gpc, "2")

       Image( gpc )
       font = gnome_font_find_closest ("Sans Regular", 12)
       gnome_print_setfont (gpc, font)
       gnome_print_moveto (gpc, 100, 500)
       gnome_print_show (gpc, "1 - ESTO ES UN EJEMPLO")
       g_object_unref( font )

       gnome_print_setrgbcolor( gpc,1.0,0.45,0.76)
       font = gnome_font_find_closest ("Sans Bold Italic", 24)
       gnome_print_setfont (gpc, font)
       gnome_print_moveto (gpc, 100, 470)
       gnome_print_show (gpc, "2 -IMPRESION DESDE T-GTK" )

       gnome_print_setrgbcolor( gpc,0.0,0.0,0.0 )
       gnome_print_moveto (gpc, 100, 440)
       gnome_print_rotate(gpc, 30 )
       gnome_print_show (gpc, "3- Para GNU/Linux " )
       
       gnome_print_showpage (gpc)

       gnome_print_beginpage (gpc, "3")

       gnome_print_moveto (gpc, 50, 600)
       gnome_print_show (gpc, "La segunda pagina lista para primitivas" )

       gnome_print_translate(gpc, 10, 300)
       gnome_print_setlinewidth( gpc,5 )
       gnome_print_setrgbcolor( gpc,1.0,0.0,0.0 )
       gnome_print_newpath( gpc )
       gnome_print_arcto(gpc, radius, radius,  radius, 1, 360, 0)
       gnome_print_stroke(gpc)

       gnome_print_setlinewidth( gpc,2 )
       gnome_print_setrgbcolor( gpc,0.49,0.5,1.0 )
       gnome_print_moveto(gpc, 10, 10)
       gnome_print_newpath( gpc )
       gnome_print_arcto(gpc, radius, radius,  radius, 1, 360, 0)
       gnome_print_fill(gpc)

       gnome_print_setlinewidth( gpc,5 )
       gnome_print_setrgbcolor( gpc,0.0,1.0,0.0 )
       gnome_print_moveto(gpc, 100, 100)
       gnome_print_lineto(gpc, 200, 200)
       gnome_print_stroke(gpc)
       
       gnome_print_showpage (gpc)

       g_object_unref( font )


return nil


// Podemos saber longitudes como:
Static Func Caracteristicas( config )
 Local nWidth, nHeight

 gnome_print_config_get_length( config, GNOME_PRINT_KEY_PAPER_WIDTH, @nWidth )
 gnome_print_config_get_length( config, GNOME_PRINT_KEY_PAPER_HEIGHT, @nHeight )
 g_print( "Ancho: "+ cValtoChar( nWidth )+;
          " Alto: " + cValtoChar( nHeight )+HB_OSNEWLINE() )

 // Volcado de depuracion , volcarlo a disco printsimple > pepe.txt
 // para verlo mejor
 gnome_print_config_dump( config )

return nil


STATIC FUNCTION Image( gpc )
  Local pixbuf, pixbuf2, pixbuf3
  Local raw_image 
  Local rowstride 
  Local height    
  Local width     
  
  // Imagen original
  pixbuf2 := gdk_pixbuf_new_from_file( "../../images/raptor.jpg" )
  raw_image := gdk_pixbuf_get_pixels( pixbuf2 )
  rowstride := gdk_pixbuf_get_rowstride( pixbuf2 )
  height    := gdk_pixbuf_get_height( pixbuf2 )
  width     := gdk_pixbuf_get_width (pixbuf2 )
  gnome_print_gsave( gpc )
  gnome_print_translate ( gpc,0,600 )
  gnome_print_scale( gpc, 32, 32 )
  gnome_print_rgbimage( gpc, raw_image, width, height, rowstride )
  gnome_print_grestore( gpc ) 
  
 
  // Imagen rotada 90º
  pixbuf  :=  gdk_pixbuf_rotate_simple( pixbuf2, 90 )
  raw_image := gdk_pixbuf_get_pixels( pixbuf )
  rowstride := gdk_pixbuf_get_rowstride( pixbuf )
  height    := gdk_pixbuf_get_height( pixbuf )
  width     := gdk_pixbuf_get_width (pixbuf )

  gnome_print_gsave( gpc )
  gnome_print_translate ( gpc,50,600 )
  gnome_print_scale( gpc, 32, 32 )
  gnome_print_rgbimage( gpc, raw_image, width, height, rowstride )
  gnome_print_grestore( gpc ) 

  gdk_pixbuf_unref( pixbuf )

  // Imagen " Espejo " Horizontal
  pixbuf    := gdk_pixbuf_flip( pixbuf2, .T. )
  raw_image := gdk_pixbuf_get_pixels( pixbuf )
  rowstride := gdk_pixbuf_get_rowstride( pixbuf )
  height    := gdk_pixbuf_get_height( pixbuf )
  width     := gdk_pixbuf_get_width (pixbuf )

  gnome_print_gsave( gpc )
  gnome_print_translate ( gpc,100,600 )
  gnome_print_scale( gpc, 32, 32 )
  gnome_print_rgbimage( gpc, raw_image, width, height, rowstride )
  gnome_print_grestore( gpc ) 

  gdk_pixbuf_unref( pixbuf2 )
  gdk_pixbuf_unref( pixbuf )

return nil
