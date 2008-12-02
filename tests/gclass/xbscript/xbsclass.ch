/*
 * $Id: xbsclass.ch,v 1.1 2008-12-02 21:37:48 riztan Exp $
 */

/*
 * Harbour Project source code:
 * Header file for Class commands
 *
 * Copyright 1999 Antonio Linares <alinares@fivetech.com>
 * www - http://www.harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

/*
 * The following parts are Copyright of the individual authors.
 * www - http://www.harbour-project.org
 *
 * Copyright 2000 ( ->07/2000 ) JF. Lefebvre <jfl@mafact.com> & RA. Cuylen <rac@mafact.com>
 *    Support for Class(y), TopClass and Visual Object compatibility
 *    Support for MI (multiple inheritance),

 * Copyright 2000-2001 ( 08/2000-> ) JF. Lefebvre <jfl@mafact.com>
 *    Scoping (Protect, Hidden and Readonly),
 *    Delegating, DATA Shared
 *    Support of 10 Chars limits
 *
 * See doc/license.txt for licensing terms.
 *
 */

#ifndef HB_CLASS_CH_
#define HB_CLASS_CH_

#translate ( ... ) => ()
#translate __ClsSetModule( <x> ) =>

#include "hbsetup.ch"
#include "hboo.ch"

/* You can actually define one or all the syntax, they do not collide each other */
/* There is some difference with their original form and I hope I will have enough */
/* time to document it <g> */
/* This is work in progress ... */
/* FWOBJECT AND CLASSY compatibility are the base of this work */
/* VO is just here as I like it's way of */
/* instanciating object but there is only a very few VO keywords here :-( */
/* TOPCLASS is better implemented because I like the way some Classy command */
/* are simplified */
/* There is also a big common block extending in fact each of the four base syntax */
/* it seem actually impossible to completely separate it without creating */
/* four differents include file (what I would not see in fact ) */

/* There is also two compatibility define you can use */
/* HB_CLS_NOTOBJECT wich IF DEFINED, disable the auto inherit of HBObject */
/* (wich in fact also disable the classy compatibility :new(...) => :Init(...)  */
/* HB_CLS_NOAUTOINIT wich disable the (VO like) AutoInit for Logical and Numeric */
/* when not specifically initiated */
/* These two are disabled by default */
/* So Each class _inherit_ of HBObject by default and */
/*    Each type logical or numerical is initiated to .F. and 0 by default */

/* #define HB_CLS_NOTOBJECT  */ /* Should be included in some compatibility include files as needed */
/* #define HB_CLS_NOAUTOINIT */ /* Idem */
/* #define HB_CLS_ALLOWCLASS */ /* Work in progress, don't define it now */
/* #define HB_CLS_ENFORCERO FLAG to disable Write access to RO VAR outside */
/*         of Constructors /!\ Could be related to some incompatibility */

DECLARE HBClass ;
        New( cName AS String, OPTIONAL SuperParams ) AS CLASS HBClass ;
        Create() AS Object ;
        Instance() AS Object ;
        AddClsMethod( cName AS String, @MethodName(), nScope AS Numeric, n2 AS Numeric, n3 AS Numeric ) ;
        AddMultiClsData( cType AS String, uVal, nScope AS Numeric, aDatas AS Array OF String ) ;
        AddMultiData( cType AS String, uVal, nScope AS Numeric, aDatas AS Array OF String, x AS LOGICAL, lPer AS LOGICAL ) ;
        AddMethod( cName AS String, @MethodName(), nScope AS Numeric, lPersistent AS LOGICAL ) ;
        AddInLine( cName AS String, bBlock AS CodeBlock, nScope AS Numeric, lPersistent AS LOGICAL ) ;
        AddVirtual( cName AS String )

#xtranslate __ERR([<msg,...>]) => #error [<msg>]

/*
   TOO General, was matching:

   &( MacroFunc )()

   Commented and replaced with the more specific trailing 2 rules.
*/
//#xtranslate )() => )
#xcommand _HB_MEMBER <MethodName>([<params,...>])() [<*x*>] => _HB_MEMBER <MethodName>(<params>) <x>
#xtranslate @<!funcname!>([<params,...>])() => @<funcname>(<params>)

#ifdef HB_CLS_NOTOBJECT
 #define __HB_CLS_PAR  __CLS_PAR00
#else
 #define __HB_CLS_PAR  __CLS_PARAM
#endif

#ifdef HB_CLS_NOAUTOINIT
 #define __HB_CLS_NOINI .T.
#else
 #define __HB_CLS_NOINI .F.
#endif

#ifndef HB_CLS_FWO
#ifndef HB_CLS_CSY
#ifndef HB_CLS_VO
#ifndef HB_CLS_TOP
#ifndef HB_CLS_XB

 /* IF NOTHING DECIDED BY THE PROGRAMER USE ALL */
#define HB_CLS_FWO
#define HB_CLS_CSY
#define HB_CLS_VO
#define HB_CLS_TOP
#define HB_CLS_XB

#endif
#endif
#endif
#endif
#endif

//#xtranslate HBCLSCHOICE( <publish> <export>, <protect>, <hidde> ) => iif( <export>, HB_OO_CLSTP_EXPORTED , iif( <export>, HB_OO_CLSTP_EXPORTED , iif( <protect>, HB_OO_CLSTP_PROTECTED, iif( <hidde>, HB_OO_CLSTP_HIDDEN, nScope) ) ) )
#xtranslate HBCLSCHOICE( <x,...> ) => ;__ERR( Can not use multiple scope qualifiers! );;

#xtranslate HBCLSCHOICE( .T., .F., .F., .F. ) => HB_OO_CLSTP_PUBLISHED
#xtranslate HBCLSCHOICE( .F., .F., .T., .F. ) => HB_OO_CLSTP_PROTECTED
#xtranslate HBCLSCHOICE( .F., .F., .F., .T. ) => HB_OO_CLSTP_HIDDEN
#xtranslate HBCLSCHOICE( .F., .T., .F., .F. ) => HB_OO_CLSTP_EXPORTED
#xtranslate HBCLSCHOICE( .F., .F., .F., .F. ) => nScope  // Default

/* CLASSY SYNTAX */
#IFDEF HB_CLS_CSY
#xtranslate CREATE CLASS => CLASS
#xtranslate _HB_MEMBER {AS Num  => _HB_MEMBER {AS Numeric
#xtranslate _HB_MEMBER {AS Char => _HB_MEMBER {AS Character
#endif

