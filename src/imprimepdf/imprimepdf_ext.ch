/*  $Id: imprimepdf_ext.ch,v 0.1 2015/11/09 23:00:14 riztan Exp $ */
/*
 * Llamadas externas para ejecutar desde script.
 * (c)2015 Riztan Gutierrez
 */

EXTERNAL TIMPRIMEPDF
EXTERNAL TUTILPDF
 
EXTERNAL HPDF_SAVETOFILE
EXTERNAL HPDF_SETCOMPRESSIONMODE
EXTERNAL HPDF_LOADPNGIMAGEFROMFILE
EXTERNAL HPDF_LOADJPEGIMAGEFROMFILE
EXTERNAL HPDF_USEUTFENCODINGS
EXTERNAL HPDF_SETCURRENTENCODER
EXTERNAL HPDF_LOADTTFONTFROMFILE
EXTERNAL HPDF_FONT_GETFONTNAME
EXTERNAL HPDF_ADDPAGE
EXTERNAL HPDF_FREE


EXTERNAL HPDF_IMAGE_GETWIDTH
EXTERNAL HPDF_IMAGE_GETHEIGHT

EXTERNAL HPDF_PAGE_SETSIZE
EXTERNAL HPDF_PAGE_GETHEIGHT
EXTERNAL HPDF_PAGE_GETWIDTH
EXTERNAL HPDF_PAGE_GETCURRENTFONTSIZE
EXTERNAL HPDF_PAGE_SETRGBSTROKE
EXTERNAL HPDF_PAGE_SETRGBFILL
EXTERNAL HPDF_PAGE_SETFONTANDSIZE
EXTERNAL HPDF_PAGE_FILL
EXTERNAL HPDF_PAGE_FILLSTROKE
EXTERNAL HPDF_PAGE_STROKE
EXTERNAL HPDF_PAGE_SETLINEWIDTH
EXTERNAL HPDF_PAGE_GSAVE
EXTERNAL HPDF_PAGE_GRESTORE
EXTERNAL HPDF_PAGE_SETTEXTMATRIX
EXTERNAL HPDF_PAGE_TEXTRECT
EXTERNAL HPDF_PAGE_SETLINECAP
EXTERNAL HPDF_PAGE_RECTANGLE
EXTERNAL HPDF_PAGE_MOVETO
EXTERNAL HPDF_PAGE_LINETO
EXTERNAL HPDF_PAGE_DRAWIMAGE
EXTERNAL HPDF_PAGE_MOVETEXTPOS
EXTERNAL HPDF_PAGE_SHOWTEXT
EXTERNAL HPDF_PAGE_BEGINTEXT
EXTERNAL HPDF_PAGE_ENDTEXT

EXTERNAL HB_RANDOM