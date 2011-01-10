/* $Id: brw_glade.prg,v 1.1 2006-09-11 16:48:16 xthefull Exp $*/
/** 
 * brw_glade.prg - Browse arrays & gclass under Glade (by TheFull)
 * Copyright (C) 2005 Joaquim Ferrer Godoy <quim_ferrer@yahoo.es>
 **/

#include "gclass.ch"

function main()

  local oWnd, oBrw1, oBrw2, oBox1, oBox2, cRes
  local aColSpa := { "rojo", " blanco", "amarillo", "verde", "marron", "rosa", ;
                     "negro", "naranja", "gris", "lila", "azul", "fucsia" }
  local aColCat := { "roig", "blanc", "groc", "vert", "marro", "rosa", ;
                     "negre", "taronge", "gris", "lila", "blau", "fucsia" }
  local aColEng := { "red", "white", "yellow", "green", "brown", "pink", ;
                     "black", "orange", "gray", "purple", "blue", "#FF00FF" }
  local aNumber := { { 1,2,3,4,5,6,7,8,9,10,11,12 } }
  
  local aNumSpa := { "Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis",;
                     "Siete", "Ocho", "Nueve", "Diez", "Once", "Doce" }
  local aNumCat := { "U", "Dos", "Tres", "Quatre", "Cinc", "Sis", ;
                     "Set", "Vuit", "Nou", "Deu", "Onze", "Dotze"     }
  local aNumEng := { "One", "Two", "Three", "Four", "Five", "Six", ;
                     "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve" }
  local aDays   := { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
   
 set resources cRes from file "test_browse.glade"
  
   define window oWnd id "window1" resource cRes
    
    define toolbutton id "toolbutton4" resource cRes action oWnd:End()

    define box oBox1 id "hbox1" resource cRes
      
        DEFINE BROWSE oBrw1 ;
               HEADERS "Number" ;
               COLSIZES 50;                
               OF oBox1 EXPAND FILL ;
               COLORS "red" ;
               ON CHANGE ( oBrw2:SetArray( { { aNumSpa[oBrw1:nAt], aColSpa[oBrw1:nAt] }, ;
                                             { aNumCat[oBrw1:nAt], aColCat[oBrw1:nAt] }, ;
                                             { aNumEng[oBrw1:nAt], aColEng[oBrw1:nAt] } } ),; 
                           oBrw2:Refresh() )
   
          ADD COLUMN TO BROWSE oBrw1 ;
               DATA "";
               HEADER "Colors" ;
               COLOR "red", {|| aColEng[ oBrw1:nAt ] } ;
               SIZE 70
   
          atail( oBrw1:aColumns ):lDrawSelect := .f.
 
          ADD COLUMN TO BROWSE oBrw1 ;
               DATA {|| aDays[oBrw1:nAt] };
               HEADER "Months/Days" ;
               HEADER_PICTURE "../../images/browse.png" ;
               COLOR {|| if( oBrw1:nAt %2 <> 0, "red", "green" ) }, ;
                     {|| if( oBrw1:nAt %2 <> 0, "gray", "white" ) } ;
               SIZE 80
         
	        oBrw1:SetArray( aNumber )
                       
        DEFINE BROWSE oBrw2 ;
               HEADERS "Spanish", "Catalan", "English" ;  
               COLSIZES 70,70,70 ;                
               OF oBox1      EXPAND FILL ;
               COLORS "black"
                                             
        oBrw2:lArrow := .f.
        oBrw2:aColumns[ 2 ]:cfgColor = "#FFD700"
        oBrw2:aColumns[ 2 ]:cbgColor = "#1E90FF"       
        oBrw2:SetArray( { { aNumSpa[oBrw1:nAt], aColSpa[oBrw1:nAt] }, ;
                          { aNumCat[oBrw1:nAt], aColCat[oBrw1:nAt] }, ;
                          { aNumEng[oBrw1:nAt], aColEng[oBrw1:nAt] } } ) 
                                
  ACTIVATE WINDOW oWnd CENTER 

return nil