// Extend Classes
#xcommand OVERRIDE METHOD <!Message!> [IN] CLASS <!Class!> WITH [METHOD] <!Method!> [SCOPE <Scope>] => ;
  <Class>(); __clsModMsg( __ClsGetHandleFromName( #<Class> ), #<Message>, @<Method>(), IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ) )

#xcommand EXTEND CLASS <!Class!> WITH <data: DATA, VAR> <Data> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  <Class>(); __clsAddMsg( __ClsGetHandleFromName( #<Class> ), <(Data)>, __cls_IncData( __ClsGetHandleFromName( #<Class> ) ), HB_OO_MSG_PROPERTY, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <!Class!> WITH METHOD <!Method!> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  <Class>(); __clsAddMsg( __ClsGetHandleFromName( #<Class> ), #<Method>, @<Method>(), HB_OO_MSG_METHOD, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <!Class!> WITH MESSAGE <Message> METHOD <!Method!> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  <Class>(); __clsAddMsg( __ClsGetHandleFromName( #<Class> ), <(Message)>, @<Method>(), HB_OO_MSG_METHOD, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <!Class!> WITH MESSAGE <Message> INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  <Class>(); __clsAddMsg( __ClsGetHandleFromName( #<Class> ), <(Message)>, {|Self| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <!Class!> WITH MESSAGE <Message>( <params,...> ) INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  <Class>(); __clsAddMsg( __ClsGetHandleFromName( #<Class> ), <(Message)>, {|Self, <params>| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

// EXTEND native type classes.
#xcommand OVERRIDE METHOD <!Message!> [IN] CLASS <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH [METHOD] <!Method!> [SCOPE <Scope>] => ;
  _<type>(); __clsModMsg( __ClsGetHandleFromName( #<type> ), <(Message)>, @<Method>(), IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ) )

#xcommand EXTEND CLASS <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH <data: DATA, VAR> <Data> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  _<type>(); __clsAddMsg( __ClsGetHandleFromName( #<type> ), <(Data)>, __cls_IncData( __ClsGetHandleFromName( #<type> ) ), HB_OO_MSG_PROPERTY, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH METHOD <!Method!> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  _<type>(); __clsAddMsg( __ClsGetHandleFromName( #<type> ), #<Method>, @<Method>(), HB_OO_MSG_METHOD, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH MESSAGE <Message> METHOD <!Method!> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  _<type>(); __clsAddMsg( __ClsGetHandleFromName( #<type> ), <(Message)>, @<Method>(), HB_OO_MSG_METHOD, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER,  HASH> WITH MESSAGE <Message> INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  _<type>(); __clsAddMsg( __ClsGetHandleFromName( #<type> ), <(Message)>, {|Self| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND CLASS <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH MESSAGE <Message>( <params,...> ) INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  _<type>(); __clsAddMsg( __ClsGetHandleFromName( #<type> ), <(Message)>, {|Self, <params>| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

// Extend native type (NOT using standard classes)
#xcommand EXTEND [TYPE] <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH METHOD <!Method!> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  __clsAddMsg( __ClsGetHandleFromName( #<type> ), #<Method>, @<Method>(), HB_OO_MSG_METHOD, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND [TYPE] <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH MESSAGE <Message> METHOD <!Method!> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  __clsAddMsg( __ClsGetHandleFromName( #<type> ), <(Message)>, @<Method>(), HB_OO_MSG_METHOD, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND [TYPE] <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH MESSAGE <Message> INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  __clsAddMsg( __ClsGetHandleFromName( #<type> ), <(Message)>, {|Self| <code>}, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND [TYPE] <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> WITH MESSAGE <Message>(<params,...>) INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  __clsAddMsg( __ClsGetHandleFromName( #<type> ), <(Message)>, {|Self, <params>| <code>}, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

// ENABLE
#xcommand ENABLE TYPE CLASS <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> [, <typeN: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH>] => _<type>() [;_<typeN>()]
#xcommand ENABLE TYPE CLASS ALL => _Array(); _Block(); _Character(); _Date(); _Logical(); _Nil(); _Numeric(); _Pointer(); _Hash()

#xcommand ASSOCIATE CLASS <ClassName> WITH TYPE <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> => ;
  __clsAssocType( IIF( __ClsGetHandleFromName( <(ClassName)> ) == 0, <ClassName>():ClassH, __ClsGetHandleFromName( <(ClassName)> ) ), #<type> )

#xcommand EXTERNAL <type: ARRAY, BLOCK, CHARACTER, DATE, LOGICAL, NIL, NUMERIC, POINTER, HASH> [, <*rest*>] => _<type>() [; EXTERNAL <rest>]

#ifdef HB_CLS_ALLOWCLASS  /* DONT DECLARE IT ! WORK IN PROGRESS !!! */

#ifndef HB_SHORTNAMES

#xtranslate DECLMETH <ClassName> <MethodName> => <ClassName>_<MethodName>

#xcommand CLASS <ClassName> [METACLASS <metaClass>] [ <frm: FROM, INHERIT> <SuperClass1> [,<SuperClassN>] ] [<static: STATIC>] => ;
   _HB_CLASS <ClassName> ;;
   <static> function <ClassName>(...) ;;
      static s_oClass ;;
      local MetaClass,nScope ;;
      [ REQUEST <SuperClass1> ] [ ,<SuperClassN> ] ;;
      nScope := HB_OO_CLSTP_EXPORTED ;;
      if s_oClass == NIL ;;
         s_oClass  := IIF(<.metaClass.>, <(metaClass)>, HBClass():new( <(ClassName)> , __HB_CLS_PAR ( [ <(SuperClass1)> ] [ ,<(SuperClassN)> ] ) ) ) ;;
         if ! <.metaClass.> ;;
          Metaclass := HBClass():new( <(ClassName)>+" class", __HB_CLS_PAR0 ( [ <SuperClass1>():class ] [ ,<SuperClassN>():class ] ) )  ;;
         endif              ;;
     #undef  _CLASS_NAME_ ;;
     #define _CLASS_NAME_ <ClassName> ;;
     #undef  _CLASS_MODE_ ;;
     #define _CLASS_MODE_ _CLASS_DECLARATION_ ;;
     #untranslate CLSMETH ;;
     #untranslate DECLCLASS ;;
     #xtranslate CLSMETH <ClassName> \<MethodName> => @<ClassName>_\<MethodName> ;;
     #xtranslate DECLCLASS <ClassName> => <ClassName> ;
     ; #xuntranslate Super() : ;
     ; #xuntranslate Super : ;
     ; #xuntranslate : Super : ;
     [ ; #translate Super( <SuperClassN> ) : => ::<SuperClassN>: ] ;
     ; #translate Super( <SuperClass1> ) : => ::<SuperClass1>: ;
     ; #translate Super() : => ::<SuperClass1>: ;
     ; #translate Super : => ::<SuperClass1>: ;
     ; #translate : Super : => :<SuperClass1>:

#else

#xcommand CLASS <ClassName> [METACLASS <metaClass>] [ <frm: FROM, INHERIT> <SuperClass1> [,<SuperClassN>] ] [<static: STATIC>] => ;
   _HB_CLASS <ClassName> ;;
   <static> function <ClassName>(...) ;;
      static s_oClass  ;;
      local MetaClass,nScope ;;
      [ REQUEST <SuperClass1> ] [ ,<SuperClassN> ] ;;
      nScope := HB_OO_CLSTP_EXPORTED ;;
      if s_oClass == NIL ;;
         s_oClass  := IIF(<.metaClass.>, <(metaClass)>, HBClass():new( <(ClassName)> , __HB_CLS_PAR ( [ <(SuperClass1)> ] [ ,<(SuperClassN)> ] ) ) ) ;;
         if ! <.metaClass.> ;;
          Metaclass := HBClass():new( <(ClassName)>+" class", __HB_CLS_PAR0 ( [ <SuperClass1>():class ] [ ,<SuperClassN>():class ] ) )  ;;
         endif              ;;
     #undef  _CLASS_NAME_ ;;
     #define _CLASS_NAME_ <ClassName> ;;
     #undef  _CLASS_MODE_ ;;
     #define _CLASS_MODE_ _CLASS_DECLARATION_ ;;
     #untranslate CLSMETH ;;
     #translate CLSMETH <ClassName> \<MethodName>() => @\<MethodName> ;
     ; #xuntranslate Super() : ;
     ; #xuntranslate Super : ;
     ; #xuntranslate : Super : ;
     [ ; #translate Super( <SuperClassN> ) : => ::<SuperClassN>: ] ;
     ; #translate Super( <SuperClass1> ) : => ::<SuperClass1>: ;
     ; #translate Super() : => ::<SuperClass1>: ;
     ; #translate Super : => ::<SuperClass1>: ;
     ; #translate : Super : => :<SuperClass1>:

#endif /* HB_SHORTNAMES */

#else

#ifndef HB_SHORTNAMES

#xtranslate DECLMETH <ClassName> <MethodName> => <ClassName>_<MethodName>

#xcommand CLASS <ClassName> [METACLASS <metaClass>] [ <frm: FROM, INHERIT> <SuperClass1> [,<SuperClassN>] ] [<static: STATIC>] => ;
   _HB_CLASS <ClassName> ;;
   <static> function <ClassName>(...) ;;
      static s_oClass ;;
      local oClassInstance ;;
      local nScope ;;
      [ REQUEST <SuperClass1> ] [ ,<SuperClassN> ] ;;
      nScope := HB_OO_CLSTP_EXPORTED ;;
      if s_oClass == NIL ;;
         s_oClass  := IIF(<.metaClass.>, <(metaClass)>, HBClass():new( <(ClassName)> , __HB_CLS_PAR ( [ <(SuperClass1)> ] [ ,<(SuperClassN)> ] ) ) ) ;;
     #undef  _CLASS_NAME_ ;;
     #define _CLASS_NAME_ <ClassName> ;;
     #undef  _CLASS_MODE_ ;;
     #define _CLASS_MODE_ _CLASS_DECLARATION_ ;;
     #untranslate CLSMETH ;;
     #untranslate DECLCLASS ;;
     #xtranslate CLSMETH <ClassName> \<MethodName> => @<ClassName>_\<MethodName> ;;
     #xtranslate DECLCLASS <ClassName> => <ClassName> ;
     ; #xuntranslate Super() : ;
     ; #xuntranslate Super : ;
     ; #xuntranslate : Super : ;
     [ ; #translate Super( <SuperClassN> ) : => ::<SuperClassN>: ] ;
     ; #translate Super( <SuperClass1> ) : => ::<SuperClass1>: ;
     ; #translate Super() : => ::<SuperClass1>: ;
     ; #translate Super : => ::<SuperClass1>: ;
     ; #translate : Super : => :<SuperClass1>:

#xcommand CLASS <ClassName> [METACLASS <metaClass>] [ <frm: FROM, INHERIT> <SuperClass1> [,<SuperClassN>] ] [<static: STATIC>] FUNCTION <FuncName> => ;
   _HB_CLASS <ClassName> ;;
   <static> function <FuncName>(...) ;;
      static s_oClass ;;
      local oClassInstance ;;
      local nScope ;;
      [ REQUEST <SuperClass1> ] [ ,<SuperClassN> ] ;;
      nScope := HB_OO_CLSTP_EXPORTED ;;
      if s_oClass == NIL ;;
         s_oClass  := IIF(<.metaClass.>, <(metaClass)>, HBClass():new( <(ClassName)> , __HB_CLS_PAR ( [ <(SuperClass1)> ] [ ,<(SuperClassN)> ] ) ) ) ;;
     #undef  _CLASS_NAME_ ;;
     #define _CLASS_NAME_ <ClassName> ;;
     #undef  _CLASS_MODE_ ;;
     #define _CLASS_MODE_ _CLASS_DECLARATION_ ;;
     #untranslate CLSMETH ;;
     #untranslate DECLCLASS ;;
     #xtranslate CLSMETH <ClassName> \<MethodName> => @<ClassName>_\<MethodName> ;;
     #xtranslate DECLCLASS <ClassName> => <ClassName> ;
     ; #xuntranslate Super() : ;
     ; #xuntranslate Super : ;
     ; #xuntranslate : Super : ;
     [ ; #translate Super( <SuperClassN> ) : => ::<SuperClassN>: ] ;
     ; #translate Super( <SuperClass1> ) : => ::<SuperClass1>: ;
     ; #translate Super() : => ::<SuperClass1>: ;
     ; #translate Super : => ::<SuperClass1>: ;
     ; #translate : Super : => :<SuperClass1>:

#else

#xcommand CLASS <ClassName> [METACLASS <metaClass>] [ <frm: FROM, INHERIT> <SuperClass1> [,<SuperClassN>] ] [<static: STATIC>] => ;
   _HB_CLASS <ClassName> ;;
   [ REQUEST <SuperClass1> ] [ ,<SuperClassN> ] ;;
   <static> function <ClassName>(...) ;;
      static s_oClass  ;;
      local oClassInstance ;;
      local nScope ;;
      nScope := HB_OO_CLSTP_EXPORTED ;;
      if s_oClass == NIL ;;
         s_oClass  := IIF(<.metaClass.>, <(metaClass)>, HBClass():new( <(ClassName)> , __HB_CLS_PAR ( [ <(SuperClass1)> ] [ ,<(SuperClassN)> ] ) ) ) ;;
     #undef  _CLASS_NAME_ ;;
     #define _CLASS_NAME_ <ClassName> ;;
     #undef  _CLASS_MODE_ ;;
     #define _CLASS_MODE_ _CLASS_DECLARATION_ ;;
     #untranslate CLSMETH ;;
     #translate CLSMETH <ClassName> \<MethodName>() => @\<MethodName> ;
     ; #xuntranslate Super() : ;
     ; #xuntranslate Super : ;
     ; #xuntranslate : Super : ;
     [ ; #translate Super( <SuperClassN> ) : => ::<SuperClassN>: ] ;
     ; #translate Super( <SuperClass1> ) : => ::<SuperClass1>: ;
     ; #translate Super() : => ::<SuperClass1>: ;
     ; #translate Super : => ::<SuperClass1>: ;
     ; #translate : Super : => :<SuperClass1>:

#endif /* HB_SHORTNAMES */

/* Disable the message :Class */
/* CLASSY SYNTAX */
#IFDEF HB_CLS_CSY
#xtranslate  :CLASS  =>
#xtranslate  :CLASS: => :
#endif

#endif


/* CLASSY SYNTAX */
#IFDEF HB_CLS_CSY

#xcommand VAR <DataNames,...> [ TYPE <type> ] [ ASSIGN <uValue> ] [<publish: PUBLISHED>] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HBCLSCHOICE( <.publish.>, <.export.>, <.protect.>, <.hidde.> ) + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#xcommand VAR <DataNames,...> [ AS <type> ] [ INIT <uValue> ] [<publish: PUBLISHED>] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HBCLSCHOICE( <.publish.>, <.export.>, <.protect.>, <.hidde.> ) + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#xcommand VAR <DataName> [ AS <type> ] IN <SuperClass> => ;
   _HB_MEMBER {[AS <type>] <DataName>} ;;
   s_oClass:AddInline( <(DataName)>, {|Self| Self:<SuperClass>:<DataName> }, HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY ) ;;
   s_oClass:AddInline( "_" + <(DataName)>, {|Self, param| Self:<SuperClass>:<DataName> := param }, HB_OO_CLSTP_EXPORTED )

#xcommand VAR <DataName> [ AS <type> ] IS <SprDataName> IN <SuperClass> => ;
   _HB_MEMBER {[AS <type>] <DataName>} ;;
   s_oClass:AddInline( <(DataName)>, {|Self| Self:<SuperClass>:<SprDataName> }, HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY ) ;;
   s_oClass:AddInline( "_" + <(DataName)>, {|Self, param| Self:<SuperClass>:<SprDataName> := param }, HB_OO_CLSTP_EXPORTED )

#xcommand VAR <DataName1> [ AS <type> ] IS <DataName2> => ;
   _HB_MEMBER {[AS <type>] <DataName1>} ;;
   s_oClass:AddInline( <(DataName1)>, {|Self| Self:<DataName2> }, HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY ) ;;
   s_oClass:AddInline( "_" + <(DataName1)>, {|Self, param| Self:<DataName2> := param }, HB_OO_CLSTP_EXPORTED )

#xcommand VAR <DataName1> IS <DataName2> TO <oObject> => ;
   s_oClass:AddInline( <(DataName1)>, {|Self| Self:<oObject>:<DataName2> }, HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY ) ;;
   s_oClass:AddInline( "_" + <(DataName1)>, {|Self, param| Self:<oObject>:<DataName2> := param }, HB_OO_CLSTP_EXPORTED )

#xtranslate    EXPORTED:       =>      nScope := HB_OO_CLSTP_EXPORTED
#xtranslate    EXPORT:         =>      nScope := HB_OO_CLSTP_EXPORTED
#xtranslate    VISIBLE:        =>      nScope := HB_OO_CLSTP_EXPORTED
#xtranslate    PUBLIC:         =>      nScope := HB_OO_CLSTP_EXPORTED

#xtranslate    HIDDEN:         =>      nScope := HB_OO_CLSTP_HIDDEN
#xtranslate    PRIVATE:        =>      nScope := HB_OO_CLSTP_HIDDEN

#xtranslate    PROTECTED:      =>      nScope := HB_OO_CLSTP_PROTECTED
#xtranslate    PUBLISHED:      =>      nScope := HB_OO_CLSTP_PUBLISHED

#xcommand CLASS VAR <*rest*> => CLASSVAR <rest>
#xcommand CLASS METHOD <*rest*> => CLASSMETHOD <rest>

#xcommand METHOD <MethodName> [ AS <type> ] DEFERRED => ;
   _HB_MEMBER <MethodName>() [ AS <type> ];;
   s_oClass:AddVirtual( <(MethodName)> )

#endif


/* VO SYNTAX */
#ifdef HB_CLS_VO

#xtranslate  ( <!name!>{ [<p,...>] }        =>  ( <name>():New( <p> )
#xtranslate  = <!name!>{ [<p,...>] }        =>  = <name>():New( <p> )
#xtranslate  , <!name!>{ [<p,...>] }        =>  , <name>():New( <p> )
#xtranslate  := <!name!>{ [<p,...>] }       =>  := <name>():New( <p> )

#xcommand EXPORT <DataNames,...> [ AS <type> ] [ INIT <uValue> ] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HB_OO_CLSTP_EXPORTED + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#xcommand EXPORT <DataNames,...> [ TYPE <type> ] [ ASSIGN <uValue> ] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HB_OO_CLSTP_EXPORTED + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#xcommand PROTECT <DataNames,...> [ AS <type> ] [ INIT <uValue> ] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HB_OO_CLSTP_PROTECTED + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#xcommand PROTECT <DataNames,...> [ TYPE <type> ] [ ASSIGN <uValue> ] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HB_OO_CLSTP_PROTECTED + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#xcommand HIDDEN <DataNames,...> [ AS <type> ] [ INIT <uValue> ] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HB_OO_CLSTP_HIDDEN + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#xcommand HIDDEN <DataNames,...> [ TYPE <type> ] [ ASSIGN <uValue> ] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HB_OO_CLSTP_HIDDEN + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;

#ENDIF


#xcommand CLASSVAR <DataNames,...> [ TYPE <type> ] [ ASSIGN <uValue> ] [<publish: PUBLISHED>] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ro: READONLY, RO>] [<share: SHARED>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiClsData(<(type)>, <uValue>, HBCLSCHOICE( <.publish.>, <.export.>, <.protect.>, <.hidde.> ) + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ) + iif( <.share.>, HB_OO_CLSTP_SHARED, 0 ), {<(DataNames)>}, __HB_CLS_NOINI ) ;

#xcommand CLASSVAR <DataNames,...> [ AS <type> ] [ INIT <uValue> ] [<publish: PUBLISHED>] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ro: READONLY, RO>] [<share: SHARED>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiClsData(<(type)>, <uValue>, HBCLSCHOICE( <.publish.>, <.export.>, <.protect.>, <.hidde.> ) + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ) + iif( <.share.>, HB_OO_CLSTP_SHARED, 0 ), {<(DataNames)>}, __HB_CLS_NOINI ) ;


/* FWOBJECT SYNTAX */
#ifdef HB_CLS_FWO

#xcommand DATA <DataNames,...> [ AS <type> ] [ INIT <uValue> ] [<publish: PUBLISHED>] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ro: READONLY, RO>] ;
   [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiData( <(type)>, <uValue>, HBCLSCHOICE( <.publish.>, <.export.>, <.protect.>, <.hidde.> ) + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ), {<(DataNames)>}, __HB_CLS_NOINI, <.persistent.> ) ;


#xcommand CLASSDATA <DataNames,...> [ AS <type> ] [ INIT <uValue> ] [<publish: PUBLISHED>] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ro: READONLY, RO>] [<share: SHARED>] => ;
   _HB_MEMBER {[AS <type>] <DataNames>} ;;
   s_oClass:AddMultiClsData(<(type)>, <uValue>, HBCLSCHOICE( <.publish.>, <.export.>, <.protect.>, <.hidde.> ) + iif( <.ro.>, HB_OO_CLSTP_READONLY, 0 ) + HB_OO_CLSTP_SHARED, {<(DataNames)>}, __HB_CLS_NOINI ) ;

#endif


/* XBASE SYNTAX */
#ifdef HB_CLS_XB

#xcommand SYNC METHOD <Name> [<*x*>] => METHOD <Name> SYNC [<x>]

#endif

#xcommand CLASSMETHOD <MethodName> [ <clsctor: CONSTRUCTOR> ] [ AS <type> ] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<share: SHARED>] => ;
   _HB_MEMBER <MethodName>() [ AS <type> ];;
   s_oClass:AddClsMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.share.>, HB_OO_CLSTP_SHARED, 0 ) + iif( <.clsctor.>, HB_OO_CLSTP_CLASSCTOR, 0 ) );;
   #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>])

#xcommand CONSTRUCTOR <Name> [<*x*>] => METHOD <Name> CONSTRUCTOR [<x>]
#xcommand CONSTRUCTOR <Name> INLINE <Code,...> [<*x*>] => METHOD <Name> INLINE <Code> CONSTRUCTOR [<x>]

#ifdef STRICT_OO
  #xcommand METHOD <MethodName> [ <ctor: CONSTRUCTOR> ] [ AS <type> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] [_CLASS_DECLARATION_] ;
    [<persistent: PERSISTENT, PROPERTY>] [<ov: OVERRIDE>] => ;
    _HB_MEMBER <MethodName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
    s_oClass:AddMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ), <.persistent.> );;
    #xcommand METHOD <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>;;
    #xcommand PROCEDURE <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>;;
    #xcommand METHOD <MethodName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>;;
    #xcommand PROCEDURE <MethodName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>

  #xcommand CLASSMETHOD <MethodName> [ <clsctod: CONSTRUCTOR> ] [ AS <type> ] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<share: SHARED>] [<sync: SYNC>] [_CLASS_DECLARATION_] => ;
    _HB_MEMBER <MethodName>() [ AS <type> ];;
    s_oClass:AddClsMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.share.>, HB_OO_CLSTP_SHARED, 0 ) + iif( <.clsctod.>, HB_OO_CLSTP_CLASSCTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand METHOD <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>;;
    #xcommand PROCEDURE <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>;;
    #xcommand METHOD <MethodName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>;;
    #xcommand PROCEDURE <MethodName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>
#else
  #xcommand METHOD <MethodName> [ <ctor: CONSTRUCTOR> ] [ AS <type> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] [_CLASS_DECLARATION_] ;
    [<persistent: PERSISTENT, PROPERTY>] [<ov: OVERRIDE>] => ;
    _HB_MEMBER <MethodName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
    s_oClass:AddMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ), <.persistent.> );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand METHOD <MethodName>([<params,...>]) [ <ctor: CONSTRUCTOR> ] [ AS <type> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] [_CLASS_DECLARATION_] ;
    [<persistent: PERSISTENT, PROPERTY>] [<ov: OVERRIDE>] => ;
    _HB_MEMBER <MethodName>([<params>]) [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
    s_oClass:AddMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ), <.persistent.> );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand CLASSMETHOD <MethodName> [ <clsctor: CONSTRUCTOR> ] [ AS <type> ] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<share: SHARED>] [<sync: SYNC>] [_CLASS_DECLARATION_] => ;
    _HB_MEMBER <MethodName>() [ AS <type> ];;
    s_oClass:AddClsMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.share.>, HB_OO_CLSTP_SHARED, 0 ) + iif( <.clsctor.>, HB_OO_CLSTP_CLASSCTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand CLASSMETHOD <MethodName>([<params,...>]) [ <clsctor: CONSTRUCTOR> ] [ AS <type> ] [<export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<share: SHARED>] [<sync: SYNC>] [_CLASS_DECLARATION_] => ;
    _HB_MEMBER <MethodName>([<params>]) [ AS <type> ];;
    s_oClass:AddClsMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.share.>, HB_OO_CLSTP_SHARED, 0 ) + iif( <.clsctor.>, HB_OO_CLSTP_CLASSCTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>]);;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>(\[\<anyParams>])
