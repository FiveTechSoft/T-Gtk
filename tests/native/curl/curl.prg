/*
 * $Id: curl.prg,v 1.1 2009-01-27 19:35:27 riztan Exp $
 * Ejemplo de uso de CURL
 * Porting libcurl to T-GTK power!
 * (C) 2009. Rafa Carmona -TheFull-
 * (C) 2009. Riztan Gutierrez 
*/
#include "gtkapi.ch"
#include "curl.ch"

function Main(  )

  Local pCurl, nRes, hFile, aHeader, cUser, cPasswd

  cUser   := "USUARIO"
  cPasswd := "PASSWORD"  
  
/*  Esperando a que funcione correctamente el pasar el archivo como parámetro a 
 *  la funcion  */
  hFile   := file_open( "return.xml" )
  
  aHeader :={;
  "Host: mail.google.com",;
  "User-Agent: Mozilla/5.0 (X11; U; Linux i686; es-AR; rv:1.9.0.5) Gecko/2008121621 Ubuntu/8.04 (hardy) Firefox/3.0.5",;
  "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",;
  "Accept-Language: es-ar,es;q=0.8,en-us;q=0.5,en;q=0.3",;
  "Accept-Encoding: gzip,deflate",;
  "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7",;
  "Date: "+CStr(DATE());
  }
  
  pCurl := curl_easy_init()
  MsgInfo( curl_version() )
  
  curl_easy_setopt( pCurl, CURLOPT_URL , "https://mail.google.com/mail/feed/atom" )

//  curl_easy_setopt( pCurl, CURLOPT_HTTPAUTH , CURLAUTH_ANY )

  curl_easy_setopt( pCurl, CURLOPT_HTTPHEADER , aHeader )
  curl_easy_setopt( pCurl, CURLOPT_AUTOREFERER , 1 )
  curl_easy_setopt( pCurl, CURLOPT_FOLLOWLOCATION , .T. )
  curl_easy_setopt( pCurl, CURLOPT_SSL_VERIFYPEER , 0 )
  curl_easy_setopt( pCurl, CURLOPT_SSL_VERIFYHOST , 1 )
  curl_easy_setopt( pCurl, CURLOPT_USERPWD , cUser+":"+cPasswd )
  
//    curl_easy_setopt(pcurl, CURLOPT_WRITEFUNCTION, hola() )
//    curl_easy_setopt(pcurl, CURLOPT_NOPROGRESS, .T.)
//    curl_easy_setopt(pcurl, CURLOPT_PROGRESSFUNCTION, progress() )

  
  curl_easy_setopt( pCurl, CURLOPT_WRITEDATA , hFile ) 
  
  nRes := curl_easy_perform( pCurl )
  If nRes != CURLE_OK
     MsgStop( curl_easy_strerror(nRes) )
     file_close( hFile )
     quit
  EndIf

  MsgInfo( curl_easy_strerror(nRes) , "perform" )
  
  curl_easy_cleanup( pCurl )
  
  If file_close( hFile ) != 0
     MsgStop( "No pudo cerrar el archivo" )
  EndIf
  

return nil



Function hola()
   MsgInfo( "PCOUNT "+CStr(PCOUNT()) ,"Hola" )
return 

Function progress()
   MsgInfo( "PCOUNT "+CStr(PCOUNT()), "Progress" )
return
