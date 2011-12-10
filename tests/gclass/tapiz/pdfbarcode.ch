#ifndef _BARCODE_
#define _BARCODE_

#translate @ <nRow>, <nCol> CODE128  <cCode> ;
                [ MODE <cMode>] ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>] ;
                => ;
        <oPdf>:Code128( <nRow>, <nCol> , <cCode>, <cMode> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize> )

#translate @ <nRow>, <nCol> CODE3_9  <cCode> ;
                [ <lCheck:CHECK> ] ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>]   ;
                => ;
        <oPdf>:Code3_9( <nRow>, <nCol> , <cCode>, <lCheck> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize> )

#translate @ <nRow>, <nCol> EAN13  <cCode> ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>] ;
                [ <lBanner:BANNER> ] ;
                [ FONT <cFont> ] ;
                => ;
        <oPdf>:EAN13( <nRow>, <nCol> , <cCode>, <.f.> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize>,;
                 <.lBanner.>, <cFont> )

#translate @ <nRow>, <nCol> UPCA  <cCode> ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>] ;
                [ <lBanner:BANNER> ] ;
                [ FONT <cFont> ] ;
                => ;
        <oPdf>:UPCA( <nRow>, <nCol> , <cCode>, <.f.> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize>,;
                 <.lBanner.>, <cFont>  )

#translate @ <nRow>, <nCol> EAN8  <cCode> ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>] ;
                [ <lBanner:BANNER> ] ;
                [ FONT <cFont> ] ;
                => ;
        <oPdf>:EAN8( <nRow>, <nCol> , <cCode>, <.f.> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize>,;
                 <.lBanner.>, <cFont>  )

#translate @ <nRow>, <nCol> SUP5  <cCode> ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>] ;
                [ <lBanner:BANNER> ] ;
                [ FONT <cFont> ] ;
                [ <lBanner:BANNER> ] ;
                [ FONT <cFont> ] ;
                => ;
        <oPdf>:SUP5( <nRow>, <nCol> , <cCode>, <.f.> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize>,;
                 <.lBanner.>, <cFont>  )

#translate @ <nRow>, <nCol> CODABAR  <cCode> ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>] ;
                => ;
        <oPdf>:CODABAR( <nRow>, <nCol> , <cCode>, <.f.> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize> )

#translate @ <nRow>, <nCol> INT25  <cCode> ;
                [ <lCheck:CHECK> ] ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>]   ;
                => ;
        <oPdf>:INT25( <nRow>, <nCol> , <cCode>, <lCheck> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize> )

#translate @ <nRow>, <nCol> IND25  <cCode> ;
                [ <lCheck:CHECK> ] ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>]   ;
                => ;
        <oPdf>:IND25( <nRow>, <nCol> , <cCode>, <lCheck> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize> )

#translate @ <nRow>, <nCol> MAT25  <cCode> ;
                [ <lCheck:CHECK> ] ;
                [ <lVert:VERTICAL> ];
                [ COLOR <nColor> ] ;
                [ WIDTH <nWidth> ] ;
                [ SIZE <nSize> ] ;
                [ OF <oPdf>]   ;
                => ;
        <oPdf>:MAT25( <nRow>, <nCol> , <cCode>, <lCheck> ;
                ,<nColor>, .not. <.lVert.>, <nWidth>, <nSize> )

#ENDIF