#endif

#xcommand METHOD <MethodName> [ AS <type> ] BLOCK <CodeBlock> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] ;
   [<persistent: PERSISTENT, PROPERTY>] [<ov: OVERRIDE>] => ;
   _HB_MEMBER <MethodName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
   s_oClass:AddInline( <(MethodName)>, <CodeBlock>, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ), <.persistent.> )

#xcommand METHOD <MethodName> [ AS <type> ] EXTERN <FuncName> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] ;
   [<persistent: PERSISTENT, PROPERTY>] [<ov: OVERRIDE>] => ;
   _HB_MEMBER <MethodName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
   s_oClass:AddMethod( <(MethodName)>, @<FuncName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ), <.persistent.> )

#xcommand METHOD <MethodName> [ AS <type> ] INLINE <Code,...> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] ;
   [<persistent: PERSISTENT, PROPERTY>] [<ov: OVERRIDE>] => ;
   _HB_MEMBER <MethodName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
   s_oClass:AddInline( <(MethodName)>, {|Self | <Code> }, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ), <.persistent.> )

/* Must have secondary version with params because params are used in the block */
#xcommand METHOD <MethodName>( [<params,...>] ) [ AS <type> ] INLINE <Code,...> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] ;
   [<persistent: PERSISTENT, PROPERTY>] [<ov: OVERRIDE>] => ;
   _HB_MEMBER <MethodName>([<params>]) [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
   s_oClass:AddInline( <(MethodName)>, {|Self [,<params>] | <Code> }, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ), <.persistent.> )

