/* $Id: events.h,v 1.1 2006-09-11 16:43:38 xthefull Exp $*/
// Statics vars , for events.c
#include <gtk/gtk.h>
gchar *array[] = { "clicked",                   /* 0 -- GtkButton -- */
                   "pressed",                   /* 1 -- GtkButton -- */
                   "released",                  /* 2 -- GtkButton -- */
                   "enter",                     /* 3 -- GtkButton -- */
                   "leave",                     /* 4 -- GtkButton -- */
                   "toggled",                   /* 5 -- GtkToggleButton*/
                   "delete-event",              /* 6 -- GtkWidget -- */
                   "day-selected",              /* 7 -- GtkCalendar  -- */
                   "day-selected-double-click", /* 8 -- GtkCalendar  -- */
                   "month-changed",             /* 9 -- GtkCalendar  -- */
                   "next-month",                /*10 -- GtkCalendar  -- */
                   "next-year",                 /*11 -- GtkCalendar  -- */
                   "prev-month",                /*12 -- GtkCalendar  -- */
                   "prev-year",                 /*13 -- GtkCalendar  -- */
                   "activate",                  /*14*/
                   "focus-out-event",           /*15 -- GtkWidget -- */
                   "key-press-event",           /*16 -- GtkWidget -- */
                   "response",                  /*17 -- GtkDialog -- */
                   "destroy",                   /*18 -- GtkWidget -- */
                   "focus-in-event",            /*19 -- GtkWidget -- */
                   "changed",                   /*20*/
                   "value-changed",             /*21 -- GtkRange  -- */
                   "move-slider",               /*22 -- GtkRange  -- */
                   "expose-event",              /*23 -- GtkWidget -- */
                   "select-child",              /*24*/
                   "selection-changed",         /*25*/
                   "switch-page",               /*26*/
                   "key-release-event",         /*27 -- GtkWidget    -- */
                   "group-changed",             /*28 Pendiente, no logro que funcione! */
                   "row-activated",             /*29*/
                   "cell_toggled",              /*30 OJO! realmente la señal es toggled, para las cell.*/
                   "insert-at-cursor",          /*31*/
                   "show-menu",                 /*32*/
                   "item-activated",            /*33*/
                   "configure-event",           /*34 -- GtkWidget -- */
                   "realize" ,                  /*35 -- GtkWidget -- */
                   "unrealize" ,                /*36 -- GtkWidget -- */
                   "cursor-changed",            /*37*/
                   "edited",                    /*38*/
                   "event",                     /*39 -- GtkWidget -- */
                   "enter-notify-event" ,       /*40 -- GtkWidget -- */
                   "leave-notify-event" ,       /*41 -- GtkWidget -- */
                   "accel-closures-changed",    /*42 -- GtkWidget -- */
                   "button-press-event",        /*43 -- GtkWidget -- */
                   "button-release-event",      /*44 -- GtkWidget -- */
                   "can-activate-accel",        /*45 -- GtkWidget -- */ 
                   "child-notify",              /*46 -- GtkWidget -- */   
                   "client-event",              /*47 -- GtkWidget -- */
                   "destroy-event",             /*48 -- GtkWidget -- */
                   "direction-changed",         /*49 -- GtkWidget -- */
                   "event-after",               /*50 -- GtkWidget -- */
                   "focus",                     /*51 -- GtkWidget -- */
                   "add",                       /*52 -- GtkContainer -- */
                   "remove",                    /*53 -- GtkContainer -- */
                   "set-focus-child",           /*54 -- GtkContainer -- */
                   "check-resize",              /*55 -- GtkContainer -- */
                   "grab-broken-event",         /*56 -- GtkWidget -- */
                   "grab-focus",                /*57 -- GtkWidget -- */
                   "grab-notify",               /*58 -- GtkWidget -- */
                   "hide",                      /*59 -- GtkWidget -- */
                   "hierarchy-changed",         /*60 -- GtkWidget -- */
                   "map",                       /*61 -- GtkWidget -- */
                   "map-event",                 /*62 -- GtkWidget -- */
                   "mnemonic-activate",         /*63 -- GtkWidget -- */
                   "motion-notify-event",       /*64 -- GtkWidget -- */
                   "no-expose-event",           /*65 -- GtkWidget -- */
                   "parent-set",                /*66 -- GtkWidget -- */
                   "popup-menu",                /*67 -- GtkWidget -- */
                   "property-notify-event",     /*68 -- GtkWidget -- */
                   "proximity-in-event",        /*69 -- GtkWidget -- */
                   "proximity-out-event",       /*70 -- GtkWidget -- */
                   "screen-changed",            /*71 -- GtkWidget -- */
                   "scroll-event",              /*72 -- GtkWidget -- */
                   "selection-clear-event",     /*73 -- GtkWidget -- */
                   "selection-get",             /*74 -- GtkWidget -- */
                   "selection-notify-event",    /*75 -- GtkWidget -- */
                   "selection-received",        /*76 -- GtkWidget -- */
                   "selection-request-event",   /*77 -- GtkWidget -- */
                   "show",                      /*78 -- GtkWidget -- */
                   "show-help",                 /*79 -- GtkWidget -- */
                   "size-allocate",             /*80 -- GtkWidget -- */
                   "size-request",              /*81 -- GtkWidget -- */
                   "state-changed",             /*82 -- GtkWidget -- */
                   "style-set",                 /*83 -- GtkWidget -- */ 
                   "unmap",                     /*84 -- GtkWidget -- */
                   "unmap-event",               /*85 -- GtkWidget -- */ 
                   "visibility-notify-event",   /*86 -- GtkWidget -- */
                   "window-state-event",        /*87 -- GtkWidget -- */
                   "activate-default",          /*88 -- GtkWindow -- */
                   "activate-focus",            /*89 -- GtkWindow -- */
                   "frame-event",               /*90 -- GtkWindow -- */
                   "keys-changed",              /*91 -- GtkWindow -- */
                   "move-focus",                /*92 -- GtkWindow -- */
                   "set-focus",                 /*93 -- GtkWindow -- */
                   "close",                     /*94 -- GtkDialog -- */
                   "accept-position",           /*95 -- GtkPaned  -- */
                   "cancel-position",           /*96 -- GtkPaned  -- */
                   "cycle-child-focus",         /*97 -- GtkPaned  -- */
                   "cycle-handle-focus",        /*98 -- GtkPaned  -- */
                   "move-handle",               /*99 -- GtkPaned  -- */
                   "toggle-handle-focus",      /*100 -- GtkPaned  -- */
                   "adjust-bounds",            /*101 -- GtkRange  -- */
                   /* change-value, OJO SpinButton tiene mismo nombre, pero recibe != pararametros-- */
                   "change-value",             /*102 -- GtkRange  -- */
                   "move-focus-out",           /*103 -- GtkScrolledWindow  -- */
                   "scroll-child",             /*104 -- GtkScrolledWindow  -- */
                    };  /**/


