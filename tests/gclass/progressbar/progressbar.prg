#include "gclass.ch"

FUNCTION Main()
   LOCAL oWnd, oPBr, oBtn
   LOCAL nVar := 0, cFileRes, cResource

   cFileRes := "pruebas.glade"

   SET RESOURCES cResource FROM FILE cFileRes ROOT "wndMain"

   DEFINE WINDOW oWnd ID "wndMain" RESOURCE cResource

      DEFINE PROGRESSBAR oPBr ;
         VAR nVar TOTAL 1 ;
         ID "progressbar1" RESOURCE cResource

      DEFINE BUTTON oBtn ;
         ACTION Indexa(oPbr) ;
         ID "button1" RESOURCE cResource

      oWnd:bInit := Indexa(oPBr)

   ACTIVATE WINDOW oWnd CENTER CENTER

   RETURN NIL

FUNCTION Indexa(oPBr)
  LOCAL nTotal, nContador := 0

  USE ../../CUSTOMER.DBF NEW ALIAS CLIENTES
  
  while LastRec() < 2000
     DbAppend()
  end

  nTotal := LastRec()
  
  * Datos para el ProgressBar
  oPBr:SetTotal( nTotal )
  oPBr:SetValue( 1 )

  INDEX ON FIELD->Last TO GVS ;
      EVAL {|| oPBr:Set( nContador ), SysRefresh(), nContador += INT( nTotal / 100 ), .T. } ;
      EVERY nTotal / 100

  MsgInfo("¡¡Finish!!")
  oPBr:SetValue( 0 )
  DBCLOSEAREA()

  RETURN NIL