#xcommand METHOD <MethodName> [ AS <type> ] INLINE [Local <v>,] <Code,...> [<other>] => ;
          METHOD <MethodName> [ AS <type> ] BLOCK {|Self [,<v>] | <Code> } [<other>]

/* Must have secondary version with params becuase params are used in the block */
#xcommand METHOD <MethodName>( [<params,...>] ) [ AS <type> ] INLINE [Local <v>,] <Code,...> [<other>] => ;
          METHOD <MethodName> [ AS <type> ] BLOCK {|Self [,<params>] [,<v>] | <Code> } [<other>]

/*
#XCOMMAND INLINE METHOD <!Method!>[()] => WITH OBJECT \<|Self|; #undef __METHOD__; #define __METHOD__ <Method>
#XCOMMAND INLINE METHOD <!Method!>( <params,...> ) => WITH OBJECT \<|Self, <params>|; #undef __METHOD__; #define __METHOD__ <Method>
#XCOMMAND ENDMETHOD => \>; METHOD __METHOD__ BLOCK HB_QWith(); END
*/

#XCOMMAND INLINE METHOD <!Method!>[()]             => s_oClass:AddMethod( <(Method)>, CLSMETH _CLASS_NAME_ <Method>(), nScope, .F. ); PP__INLINEMETHOD ; DECLARED METHOD _CLASS_NAME_ <Method>()
#XCOMMAND INLINE METHOD <!Method!>( <params,...> ) => s_oClass:AddMethod( <(Method)>, CLSMETH _CLASS_NAME_ <Method>(), nScope, .F. ); PP__INLINEMETHOD ; DECLARED METHOD _CLASS_NAME_ <Method>( <params> )
#COMMAND ENDMETHOD                                 => PP__ENDMETHOD