gchar *aMethods[] = { 
                   "OnClicked",
                   "OnPressed",
                   "OnReleased",
                   "OnEnter",
                   "OnLeave", 
                   "OnToggled",
                   "OnDelete_event",
                   "OnDay_selected",
                   "OnDay_selected_double_click",
                   "OnMonth_changed",
                   "OnNext_month",
                   "OnNext_year",
                   "OnPrev_month",
                   "OnPrev_year",
                   "OnActivate", 
                   "OnFocus_out_event",
                   "OnKey_press_event",
                   "OnResponse",
                   "OnDestroy",
                   "OnFocus_in_event",
                   "OnChanged",
                   "OnValue_changed",
                   "OnMove_slider", 
                   "OnExpose_Event", 
                   "OnSelect_child", 
                   "OnSelection_changed",
                   "OnSwitch_page",
                   "OnKey_release_event", 
                   "OnGroup_changed",
                   "OnRow_Activated",
                   "OnCell_toggled", 
                   "OnInsert_At_Cursor", 
                   "OnShow_Menu", 
                   "OnItem_Activated",
                   "OnConfigure_Event", 
                   "OnRealize", 
                   "OnUnrealize", 
                   "OnCursorChanged",
                   "OnEdited", 
                   "OnEvent", 
                   "OnEnterNotifyEvent", 
                   "OnLeaveNotifyEvent",
                   "OnAccelClosuresChanged", 
                   "OnButtonPressEvent", 
                   "OnButtonReleaseEvent",
                   "OnCanActivateAccel",
                   "OnChildNotify", 
                   "OnClientEvent", 
                   "OnDestroyEvent",
                   "OnDirectionChanged", 
                   "OnEventAfter", 
                   "OnFocus",
                   "OnAdd", 
                   "OnRemove", 
                   "OnSetFocusChild",
                   "OnCheckResize",
                   "OnGrabBrokenEvent", 
                   "OnGrabFocus", 
                   "OnGrabNotify", 
                   "OnHide",
                   "OnHierarchyChanged", 
                   "OnMap", 
                   "OnMapEvent", 
                   "OnMnemonicActivate",
                   "OnMotionNotifyEvent", 
                   "OnNoExposeEvent", 
                   "OnParentSet", 
                   "OnPopupMenu",
                   "OnPropertyNotifyEvent", 
                   "OnProximityInEvent", 
                   "OnProximityOutEvent",
                   "OnScreenChanged", 
                   "OnScrollEvent", 
                   "OnSelectionClearEvent",
                   "OnSelectionGet",
                   "OnSelectionNotifyEvent",
                   "OnSelectionReceived", 
                   "OnSelectionRequestEvent",
                   "OnShow", 
                   "OnShowHelp", 
                   "OnSizeAllocate", 
                   "OnSizeRequest", 
                   "OnStateChanged",
                   "OnStyleSet", 
                   "OnUnMap", 
                   "OnUnMapEvent", 
                   "OnVisibilityNotifyEvent",
                   "OnWindowStateEvent", 
                   "OnActivateDefault", 
                   "OnActivateFocus", 
                   "OnFrameEvent",
                   "OnKeysChanged", 
                   "OnMoveFocus", 
                   "OnSetFocus", 
                   "OnClose",
                   "OnAcceptPosition", 
                   "OnCancelPosition", 
                   "OnCycleChildFocus", 
                   "OnCycleHandleFocus",
                   "OnMoveHandle", 
                   "OnToggleHandleFocus" , 
                   "OnAdjustBounds", 
                   "OnChangeValue",
                   "OnMoveFocusOut", 
                   "OnScrollChild" };
