#define df_ADD   1
#define df_EDIT  2
#define df_DEL   3


//TODO: USER falta hasta tener la clase realizada
#xcommand DEFINE MANTENIMIENTO [ <oMante> ];
                               [ TITLE <cTitle> ] ;
                               [ QUERY <cQuery>];
                               [ DOLPHIN <oDolphin>];
                               [ ROW ACTION <uRowAction>];
                               [ BUTTON ADD <uAdd> ] ;
                               [ BUTTON DEL <uDel> ] ;
                               [ BUTTON EDIT <uEdit> ] ;
                               [ COLUMN VALUE <nGetColumnValue> ] ;
                               [ VIEW COLUMNS  <aViewColumns,...> ] ;
                               [ USER <oUser> ] ;
                               [ SIZE <nWidth>, <nHeigth> ] ;
      => ;
      [ <oMante> := ] GMante():NewWindow( <cTitle>, <cQuery>, <oDolphin>, [ \{|self,path,col| <uRowAction> \} ] ,;
                                          [ \{|Self| <uAdd> \} ],[ \{|Self| <uEdit> \} ], [ \{|Self| <uDel> \} ],;
                                           <nGetColumnValue>, \{<aViewColumns>\}, <nWidth> ,<nHeigth> )

