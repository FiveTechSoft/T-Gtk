/*
Practica para manejar ListStore desde GtkBuilder
*/

#include "gclass.ch"

#define GtkTreeIter  Array( 4 )

MEMVAR cResource

Function main( )
  Local oWnd, oLbx, oTreeView

    PUBLIC cResource
 
    SET DATE TO ITALIAN
    SET GTKBUILDER ON

    SET RESOURCES cResource FROM FILE "gtkbuilder.ui"

    modelodatos( )

    DEFINE WINDOW oWnd ID "window1" RESOURCE cResource
   
    ACTIVATE WINDOW oWnd

RETURN NIL

function modelodatos(  )
  Local aIter := GtkTreeIter, oLbx, x , pListore , hList
  Local aItems := { { .F., 60482, "Normal",     "scrollable notebooks and hidden tabs" },;
                    { .F., 60620, "Critical",   "gdk_window_clear_area (gdkwindow-win32.c) is not thread-safe" },;
                    { .F., 50214, "Major",      "Xft support does not clean up correctly" },;
                    { .T., 52877, "Major",      "GtkFileSelection needs a refresh method. " },;
                    { .F., 56070, "Normal",     "Can't click button after setting in sensitive" },;
                    { .T., 56355, "Normal",     "GtkLabel - Not all changes propagate correctly" },;
                    { .F., 50055, "Normal",     "Rework width/height computations for TreeView" },;
                    { .F., 58278, "Normal",     "gtk_dialog_set_response_sensitive () doesn't work" },;
                    { .F., 55767, "Normal",     "Getters for all setters" },;
                    { .F., 56925, "Normal",     "Gtkcalender size" },;
                    { .F., 56221, "Normal",     "Selectable label needs right-click copy menu" },;
                    { .T., 50939, "Normal",     "Add shift clicking to GtkTextView" },;
                    { .F., 6112,  "Enhancement","netscape-like collapsable toolbars" },;
                    { .F., 1,     "Normal",     "First bug :=)" } }

   
   DEFINE LIST_STORE oLbx MODEL "liststore1" RESOURCE cResource
   
   For x := 1 To Len( aItems )
        APPEND LIST_STORE oLbx ITER aIter
        SET values LIST_STORE oLbx ITER aIter VALUES aItems[x]
    Next


return nil
