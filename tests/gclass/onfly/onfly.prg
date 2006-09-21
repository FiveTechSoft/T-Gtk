#include "gclass.ch"

Static s_aWidgets := {} // Content widgets for create and destroy

REQUEST MsgInfo

Function Main( )
    Local oWindow, oBox, oBtn

    DEFINE WINDOW oWindow TITLE "Create and Destroy ON FLY"
         DEFINE BOX oBox VERTICAL OF oWindow
            DEFINE BUTTON oBtn TEXT "Create"  ACTION CreateButtons( oBox ) OF oBox
            DEFINE BUTTON oBtn TEXT "Destroy" ACTION DestroyButtons( ) OF oBox

    ACTIVATE WINDOW oWindow CENTER

Return NIL

// Ejemplo de como crear una action por cada boton en tiempo de ejecucion
Function CreateButtons( oBox )
    Local x, oBtn 

    if Empty( s_aWidgets  )
       For x := 1 TO 10
           DEFINE BUTTON oBtn TEXT "Button " + str( x, 2 ) OF oBox
                  oBtn:Connect( "clicked" )
                  oBtn:bAction :=  &( "{|o|"+ "MsgInfo( cValToChar( " + str( X,2 )+ " ))}")
           AADD( s_aWidgets , oBtn )
       Next
    endif

RETURN NIL

Function DestroyButtons( )
    Local x, oBtn 

    if !Empty( s_aWidgets  )
       For x := 1 TO 10
           s_aWidgets[x]:End()
       Next
       s_aWidgets := {}
    endif

 Return NIL