#xcommand METHOD <MethodName> [ AS <type> ] [ <ctor: CONSTRUCTOR> ] VIRTUAL => ;
   _HB_MEMBER <MethodName>() [ AS <type> ];;
   s_oClass:AddVirtual( <(MethodName)> )

#xcommand METHOD <MethodName> [ AS <type> ] [ <ctor: CONSTRUCTOR> ] DYNAMIC => ;
   _HB_MEMBER <MethodName>() [ AS <type> ];;
   s_oClass:AddVirtual( <(MethodName)> )

#ifdef STRICT_OO
  #xcommand METHOD <MethodName> [ AS <type> ] OPERATOR <op> [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] [<ov: OVERRIDE>] => ;
    _HB_MEMBER <MethodName>()  [ AS <type> ];;
    s_oClass:AddMethod( <(op)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) ) ;;
    #xcommand METHOD <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName> ;;
    #xcommand METHOD <MethodName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>
#else
  #xcommand METHOD <MethodName> [ AS <type> ] OPERATOR <op> [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] [<ov: OVERRIDE>] => ;
    _HB_MEMBER <MethodName>()  [ AS <type> ];;
    s_oClass:AddMethod( <(op)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) ) ;;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]) ;;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand METHOD <MethodName>( [<params,...>] ) [ AS <type> ] OPERATOR <op> [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] [<ov: OVERRIDE>] => ;
    _HB_MEMBER <MethodName>([<params>])  [ AS <type> ];;
    s_oClass:AddMethod( <(op)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) ) ;;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])
