/* $Id: gaboutdialog.prg,v 1.5 2007-02-27 08:21:34 xthefull Exp $*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GAboutDialog FROM GDIALOG

      METHOD New( )
      METHOD SetName( cName )       INLINE gtk_about_dialog_set_name( ::pWidget, cName )
      METHOD GetName()              INLINE gtk_about_dialog_get_name( ::pWidget )
      METHOD SetVersion( cVersion ) INLINE gtk_about_dialog_set_version( ::pWidget, cVersion )
      METHOD GetVersion()           INLINE gtk_about_dialog_get_version( ::pWidget )
      
      METHOD SetCopyright( cText )  INLINE gtk_about_dialog_set_copyright( ::pWidget, cText )
      METHOD GetCopyright()         INLINE gtk_about_dialog_get_copyright( ::pWidget )
      METHOD SetComments( cText )   INLINE gtk_about_dialog_set_comments( ::pWidget, cText )
      METHOD GetComments()          INLINE gtk_about_dialog_get_comments( ::pWidget )
      METHOD SetLicense( cText )    INLINE gtk_about_dialog_set_license( ::pWidget, cText )
      METHOD GetLicense()           INLINE gtk_about_dialog_get_license( ::pWidget )
      METHOD SetWebsite( cText )    INLINE gtk_about_dialog_set_website( ::pWidget, cText )
      METHOD GetWebsite()           INLINE gtk_about_dialog_get_website( ::pWidget )
      METHOD SetWebsiteLabel( cText )    INLINE gtk_about_dialog_set_website_label( ::pWidget, cText )
      METHOD GetWebsiteLabel()           INLINE gtk_about_dialog_get_website_label( ::pWidget )
      METHOD SetArtists( aArtists ) INLINE gtk_about_dialog_set_artists( ::pWidget, aArtists )
      METHOD SetAuthors( aAuthors ) INLINE gtk_about_dialog_set_authors( ::pWidget, aAuthors )
      METHOD SetDocumenters( aDocumenters ) INLINE gtk_about_dialog_set_documenters( ::pWidget, aDocumenters )
      METHOD SetLogo( oImage ) INLINE gtk_about_dialog_set_logo( ::pWidget, oImage:GetPixBuf() )

ENDCLASS

METHOD NEW( cName, cVersion, aAuthors, aArtists, aDocumenters, oLogo, lCenter, cId, uGlade ) CLASS GAboutDialog
       DEFAULT lCenter := .F.

       if cId == NIL
          ::pWidget := gtk_about_dialog_new()
       else
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
          ::lGlade := .T.
       endif

       if cName    != NIL  ;  ::SetName( cName )        ;   endif
       if cVersion != NIL  ;  ::SetVersion( cVersion )  ;   endif
       if aArtists != NIL  ;  ::SetArtists( aArtists )  ;   endif
       if aAuthors != NIL  ;  ::SetAuthors( aAuthors )  ;   endif
       if aDocumenters != NIL  ;  ::SetDocumenters( aDocumenters )  ;   endif
       if oLogo != NIL ;  ::SetLogo( oLogo )  ;   endif
      
       // Como en los dialogs, esto es ignorado desde glade...quizas sea un bug( gtk 2.8 win )
       if !::lGlade 
          if lCenter
             ::Center()
          endif
       endif

       ::bCancel := {| o | o:End() } // Activate button Close for kill aboutdialog
       ::Connect( "response" )
       ::Connect( "delete-event" )
       ::Connect( "destroy" )
       
       ::Show()           
RETURN Self
