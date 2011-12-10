#include "hbclass.ch"
#include "gclass.ch"

//#define nAcentoAgudo  65105
//#define nAcentoGrave  65104
//#define nDieresis     65111
//#define nTilde        126
//#define nCircunflejo  65106

// Shift Ctrl Alt
// Shift Izquierdo  65505
// Shift Derecho    65506
// Ctrl  Izquierdo  65507
// Ctrl  Derecho    65508
// Alt   Izquierdo  65513
// Alt   Derecho    65027

Static oGetAct



CLASS PC_Key

    DATA aObject
    DATA oFont
    DATA aKey

    METHOD New( aObject, oFont )
    METHOD AaDd( oObject )
    METHOD Display( oBox, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10 )
    METHOD SetKey( xKey, bFun )
    METHOD OnKey( oSender, pGdkEventKey )

ENDCLASS


METHOD New( aObject, oFont ) CLASS PC_Key
  Local x

  ::aObject := aObject
  ::oFont   := oFont
  ::aKey := {}

  for x=1 to Len(aObject)
    gtk_signal_connect(aObject[ x ]:pWidget, "key-press-event", { |oSender, pGdkEventKey| ::OnKey( oSender, pGdkEventKey ) } )
  next

RETURN self

METHOD AaDd( oObject ) CLASS PC_Key

  aaDd( ::aObject, oObject )
  gtk_signal_connect(oObject:pWidget, "key-press-event", { |oSender, pGdkEventKey| ::OnKey( oSender, pGdkEventKey ) } )

RETURN self

METHOD OnKey( oSender, pGdkEventKey ) CLASS PC_Key

  local  nKey, nType, x

  nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
  nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]

  if (x := Ascan( ::aKey, { |a| a[1] == nKey } )) > 0
    Eval(::aKey[x,2])
  end

Return .F.


METHOD SetKey( xKey, bFun ) CLASS PC_Key

  if ValType(xKey) = "A"
    aEval( xKey, { | a | aAdD(::aKey, { a, bFun } ) } )
  else
    aAdD( ::aKey, { xKey, bFun } )
  end

RETURN nil


METHOD Display( oBox, cF1, cF2, cF3, cF4, cF5, cF6, cF7, cF8, cF9, cF10, cF11, cF12, lDobleLine ) CLASS PC_Key
  Local oBox1, oTable

  DEFAULT cF1 := "      ", cF2 := "      ", cF3 := "      ", cF4 := "      ", cF5 := "      ",;
          cF6 := "      ", cF7 := "      ", cF8 := "      ", cF9 := "      ", cF10:= "      ",;
          cF11 := "      ", cF12 := "      ", lDobleLine := .f.

  DEFINE BOX oBox1 OF oBox

  If lDobleLine
    DEFINE TABLE oTable ROWS 2 COLS 12 OF oBox1

    DEFINE LABEL PROMPT " F1 " OF oTable TABLEATTACH 0,1,0,1
    DEFINE LABEL PROMPT cF1 EXPAND OF oTable TABLEATTACH 0,1,1,2
    DEFINE LABEL PROMPT " F2 " OF oTable TABLEATTACH 1,2,0,1
    DEFINE LABEL PROMPT cF2 EXPAND OF oTable TABLEATTACH 1,2,1,2
    DEFINE LABEL PROMPT " F3 " OF oTable TABLEATTACH 2,3,0,1
    DEFINE LABEL PROMPT cF3 EXPAND OF oTable TABLEATTACH 2,3,1,2
    DEFINE LABEL PROMPT " F4 " OF oTable TABLEATTACH 3,4,0,1
    DEFINE LABEL PROMPT cF4 EXPAND OF oTable TABLEATTACH 3,4,1,2
    DEFINE LABEL PROMPT " F5 " OF oTable TABLEATTACH 4,5,0,1
    DEFINE LABEL PROMPT cF5 EXPAND OF oTable TABLEATTACH 4,5,1,2
    DEFINE LABEL PROMPT " F6 " OF oTable TABLEATTACH 5,6,0,1
    DEFINE LABEL PROMPT cF6 EXPAND OF oTable TABLEATTACH 5,6,1,2
    DEFINE LABEL PROMPT " F7 " OF oTable TABLEATTACH 6,7,0,1
    DEFINE LABEL PROMPT cF7 EXPAND OF oTable TABLEATTACH 6,7,1,2
    DEFINE LABEL PROMPT " F8 " OF oTable TABLEATTACH 7,8,0,1
    DEFINE LABEL PROMPT cF8 EXPAND OF oTable TABLEATTACH 7,8,1,2
    DEFINE LABEL PROMPT " F9 " OF oTable TABLEATTACH 8,9,0,1
    DEFINE LABEL PROMPT cF9 EXPAND OF oTable TABLEATTACH 8,9,1,2
    DEFINE LABEL PROMPT " F10 " OF oTable TABLEATTACH 9,10,0,1
    DEFINE LABEL PROMPT cF10 EXPAND OF oTable TABLEATTACH 9,10,1,2
    DEFINE LABEL PROMPT " F11 " OF oTable TABLEATTACH 10,11,0,1
    DEFINE LABEL PROMPT cF9 EXPAND OF oTable TABLEATTACH 10,11,1,2
    DEFINE LABEL PROMPT " F12 " OF oTable TABLEATTACH 11,12,0,1
    DEFINE LABEL PROMPT cF10 EXPAND OF oTable TABLEATTACH 11,12,1,2

  else

    DEFINE BOX oBox1 OF oBox

    DEFINE LABEL PROMPT " F1 " OF oBox1
    DEFINE LABEL PROMPT cF1 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F2 " OF oBox1
    DEFINE LABEL PROMPT cF2 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F3 " OF oBox1
    DEFINE LABEL PROMPT cF3 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F4 " OF oBox1
    DEFINE LABEL PROMPT cF4 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F5 " OF oBox1
    DEFINE LABEL PROMPT cF5 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F6 " OF oBox1
    DEFINE LABEL PROMPT cF6 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F7 " OF oBox1
    DEFINE LABEL PROMPT cF7 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F8 " OF oBox1
    DEFINE LABEL PROMPT cF8 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F9 " OF oBox1
    DEFINE LABEL PROMPT cF9 EXPAND OF oBox1
    DEFINE LABEL PROMPT " F10 " OF oBox1
    DEFINE LABEL PROMPT cF10 EXPAND OF oBox1
  end

RETURN nil
