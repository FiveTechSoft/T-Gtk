/**
 * tgtk-Mysql - Ejemplo de conexion con T-Gtk y MySql
 * Copyright (C) 2006 Rafa Carmona
 * 
   Atencion, este ejemplo solamente funcionara con XHARBOUR.
   Se a puesto para que podais observar como podeis montar un browse
   con MySql y como podeis editarlos.
   
   ATENTOS, este ejemplo es con fines didacticos, lo cual implica que
   puede hacer varias maneras de hacer lo mismo, esta es una de ellas.
 
   Notas para compilacion:
   Para poder compilar el ejemplo, debeis de crear la libreria libmysql.a
   a partir de la DLL de MySql.
   
   Y crear la libreria para xHarbour, que teneis en src/mysql ,
  ( es la de /xharbour/contrib ), simplemente con make.
   
   Copiarlas al directorio de las librerias de TGTK
   
 *
 **/

#include "gclass.ch"

Function Main()
   Local oServer, X , oWnd, oTreeview, oModel, oQuery2, oCol
   Local animals := { "cat", "dog", "bird", "horse" }
   
   oServer := TMySQLServer():New("localhost", "root", "cgg378" )
   
   if oServer:NetErr()
      MsgStop( oServer:Error() )
   endif
   
   if !oServer:DBExist( "zoo" )
      oServer:CreateDatabase( "zoo" )
   endif
   
   oServer:SelectDB( "zoo" )

   if !oServer:TableExist( "animals" )
       oServer:CreateTable( "animals", { { "Pk_ID" , "N",  4, 0 },;    // PK    // AUTO_INC
                                         { "Name"  , "C", 50, 0 } } , "Pk_ID",, "Pk_ID")

       // Vamos a introducir datos...
       oQuery2 := oServer:Query("SELECT * from animals LIMIT 1", .F. )   
       WITH OBJECT oQuery2        
            for x := 1 TO 4
                :GetBlankRow( )
                :NAME := animals[ x ]
                if !:Append()           // Orden de agregar (INSERT) los datos del registro actual.
                    Alert(:Error())
                endif
            next
       END WITH
   endif

   //Ahora vamos mostrar esos datos que hemos introducido.
   DEFINE WINDOW oWnd TITLE "MySql from T-Gtk...."
     
     // Llenamos el modelo de datos, a traves de los datos de MySql
     oModel := Create_Model( oServer )
     
     // Creamos la vista
     DEFINE TREEVIEW oTreeView MODEL oModel OF oWnd CONTAINER
       
       // Y ahora vamos a definir como vamos a mostrar esos datos.
       DEFINE TREEVIEWCOLUMN COLUMN 1 TITLE "PK_ID" TYPE "text"   OF oTreeView

       // Ademas , a esta columna vamos a permitir cosas...
       DEFINE TREEVIEWCOLUMN oCol COLUMN 2 TITLE "NAME" TYPE "text" SORT OF oTreeView
         oCol:SetResizable( .T. )            // Permitimos que sea redimensionable
         oCol:oRenderer:SetEditable( .T. )   // Vamos a hacer que sea Editable
         oCol:oRenderer:Connect( "edited" )  // Conectamos signal, y asignamos el codeblock a evaluarse.
         oCol:oRenderer:bEdited := {|o,path,cNewText| Edita_Celda( oTreeView, oModel, oServer, path, cNewText ) }

   ACTIVATE WINDOW oWnd CENTER



   oServer:Destroy()

RETURN NIL

// Introducimos los valores de la tabla en el modelo de datos.
STATIC FUNCTION Create_Model( oServer )
   Local oQuery, oLbx
   oQuery := oServer:Query( "SELECT * from animals", .F. )
   
   DEFINE LIST_STORE oLbx TYPES G_TYPE_INT, G_TYPE_STRING
   
   do while !oQuery:Eof()
      APPEND LIST_STORE oLbx VALUES oQuery:pk_ID, oQuery:NAME
      oQuery:skip()
   enddo

RETURN oLbx

// Vamos a editar la celda, y guardar el valor en la tabla y en el modelo de datos.
STATIC FUNCTION Edita_Celda( oTreeView ,oLbx, oServer, cPath, cNewText )
  Local path, aIter := Array( 4 )
  Local nId, oQuery

  path := gtk_tree_path_new_from_string( cPath )
  
  // Obtenemos el valor de la columna en la vista
  nId := oTreeView:GetValue( 1, "Int", Path, @aIter ) 
   
  // Vamos a guardar el valor en la tabla
  // Lo fuerzo de esta manera, porque la alternativa, no me funciona
  sqlQuery( oServer:nSocket, 'UPDATE animals SET name = "' + cNewText + '"'+; 
                            ' WHERE PK_ID = "' + Str( nId )+ '"' )
  
  // Esto deberia funcionar... pero NO FUNCIONA!!
  /*
  oQuery := oServer:Query("SELECT * from animals where PK_ID=" + alltrim( str( nId ) ), .f. )
  WITH OBJECT oQuery
       :GetRow()
       if :LastRec() > 0
          :NAME  := cNewText
          if !:Update()      // Orden de actualizar los datos del registro actual.--> No da error, pero no actualiza..
              Msginfo( :Error() )
          endif
       endif
  END WITH
  */

   /* set new value, en el modelo de datos*/
  oLbx:Set( aIter, 2, cNewText )
  
  /* clean up */
  gtk_tree_path_free( path )

RETURN NIL


/*
# Esto es tal y como se realiza con MySql... 
# Vean la diferencia... sigo pensando que es un error intentar simular
# el comportamiento de MySql como si fuese una DBF... pero en fin....

CREATE DATABASE `zoo` 
USE `zoo`;

#
# Table structure for table animals
#
CREATE TABLE `animals` (
  `Pk_ID` smallint(4) NOT NULL auto_increment,
  `Name` char(50) default NULL,
  PRIMARY KEY  (`Pk_ID`)
) 

# Append values
INSERT INTO `animals` VALUES (1,'cat');
INSERT INTO `animals` VALUES (2,'dog');
INSERT INTO `animals` VALUES (3,'bird');
INSERT INTO `animals` VALUES (4,'horse');

*/

