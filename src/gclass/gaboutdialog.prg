/* $Id: gaboutdialog.prg,v 1.3 2006-10-03 12:52:54 xthefull Exp $*/
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

ENDCLASS

METHOD NEW( cName, cVersion, aArtists ,lCenter, cId, uGlade ) CLASS GAboutDialog

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
      
       // Como en los dialogs, esto es ignorado desde glade...quizas sea un bug( gtk 2.8 win )
       if !::lGlade 
          if lCenter
             ::Center()
          endif
       endif

       ::Show()           
       ::Connect( "destroy" )

RETURN Self
