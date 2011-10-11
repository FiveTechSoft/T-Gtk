/*
 * $Id: netiot02.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Harbour Project source code:
 *    demonstration/test code for RPC in NETIO
 *
 * Copyright 2010 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * www - http://harbour-project.org
 *
 */


/* to execute this code run server (netiosrv) on the same machine
 * with support for RPC and "topsecret" password, i.e.:
 *    netiosrv "" "" "" 1 topsecret
 * then you can try to execute this code.
 * If you want to execute remotely any core functions then
 * uncomment this like in netiosrv.prg:
 *    REQUEST __HB_EXTERN__
 * and rebuild it or link netiosrv with Harbour dynamic library
 * (-shared hbmk2 switch)
 */


/* few PP rules which allow to execute RPC function using
 * pseudo object 'net', i.e. ? net:date()
 */
#xtranslate net:<!func!>([<params,...>]) => ;
            netio_funcexec( #<func> [,<params>] )
#xtranslate net:[<server>]:<!func!>([<params,...>]) => ;
            netio_funcexec( [ #<server> + ] ":" + #<func> [,<params>] )
#xtranslate net:[<server>]:<port>:<!func!>([<params,...>]) => ;
            netio_funcexec( [ #<server> + ] ":" + #<port> + ":" + #<func> ;
                            [,<params>] )

#xtranslate net:exists:<!func!> => ;
            netio_procexists( #<func> )
#xtranslate net:exists:[<server>]:<!func!> => ;
            netio_procexists( [ #<server> + ] ":" + #<func> )
#xtranslate net:exists:[<server>]:<port>:<!func!> => ;
            netio_procexists( [ #<server> + ] ":" + #<port> + ":" + #<func> )


#include "gclass.ch"

/* address of computer executing netiosrv,
 * change it if it's not the same machine
 */
#define NETSERVER  "riztan.dyndns.org" //"190.202.185.229" //"riztan.dyndns.org" //"127.0.0.1"
#define NETPORT    2941
#define NETPASSWD  "topsecret"

memvar oFixed

proc main()

   LOCAL oWnd //,oFixed

   SET DATE ANSI
   SET CENTURY ON

   DEFINE WINDOW oWnd Title "demonstration/test code for RPC in NETIO with T-Gtk!" ;
          SIZE 400,300

   DEFINE FIXED oFixed OF oWnd

   /* connect to the server */
   //? "CONNECTING... Server:"+NETSERVER
//   DEFINE LABEL POS 40,10 ;
//          TEXT "CONNECTING... Server: "+NETSERVER OF oFixed

   DEFINE LABEL POS 10,50 TEXT "NETIO_CONNECT(): " OF oFixed
   DEFINE LABEL POS 10,70 TEXT "DATE() function is supported:" OF oFixed
   DEFINE LABEL POS 10,90 TEXT "QOUT() function is supported:" OF oFixed
   DEFINE LABEL POS 10,110 TEXT "HB_DATETIME() function is supported:" OF oFixed

   DEFINE BUTTON POS 40,10 ;
          TEXT "Conectar" ;
          ACTION Connect() OF oFixed

   ACTIVATE WINDOW oWnd CENTER


//  netio_disconnect( NETSERVER, NETPORT )
return


proc Connect()

   //? "NETIO_CONNECT():", netio_connect( NETSERVER, NETPORT,, NETPASSWD )
   DEFINE LABEL POS 280,50 ;
          TEXT CStr(netio_connect( NETSERVER, NETPORT,, NETPASSWD )) OF oFixed
   //?
   /* check if some function are available on server side */
   //? "DATE() function is supported:",        net:exists:DATE
   DEFINE LABEL POS 280,70 ;
          TEXT CStr(net:exists:DATE) OF oFixed

   //? "QOUT() function is supported:",        net:exists:QOUT
   DEFINE LABEL POS 280,90 ;
          TEXT CStr(net:exists:QOUT) OF oFixed

   //? "HB_DATETIME() function is supported:", net:exists:HB_DATETIME
   DEFINE LABEL POS 280,110 ;
          TEXT ValToPrg(net:exists:HB_DATETIME) OF oFixed

   //?
   /* display text on server console */
   net:QOUT( repl( "=", 70 ) )
   net:QOUT( "This is RPC TEST with T-Gtk", hb_datetime(), version() )
   net:QOUT( repl( "=", 70 ) )


   /* execute some functions on the server side and display the results */
   //? "SERVER DATE:",     net:DATE()
   DEFINE LABEL POS 40,130 ;
          TEXT "Server DATE(): "+DTOC(net:DATE()) OF oFixed

   //? "SERVER TIME:",     net:TIME()
   DEFINE LABEL POS 40,150 ;
          TEXT "Server TIME(): "+CStr(net:Time()) OF oFixed

   //? "SERVER DATETIME:", net:HB_DATETIME()
   DEFINE LABEL POS 40,170 ;
          TEXT "Server DATETIME(): "+CSTR(net:HB_DATETIME()) OF oFixed

   //? net:upper( "hello world !!!" )
   DEFINE LABEL POS 40,190 ;
          TEXT "Server Upper('hello world !!!'): "+CStr(net:UPPER('hello world !!!')) OF oFixed

   //?

   /* close the connection to the server */
   //? "NETIO_DISCONNECT():", netio_disconnect( NETSERVER, NETPORT )
   DEFINE LABEL POS 40,210 ;
          TEXT "NETIO_DISCONNECT(): "+CStr(netio_disconnect( NETSERVER, NETPORT) ) OF oFixed

return
