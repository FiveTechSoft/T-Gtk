// ------------------------------------------------------------------------------------
// (c) 2011-2012 Rafa Carmona
// ------------------------------------------------------------------------------------
   #define rLEFT   1
   #define rTOP    2
   #define rRIGHT  3
   #define rBOTTOM 4

#xcommand DEFINE UTILPDF  <oUtil>  ;
          [ < of: PRINTER,OF> <oPrinter> ]  ;
          [ BRUSH <oBrush> ] ;
          [ PEN   <oPen>   ] ;
         =>;
         [ <oUtil> := ] TUtilPdf():New( <oPrinter>,<oBrush>,<oPen> )

#xcommand UTILPDF <oUtil> ;
          [ <nRow>,<nCol> SAY <cText> ];
          [ FONT <cFont> ] [SIZE <nSize> ];
          [ COLOR RGB <nRed>,<nGreen>,<nBlue> ];
          [ ROTATE <nAngle>];
         =>;
           <oUtil>:Text( <cText>,<nRow>,<nCol>,<cFont>,<nSize>, <nRed>,<nGreen>,<nBlue>, <nAngle>)

#xcommand ISEPARATOR [ <nSpace> ] [<lBody: BODY>];
         =>;
           ::Separator( <nSpace> , <.lBody.>)

#xcommand UTILPDF <oUtil> ;
          BOX <nX>,<nY> TO <nX2>,<nY2> ;
          [  <lStroke: STROKE> [ SIZE <nWitdh>] [ COLOR <nRed>,<nGreen>,<nBlue> ] ];
          [  <lFill: FILLRGB> <nRed2>,<nGreen2>,<nBlue2>  ];
         =>;
           <oUtil>:Box( <nX>,<nY>,<nX2>,<nY2>,<nWitdh>,<.lStroke.>,<nRed>,<nGreen>,<nBlue>,<.lFill.>,<nRed2>,<nGreen2>,<nBlue2> )

#xcommand UTILPDF <oUtil> ;
          LINEA <nX>,<nY> TO <nX2>,<nY2> ;
          [ WITDH <nWitdh>];
          [ COLOR <nRed>,<nGreen>,<nBlue> ] ;
         =>;
           <oUtil>:Linea( <nX>,<nY>,<nX2>,<nY2>,<nWitdh>,<nRed>,<nGreen>,<nBlue> )

#xcommand UTILPDF <oUtil> ;
          [<nX>,<nY>] IMAGE <cFile> [ SIZE <nX2>,<nY2> ] ;
          [ <lImage: JPG > ];
          [ <lPage: PAGE > ];
         =>;
           <oUtil>:SayImage( <nX>,<nY>,<nX2>,<nY2>,<cFile>,<.lImage.>,<.lPage.> )