#endif

#xcommand OPERATOR <op> [ARG <xArg>] INLINE <Code,...> [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVARE>] => ;
s_oClass:AddInline( <(op)>, {|Self [, <xArg>] | <Code> }, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) )

//command OPERATOR <op> ARG <xArg> INLINE [Local lx,...] <Code,...> [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] => ;
//oClass:AddInline( <(op)>, {|Self, <xArg> [,<lx>] | <Code> }, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) )

#ifdef STRICT_OO
  #xcommand MESSAGE <MessageName> [ AS <type> ] METHOD <MethodName> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
     #xcommand METHOD <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>;;
     #xcommand METHOD <MethodName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>
#else
  #xcommand MESSAGE <MessageName> [ AS <type> ] METHOD <MethodName> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand MESSAGE <MessageName>([<MsgParams,...>]) [ AS <type> ] METHOD <MethodName> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>([<MsgParams>]) [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand MESSAGE <MessageName> [ AS <type> ] METHOD <MethodName>([<MtdParams,...>]) [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>([<MtdParams>]) [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand MESSAGE <MessageName>([<MsgParams,...>]) [ AS <type> ] METHOD <MethodName>([<MtdParams,...>]) [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>([<MtdParams>]) [<-MsgParams->] [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])
#endif

#ifdef STRICT_OO
  #xcommand MESSAGE <MessageName> [ AS <type> ] PROCEDURE <MethodName> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
     #xcommand PROCEDURE <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>
#else
  #xcommand MESSAGE <MessageName> [ AS <type> ] PROCEDURE <MethodName> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>() [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>])

  #xcommand MESSAGE <MessageName>([<MsgParams,...>]) [ AS <type> ] PROCEDURE <MethodName> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>([<MsgParams>]) [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>])

  #xcommand MESSAGE <MessageName> [ AS <type> ] PROCEDURE <MethodName>([<MtdParams,...>]) [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>([<MtdParams>]) [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>])

  #xcommand MESSAGE <MessageName>([<MsgParams,...>]) [ AS <type> ] PROCEDURE <MethodName>([<MtdParams,...>]) [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<sync: SYNC>] => ;
     _HB_MEMBER <MessageName>([<MtdParams>]) [<-MsgParams->] [<-ctor-> AS CLASS _CLASS_NAME_] [ AS <type> ];;
     s_oClass:AddMethod( <(MessageName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) + iif( <.sync.>, HB_OO_CLSTP_SYNC, 0 ) );;
    #xcommand PROCEDURE <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>(\[\<anyParams>])
#endif

#xcommand MESSAGE <MessageName> [ AS <type> ] IN <SuperClass> => ;
   _HB_MEMBER <MessageName>() [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self| Self:<SuperClass>:<MessageName>() } )

/* Must have secondary version with params because params are used in the block */
#xcommand MESSAGE <MessageName>( [<params,...>] ) [ AS <type> ] IN <SuperClass> => ;
   _HB_MEMBER <MessageName>([<params>]) [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self [,<params>]| Self:<SuperClass>:<MessageName>( [<params>] ) } )

#xcommand MESSAGE <MessageName> [ AS <type> ] IS <SprMethodName> IN <SuperClass> => ;
   _HB_MEMBER <MessageName>() [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self| Self:<SuperClass>:<SprMethodName>() } )

/* Must have secondary version with params because params are used in the block */
#xcommand MESSAGE <MessageName> [ AS <type> ] IS <SprMethodName>( [<params,...>] ) IN <SuperClass> => ;
   _HB_MEMBER <MessageName>() [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self [,<params>]| Self:<SuperClass>:<SprMethodName>( [<params>] ) } )

/* Must have secondary version with params because params are used in the block */
#xcommand MESSAGE <MessageName>( [<params,...>] ) [ AS <type> ] IS <SprMethodName> IN <SuperClass> => ;
   _HB_MEMBER <MessageName>([<params>]) [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self [,<params>]| Self:<SuperClass>:<SprMethodName>( [<params>] ) } )

/* Must have secondary version with params because params are used in the block */
#xcommand MESSAGE <MessageName>( [<params,...>] ) [ AS <type> ] IS <SprMethodName>( [<dummy,...>] ) IN <SuperClass> => ;
   _HB_MEMBER <MessageName>([<params>]) [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self [,<params>]| Self:<SuperClass>:<SprMethodName>( [<params>] ) } )

#xcommand MESSAGE <MessageName> [ AS <type> ] IS <MethodName> [<more,...>] => MESSAGE <MessageName> [ AS <type> ] METHOD <MethodName> [<more>]

#xcommand MESSAGE <MessageName> [ AS <type> ] TO <oObject> =>;
   _HB_MEMBER <MessageName>() [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self| Self:<oObject>:<MessageName> } )

/* Must have secondary version with params because params are used in the block */
#xcommand MESSAGE <MessageName>( [<params,...>] ) [ AS <type> ] TO <oObject> =>;
   _HB_MEMBER <MessageName>([<params>]) [ AS <type> ];;
   s_oClass:AddInline( <(MessageName)>, {|Self [,<params>]| Self:<oObject>:<MessageName>( [<params>] ) } )

#xcommand DELEGATE <MessageName> [ AS <type> ] TO <oObject> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ov: OVERRIDE>] =>;
   _HB_MEMBER <MessageName>() [ AS <type> ];;
   s_oClass:AddDelegate( <(MessageName)>, <(MessageName)>, <(oObject)>, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) )

/* Must have secondary version with params because params are used in the block */
#xcommand DELEGATE <MessageName>( [<params,...>] ) [ AS <type> ] TO <oObject> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ov: OVERRIDE>] =>;
   _HB_MEMBER <MessageName>([<params>]) [ AS <type> ];;
   s_oClass:AddDelegate( <(MessageName)>, <(MessageName)>, <(oObject)>, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) )

#xcommand DELEGATE <MessageName> [ AS <type> ] IS <DelegateName> TO <oObject> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ov: OVERRIDE>] =>;
   _HB_MEMBER <MessageName>() [ AS <type> ];;
   s_oClass:AddDelegate( <(MessageName)>, <(DelegateName)>, <(oObject)>, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) )

/* Must have secondary version with params because params are used in the block */
#xcommand DELEGATE <MessageName>( [<params,...>] ) [ AS <type> ] IS <DelegateName> TO <oObject> [ <ctor: CONSTRUCTOR> ] [ <export: EXPORTED, VISIBLE, PUBLIC>] [<protect: PROTECTED>] [<hidde: HIDDEN, PRIVATE>] [<ov: OVERRIDE>] =>;
   _HB_MEMBER <MessageName>([<params>]) [ AS <type> ];;
   s_oClass:AddDelegate( <(MessageName)>, <(DelegateName)>, <(oObject)>, HBCLSCHOICE( .F., <.export.>, <.protect.>, <.hidde.> ) + iif( <.ctor.>, HB_OO_CLSTP_CTOR, 0 ) )

#ifdef STRICT_OO
  #xcommand METHOD <MethodName> [ AS <type> ]  [<persistent: PERSISTENT, PROPERTY>] SETGET => ;
    _HB_MEMBER <MethodName>() [ AS <type> ];;
    _HB_MEMBER _<MethodName>() [ AS <type> ];;
    s_oClass:AddMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY , <.persistent.> ) ;;
    s_oClass:AddMethod( "_" + <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>() );;
    #xcommand METHOD <MethodName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName> ;;
    #xcommand METHOD <MethodName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>
