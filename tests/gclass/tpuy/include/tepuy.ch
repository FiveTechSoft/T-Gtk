/*  $Id: gclass.ch,v 1.13 2008/12/02 21:37:48 riztan Exp $ */
/*
	Copyright © 2008  Riztan Gutierrez <riztang@gmail.org>

   Este programa es software libre: usted puede redistribuirlo y/o modificarlo 
   conforme a los términos de la Licencia Pública General de GNU publicada por
   la Fundación para el Software Libre, ya sea la versión 3 de esta Licencia o 
   (a su elección) cualquier versión posterior.

   Este programa se distribuye con el deseo de que le resulte útil, pero 
   SIN GARANTÍAS DE NINGÚN TIPO; ni siquiera con las garantías implícitas de
   COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO DETERMINADO. Para más información, 
   consulte la Licencia Pública General de GNU.

   http://www.gnu.org/licenses/
*/
/*
 * Cambios por Miguel Suarez (tyler)  <tyler.ve@gmail.com> : 
 * TPYSELECTOR 
 *
 */

#include "xhb.ch"
//#translate  <exp1> IN <exp2>     =>  <exp1> $ <exp2> 

#define TEPUY_VERSION            "Alfa 0.1"
#define TEPUY_NAME               "tepuy"
#define TEPUY_WWW                "http://code.google.com/p/tepuysoft/"
#define TEPUY_TEAM               "http://code.google.com/p/tepuysoft/people/list"
#define TEPUY_MAIL               "desarrollo@tepuy.org"
#define TEPUY_SCHEMA             "tepuy"

#define TPY_DATEFORMAT  "dd/mm/yyyy"

#define PANGO_STYLE_ITALIC       2


/* desde common.ch de xharbour */

/* DEFAULT and UPDATE commands */
/*
#xcommand DEFAULT <v1> TO <x1> [, <vn> TO <xn> ] => ;
                                IF <v1> == NIL ; <v1> := <x1> ; END ;
                                [; IF <vn> == NIL ; <vn> := <xn> ; END ]
#xcommand DEFAULT <v1> := <x1> [, <vn> := <xn> ] => ;
                                IF <v1> == NIL ; <v1> := <x1> ; END ;
                                [; IF <vn> == NIL ; <vn> := <xn> ; END ]
*/
#define YES                     .T.
#define NO                      .F.

//Fin



#define TPY_CONN    oTpuy:aConnection[1]
#define OSDRIVE()   IIF( "Linux"$OS(), "", CURDRIVE() )    // Parche por mal funcionamiento en GNU

#xcommand  DO <uAction> IF <Condition>  => IF <Condition> ; <uAction> ; ENDIF

/* Definiciones para XML */

#xcommand DEFINE XML_DOC <oXmlDoc> ;
      => ;
      <oXmlDoc> :=  TXmlDocument():New(  '<?xml version="1.0" encoding="ISO-8859-1" ?>'  )
//      <oXmlDoc> :=  TXmlDocument():New(  '<?xml version="1.0"?>'  ) dxn
      
#xcommand DEFINE XML_NODE <oXmlNode> TITLE <cTitle> ;
                               [ TYPE <nType>];
                               [ ATTRIBUTES <hAttributes>];
                               [ DATA <cData> ];
      => ;
      <oXmlNode> := TXmlNode():New( [nType], <cTitle>, ;
                               [<hAttributes>], [<cData>] )
      
#command XML_ADD_BELOW <oXmlNode> TO <oXmlDoc> ;
            => ;
    <oXmlDoc>:AddBelow( <oXmlNode> )

#command XML_ADD_BELOW ROOT <oXmlNode> TO <oXmlDoc> ;
            => ;
    <oXmlDoc>:oRoot:AddBelow( <oXmlNode> )




/* Definiciones para Modelo de Datos */
//dxn mdf
#xcommand DEFINE MODEL <oModel> ;
                 [ CONN <oConn>      ] ;
                 [ QUERY <oQuery>    ] ;
                 [ STRUCT <aStruct>  ] ;
                 [ DATA <aData>      ] ;
                 [ ACTIONS <aAction> ] ;
                 [ ON_EDIT <aEdited> ] ;
      => ;
      <oModel>:=TPY_DATA_MODEL():New( <oConn>, <oQuery>, <aStruct>, <aData>, <aAction>, <aEdited> )




/* Otros */

#xcommand DEFINE LISTBOX <oListBox> ;
                 [ OF <oParent>             ] ;
                 [ MODEL <oModel>           ] ;
                 [ TITLE <cTitle>           ] ;
                 [ ICON  <oIcon>            ] ;
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ ID <cId> RESOURCE <cResource> ];
      => ;
      <oListBox>:=TPY_LISTBOX():New( <oParent>, <oModel>, <cTitle>, <oIcon>, <nWidth>, <nHeight>, <cId>, <cResource> )

#xcommand ACTIVATE LISTBOX <oParent> ;
                 [ ACTION <bAction> ];
                 [ INIT <bInit> ];
      => ;
      <oParent>:Active( [ \{|o| <bAction> \} ], [ \{|o| <bInit> \} ] )


#xcommand DEFINE FORMEDIT <oForm> ;
                 [ MODEL <oModel>           ] ;
                 [ TITLE <cTitle>           ] ;
                 [ ICON  <oIcon>            ] ;
                 [ ROW   <nRow>             ] ;
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ OF <oParent>             ] ;
                 [ ID <cId> RESOURCE <cResource> ];
      => ;
      <oForm>:=TPY_ABM():New( <oParent>, <oModel>, <cTitle>, <oIcon>, <nRow>, ;
                              <nWidth>, <nHeight>, <cId>, <cResource> )


