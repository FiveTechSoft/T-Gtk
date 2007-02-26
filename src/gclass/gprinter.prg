/* $Id: gprinter.prg,v 1.2 2007-02-26 21:48:11 xthefull Exp $*/
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
    Clase para imprimir bajo GnomePrint( DEPRECATED... )
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
*/

/*Nota: Para versiones inferiores a GTK 2.10,  y para usar el sistema de GnomePrint, se debe
        de activar esta directiva en el compilador de Harbour.
        Por ejemplo, en el Makefile de los sources PRGS, añadir esta linea :
        PRGFLAGS= -D_GNOMEPRINT_ */

#ifdef _GNOMEPRINT_

#include "gclass.ch"
#include "hbclass.ch"
#include "gnomeprint.ch"

/*
Prototipo de clase y comando Printer

PRINTER oPrn ;
        FILE cFile ;
        FROM USER ;
        PDF ;
        COPIES nCopies ;
        FONTDEFAULT cFontDefault

        UTILPRN SAY "Hola" FONT cFont COLOR cColor OF oPrn

*/

static oPrinter
static s_lInit := .F.

//#ifdef HB_OS_LINUX

CLASS gPrinter

   DATA   job     // An internal handle of the printer job
   DATA   gpc     // an internal handle of the gnome print context
   DATA   config
   DATA   lCancel INIT .F. // Cancelamos la impresion desde el dialogo.

   DATA   nPage    // Pagina actual
   DATA   cFileName INIT "output"// fichero por defecto
   DATA   cOutput   INIT ".pdf"  // Extension por defecto
   DATA   cFontDefault  // Una fuente por defecto para usar en la impresion.

   METHOD New( cFile, lpdf, lUser, nCopies, cTitlePrint )
   METHOD End()
   METHOD Width()
   METHOD Height()

   METHOD StartPage() INLINE ;
          gnome_print_beginpage( ::gpc, AllTrim( Str( ::nPage++ ) ) )

   METHOD EndPage() INLINE  gnome_print_showpage( ::gpc )

   METHOD SetPos( nRow, nCol ) INLINE gnome_print_moveto( ::gpc, nCol, nRow )
   METHOD Say( nRow, nCol, cText ) INLINE ::SetPos( nRow, nCol ),;
                                           gnome_print_show ( ::gpc, cText )

   /*METHOD Line( nTop, nLeft, nBottom, nRight ) INLINE ;
      ::SetPos( nTop, nLeft ), PrnLine( ::hGpc, nBottom, nRight )
*/
ENDCLASS

METHOD New( cFile, lpdf, lUser, nCopies, cTitlePrint ) CLASS GPrinter
        DEFAULT lUser := .f.,;
                lpdf := .f.,;
                nCopies := 0,;
                cTitlePrint := "Print from T-Gtk"

   ::cFileName := cFile

   if !s_lInit
      s_lInit:= .T.
      g_type_init()
   endif

   ::job    := gnome_print_job_new( )
   ::gpc    := gnome_print_job_get_context( ::job )
   ::config := gnome_print_job_get_config( ::job )

   ::nPage := 1

   // Determinamos si podemos imprimir un PDF.
   if !gnome_print_config_set( ::config, "Printer", "PDF")  .OR. !lpdf
       gnome_print_config_set( ::config, "Printer", "GENERIC")
       ::cOutPut := ".ps"
   endif

   //Nombre del fichero de impresion.
   gnome_print_job_print_to_file( ::job, ::cFileName + ::cOutput )


//   TODO: Hacer method de caracteristicas....
   gnome_print_config_set(::config, GNOME_PRINT_KEY_PREFERED_UNIT, "CM")
   gnome_print_config_set(::config, GNOME_PRINT_KEY_PAPER_SIZE, "Executive")


   if nCopies > 0
      gnome_print_config_set( ::config, GNOME_PRINT_KEY_NUM_COPIES, cValToChar( nCopies ) )
   endif

   // Algunas de las opciones que hemos definido son tenidas en cuenta
   // en el dialog, otras, como las copias, las tenemos que meter a mano
   if lUser
      if !gtk_print_dialog_new( ::job, cTitlePrint,;
          nOr( GNOME_PRINT_DIALOG_RANGE,GNOME_PRINT_DIALOG_COPIES ) )
          g_object_unref( ::config )
          g_object_unref( ::gpc )
          g_object_unref( ::job )
          g_print( "Cancelamos impresion" )
          ::lCancel := .T.
          Return Self
       endif
    endif


return Self

METHOD End() CLASS GPRINTER

       gnome_print_job_close( ::job )
       gnome_print_job_print( ::job )

       g_object_unref( ::config )
       g_object_unref( ::gpc )
       g_object_unref( ::job )

RETURN NIL

METHOD Width() CLASS GPRINTER
       Local nWidth
       gnome_print_config_get_length( ::config, GNOME_PRINT_KEY_PAPER_WIDTH, @nWidth )
RETURn nWidth

METHOD Height() CLASS GPRINTER
       Local nHeight
       gnome_print_config_get_length( ::config, GNOME_PRINT_KEY_PAPER_HEIGHT, @nHeight )
RETURN nHeight

function PrintBegin( lUser )

return oPrinter := gPrinter():New( lUser )

function PrintEnd()

   oPrinter:End()
   oPrinter = nil

return nil

function PageBegin()

return oPrinter:StartPage()

function PageEnd()

return oPrinter:EndPage()

#endif