#else
  #xcommand METHOD <MethodName> [ AS <type> ]  [<persistent: PERSISTENT, PROPERTY>] SETGET => ;
    _HB_MEMBER <MethodName>() [ AS <type> ];;
    _HB_MEMBER _<MethodName>() [ AS <type> ];;
    s_oClass:AddMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY , <.persistent.> ) ;;
    s_oClass:AddMethod( "_" + <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>() );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]) ;;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])

  #xcommand METHOD <MethodName>([<params,...>]) [ AS <type> ]  [<persistent: PERSISTENT, PROPERTY>] SETGET => ;
    _HB_MEMBER <MethodName>([<params>]) [ AS <type> ];;
    _HB_MEMBER _<MethodName>([<params>]) [ AS <type> ];;
    s_oClass:AddMethod( <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>(), HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY, <.persistent.> ) ;;
    s_oClass:AddMethod( "_" + <(MethodName)>, CLSMETH _CLASS_NAME_ <MethodName>() );;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]) ;;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])
#endif

#ifdef STRICT_OO
  #xcommand ACCESS <AccessName> [ AS <type> ] [<persistent: PERSISTENT, PROPERTY>] => ;
    _HB_MEMBER <AccessName>() [ AS <type> ];;
    s_oClass:AddMethod( <(AccessName)>, CLSMETH _CLASS_NAME_ <AccessName>(), HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY , <.persistent.> );;
    #xcommand METHOD <AccessName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <AccessName>;;
    #xcommand METHOD <AccessName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <AccessName>
#else
  #xcommand ACCESS <AccessName> [ AS <type> ] [<persistent: PERSISTENT, PROPERTY>] => ;
    _HB_MEMBER <AccessName>() [ AS <type> ];;
    s_oClass:AddMethod( <(AccessName)>, CLSMETH _CLASS_NAME_ <AccessName>(), HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY , <.persistent.> );;
    #xcommand METHOD <AccessName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <AccessName>(\[\<anyParams>]);;
    #xcommand METHOD <AccessName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <AccessName>(\[\<anyParams>])

  #xcommand ACCESS <AccessName>([<params,...>]) [ AS <type> ] [<persistent: PERSISTENT, PROPERTY>] => ;
    _HB_MEMBER <AccessName>([<params>]) [ AS <type> ];;
    s_oClass:AddMethod( <(AccessName)>, CLSMETH _CLASS_NAME_ <AccessName>(), HB_OO_CLSTP_EXPORTED + HB_OO_CLSTP_READONLY , <.persistent.> );;
    #xcommand METHOD <AccessName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <AccessName>(\[\<anyParams>]);;
    #xcommand METHOD <AccessName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <AccessName>(\[\<anyParams>])
#endif

#xcommand ACCESS <AccessName> [ AS <type> ] INLINE [Local <v>,] <code,...> [<persistent: PERSISTENT, PROPERTY>] => ;
   _HB_MEMBER <AccessName>() [ AS <type> ];;
   s_oClass:AddInline( <(AccessName)>, {|Self [,<v>] | <code> }, HB_OO_CLSTP_EXPORTED, <.persistent.> )

#xcommand ACCESS <AccessName> [ AS <type> ] DEFERRED => ;
   _HB_MEMBER <AccessName>() [ AS <type> ];;
   s_oClass:AddVirtual( <(AccessName)> )

#ifdef STRICT_OO
  #xcommand ASSIGN <AssignName> [ AS <type> ] => ;
    _HB_MEMBER _<AssignName>() [ AS <type> ];;
    s_oClass:AddMethod( "_" + <(AssignName)>, CLSMETH _CLASS_NAME_ _<AssignName>(), HB_OO_CLSTP_EXPORTED );;
    #xcommand METHOD <AssignName> \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <AssignName>);;
    #xcommand METHOD <AssignName> \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <AssignName>)
#else
  #xcommand ASSIGN <AssignName> [ AS <type> ] => ;
    _HB_MEMBER _<AssignName>() [ AS <type> ];;
    s_oClass:AddMethod( "_" + <(AssignName)>, CLSMETH _CLASS_NAME_ _<AssignName>(), HB_OO_CLSTP_EXPORTED );;
    #xcommand METHOD <AssignName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <AssignName>(\[\<anyParams>]);;
    #xcommand METHOD <AssignName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <AssignName>(\[\<anyParams>])

  #xcommand ASSIGN <AssignName>([<params,...>]) [ AS <type> ] => ;
    _HB_MEMBER _<AssignName>([<params>]) [ AS <type> ];;
    s_oClass:AddMethod( "_" + <(AssignName)>, CLSMETH _CLASS_NAME_ _<AssignName>(), HB_OO_CLSTP_EXPORTED );;
    #xcommand METHOD <AssignName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <AssignName>(\[\<anyParams>]);;
    #xcommand METHOD <AssignName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <AssignName>(\[\<anyParams>])
#endif

#xcommand ASSIGN <AssignName>( [<params,...>] ) [ AS <type> ] INLINE [Local <v>,] <Code,...> => ;
   _HB_MEMBER _<AssignName>([<params>]) [ AS <type> ];;
   s_oClass:AddInline( "_" + <(AssignName)>, {|Self [,<params>] [,<v>] | <Code> }, HB_OO_CLSTP_EXPORTED )

#xcommand ON ERROR <MethodName> => ERROR HANDLER <MethodName>;

#ifdef STRICT_OO
   #xcommand ERROR HANDLER <MethodName> => ;
     _HB_MEMBER <MethodName>;;
     s_oClass:SetOnError( CLSMETH _CLASS_NAME_ <MethodName>() ) ;;
     #xcommand METHOD <MethodName>                    \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>;;
     #xcommand METHOD <MethodName>                    \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>
#else
   #xcommand ERROR HANDLER <MethodName> => ;
     _HB_MEMBER <MethodName>();;
     s_oClass:SetOnError( CLSMETH _CLASS_NAME_ <MethodName>() ) ;;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])

   #xcommand ERROR HANDLER <MethodName>([<params,...>]) => ;
     _HB_MEMBER <MethodName>([<params>]);;
     s_oClass:SetOnError( CLSMETH _CLASS_NAME_ <MethodName>() ) ;;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>(\[\<anyParams>]);;
    #xcommand METHOD <MethodName> \[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED METHOD \<ClassName> <MethodName>(\[\<anyParams>])
#endif

#xcommand DESTRUCTOR <MethodName> => ;
  _HB_MEMBER <MethodName>();;
  s_oClass:SetDestructor( CLSMETH _CLASS_NAME_ <MethodName>() ) ;;
 #xcommand PROCEDURE <MethodName>\[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>;;
 #xcommand PROCEDURE <MethodName>\[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>

#xcommand DESTRUCTOR <MethodName>() => ;
  _HB_MEMBER <MethodName>();;
  s_oClass:SetDestructor( CLSMETH _CLASS_NAME_ <MethodName>() ) ;;
 #xcommand PROCEDURE <MethodName>\[(\[\<anyParams,...>])] \[DECLCLASS _CLASS_NAME_] _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>;;
 #xcommand PROCEDURE <MethodName>\[(\[\<anyParams,...>])] \<ClassName> _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE \<ClassName> <MethodName>