#xcommand ACTIVATE FORMEDIT <oForm> ;
                 [ ACTION <bAction> ];
                 [ INIT <bInit> ];
      => ;
      <oForm>:Active( [ \{|o| <bAction> \} ], [ \{|o| <bInit> \} ] )



#xcommand DEFINE TPYDOC <oDoc> ;
               [ CONN <oConn> ] ;
               [ SCHEMA <cSchema> ] ;
               [ LISTBOX_QUERY <cQuery> ] ;
               [ LISTBOX_TITLE <cListBoxTitle> ] ;
               [ LISTBOX_SIZE <nListBoxWidth>,<nListBoxHeight> ] ;
               [ LISTBOX_RESOURCE <cListBoxResource> ] ;
               [ FORM_TITLE <cFormTitle> ] ;
               [ FORM_SIZE <nFormWidth>,<nFormHeight> ] ;
               [ FORM_RESOURCE <cFormResource> ] ;
      => ;
      <oDoc>:=TPY_DOC():New([<oConn>],[<cSchema>],,,[<cQuery>],[<cListBoxTitle>],;
                            [<nListBoxWidth>],[<nListBoxHeight>],[<cListBoxResource>],;
                            [<cFormTitle>],[<nFormWidth>],[<nFormHeight>],;
                            [<cFormResource>] )

#xcommand ACTIVATE TPYDOC <oDoc> ;
      => ;
      <oDoc>:Active()

#xcommand SET DETAL QUERY <cBody> ON <oDoc> ;
      =>  <oDoc>:cQDetal := <cBody>
      
#xcommand SET DETAL TABLES <table,...> ON <oDoc> ;
      =>  <oDoc>:aQDetalTables := \{<table>\}

#xcommand SET DETAL WHERE <cWhere> ON <oDoc> ;
      =>  <oDoc>:cQDetalWhere := <cWhere>

#xcommand SET DETAL OTHER <cOther> ON <oDoc> ;
      =>  <oDoc>:cQDetalOther := <cOther>



#xcommand DEFINE TPYSELECTOR [ <oFrame> ] [ OF <oParent> ] ;
               [ <label: TEXT,LABEL,PROMPT> <cText> ];
               [ SHADOW <nShadow> ];
               [ ALIGN <nHor>, <nVer> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ LABELNOTEBOOK <uLabelBook> ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
               [ FROM STOCK <cFromstock> [ SIZE_ICON <nSize> ]];
               [ ACTION <bAction>];
               [ ICON_FILE <cFileImg>];
               [ NAME <cName>];
               [ VALUE <cValue>];
       => ;
 [ <oFrame> := ]tpyselector():New( <cText>, <nShadow>, <nHor>, <nVer>, <oParent>, <.lExpand.>, <.lFill.>,;
                <nPadding>, <.lContainer.>, <x>, <y>, <cId>, <uGlade>,;
                <uLabelBook>, <nWidth>, <nHeight>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,;
                <cFromstock>, <nSize>, [ \{|o| <bAction> \} ], [<cFileImg>],;
                <cName>, <cValue> )


#xcommand DEFINE TPYSELECTORDATE [ <oFrame> ] [ OF <oParent> ] ;
               [ <label: TEXT,LABEL,PROMPT> <cText> ];
               [ SHADOW <nShadow> ];
               [ ALIGN <nHor>, <nVer> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ LABELNOTEBOOK <uLabelBook> ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
               [ FROM STOCK <cFromstock> [ SIZE_ICON <nSize> ]];
               [ ACTION <bAction>];
               [ ICON_FILE <cFileImg>];
               [ NAME <cName>];
               [ VALUE <cValue>];
       => ;
 [ <oFrame> := ]tpyselectordate():New( <cText>, <nShadow>, <nHor>, <nVer>, <oParent>, <.lExpand.>, <.lFill.>,;
                <nPadding>, <.lContainer.>, <x>, <y>, <cId>, <uGlade>,;
                <uLabelBook>, <nWidth>, <nHeight>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,;
                <cFromstock>, <nSize>, [ \{|o| <bAction> \} ], [<cFileImg>],;
                <cName>, <cValue> )



#xcommand DEFINE TPYENTRY [ <oBoxEntry> ];
	       [ NAME <cName> ];
               [ <lMarkup: MARKUP> ] ;
               [ FONTLABEL <oFontLabel> ];
	       [ VAR <uValue> ];
	       [ <lPassword: PASSWORD> ] ;
	       [ FONTVALUE <oFontValue> ];
               [ <lHomogeneous: HOMOGENEOUS, HOMO> ] ;
               [ OF <oParent1>[, <oParent2>] ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
      => ;
      [  <oBoxEntry> := ] TPYENTRY():New(  <cName>, <.lMarkup.>, <oFontLabel>, <uValue>, <oFontValue>,;
                  <.lPassword.>, <.lHomogeneous.>, <oParent1>, <oParent2>, <.lExpand.>,;
                  <.lFill.>, <nPadding>, <.lContainer.>, <x>, <y>, <uLabelBook>,;
                  <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                  <xOptions_ta>, <yOptions_ta>, <cId>, <uGlade> )