#xtranslate END CLASS => ENDCLASS

#ifdef HB_CLS_ALLOWCLASS
#xcommand ENDCLASS => ;;
                       s_oClass:Create(MetaClass) ;;
                       __ClsSetModule( s_oClass:hClass ) ;;
                      oClassInstance := __clsInst( s_oClass:hClass );;
                       IF __ObjHasMsg( oClassInstance, "InitClass" );;
                         oClassInstance:InitClass( hb_aParams() ) ;;
                       ENDIF ;;
                      ELSE ;;
                       oClassInstance := __clsInst( s_oClass:hClass ) ;;
                      ENDIF ;;
                      IF PCount() > 0 ;;
                         RETURN s_oClass:ConstructorCall( oClassInstance, hb_aparams() ) ;;
                      ENDIF ;;
                      RETURN oClassInstance AS CLASS _CLASS_NAME_ ;;
                      #undef  _CLASS_MODE_ ;;
                      #define _CLASS_MODE_ _CLASS_IMPLEMENTATION_
#else
#xcommand ENDCLASS => ;;
                       s_oClass:Create() ;;
                       __ClsSetModule( s_oClass:hClass ) ;;
                      oClassInstance := __clsInst( s_oClass:hClass );;
                       IF __ObjHasMsg( oClassInstance, "InitClass" );;
                         oClassInstance:InitClass( hb_aParams() ) ;;
                       ENDIF ;;
                      ELSE ;;
                       oClassInstance := __clsInst( s_oClass:hClass ) ;;
                      ENDIF ;;
                      IF PCount() > 0 ;;
                         RETURN s_oClass:ConstructorCall( oClassInstance, hb_aparams() ) ;;
                      ENDIF ;;
                      RETURN oClassInstance AS CLASS _CLASS_NAME_ ;;
                      #undef  _CLASS_MODE_ ;;
                      #define _CLASS_MODE_ _CLASS_IMPLEMENTATION_
#endif

#xtranslate :Super( <SuperClass> ) : => :<SuperClass>:
#xtranslate :Super() : => :Super:
#xtranslate :Super() => :Super


#ifndef HB_SHORTNAMES

#xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName>  => METHOD <MethodName>  _CLASS_MODE_
#xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName> CLASS <ClassName> => METHOD <MethodName>  CLASS <ClassName>  _CLASS_MODE_

//#define HB_CLS_NO_OO_ERR

#ifdef HB_CLS_NO_OO_ERR
   #xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName> CLASS <ClassName> => METHOD <MethodName>     CLASS <ClassName> _CLASS_IMPLEMENTATION_

   #xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName>                      _CLASS_IMPLEMENTATION_ => DECLARED METHOD _CLASS_NAME_ <MethodName>
   #xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName> CLASS <ClassName>    _CLASS_IMPLEMENTATION_ => DECLARED METHOD <ClassName> <MethodName>

   #xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName> CLASS <ClassName> => PROCEDURE <MethodName>     CLASS <ClassName> _CLASS_IMPLEMENTATION_

   // Do NOT uncomment!
   //#xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName>                      _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE _CLASS_NAME_ <MethodName>
   #xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName> CLASS <ClassName>    _CLASS_IMPLEMENTATION_ => DECLARED PROCEDURE <ClassName> <MethodName>
#else
   #xcommand METHOD [FUNCTION] <MethodName> CLASS <ClassName> => METHOD <MethodName> DECLCLASS <ClassName> _CLASS_IMPLEMENTATION_

   #ifdef STRICT_OO
      #xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName>                   _CLASS_IMPLEMENTATION_ => __ERR(Method <"MethodName"> not declared or declaration mismatch in class: _CLASS_NAME_) ; function <MethodName> ; local self := QSelf()
      #xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName> [CLASS] <ClassName> _CLASS_IMPLEMENTATION_ => #error Method <"MethodName"> not declared or declaration mismatch in class: <ClassName> ; function <MethodName> ; local self := QSelf()
   #else
      #xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName>                   _CLASS_IMPLEMENTATION_ => __ERR(Method <"MethodName"> not declared in class: _CLASS_NAME_) ; function <MethodName> ; local self := QSelf()
      #xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName> [CLASS] <ClassName> _CLASS_IMPLEMENTATION_ => #error Method <"MethodName"> not declared in class: <ClassName> ; function <MethodName> ; local self := QSelf()
   #endif

   #xcommand PROCEDURE [FUNCTION] <MethodName> CLASS <ClassName> => PROCEDURE <MethodName> DECLCLASS <ClassName> _CLASS_IMPLEMENTATION_

   #ifdef STRICT_OO
      #xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName>                   _CLASS_IMPLEMENTATION_ => #error Procedure <"MethodName"> not declared or declaration mismatch in class: _CLASS_NAME_ ; function <MethodName> ; local self := QSelf()
      #xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName> [CLASS] <ClassName> _CLASS_IMPLEMENTATION_ => #error Procedure <"MethodName"> not declared or declaration mismatch in class: <ClassName> ; function <MethodName> ; local self := QSelf()
   #else
      #xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName>                   _CLASS_IMPLEMENTATION_ => #error Procedure <"MethodName"> not declared in class: _CLASS_NAME_ ; function <MethodName> ; local self := QSelf()
      #xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName> [CLASS] <ClassName> _CLASS_IMPLEMENTATION_ => #error Procedure <"MethodName"> not declared in class: <ClassName> ; function <MethodName> ; local self := QSelf()
   #endif
#endif

#xcommand METHOD [FUNCTION] [PROCEDURE] <MethodName> DECLCLASS <ClassName> _CLASS_IMPLEMENTATION_ => #error Class <"ClassName"> not declared for method: <MethodName> ; function <MethodName> ; local self := QSelf()
#xcommand PROCEDURE [FUNCTION] [PROCEDURE] <MethodName> DECLCLASS <ClassName> _CLASS_IMPLEMENTATION_ => #error Class <"ClassName"> not declared for procedure: <MethodName> ; function <MethodName> ; local self := QSelf()

#xcommand DECLARED METHOD <ClassName> <MethodName> => ;
          static function DECLMETH <ClassName> <MethodName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>

#xcommand DECLARED PROCEDURE <ClassName> <MethodName> => ;
          static procedure DECLMETH <ClassName> <MethodName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>

#xcommand ACCESS <AccessName> CLASS <ClassName> => ;
          static function <ClassName>_<AccessName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>

#xcommand ASSIGN <AssignName> CLASS <ClassName> => ;
          static function <ClassName>__<AssignName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>
#else

#xcommand DECLARED METHOD <ClassName> <MethodName>=> ;
          static function <MethodName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>

#xcommand DECLARED PROCEDURE <ClassName> <MethodName>=> ;
          static procedure <MethodName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>

#xcommand ACCESS <AccessName> CLASS <ClassName> => ;
          static function <AccessName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>

#xcommand ASSIGN <AssignName> CLASS <ClassName> => ;
          static function _<AssignName> ;;
          local Self AS CLASS <ClassName> := QSelf() AS CLASS <ClassName>

#endif /* HB_SHORTNAMES */

#xcommand METHOD <!ClassName!>:<MethodName> => METHOD <MethodName> CLASS <ClassName>

#endif /* HB_CLASS_CH_ */
