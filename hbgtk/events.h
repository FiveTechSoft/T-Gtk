/* $Id: events.h,v 1.10 2007-03-16 22:37:07 xthefull Exp $*/
// Statics vars , for events.c

static TGtkActionParce array[] = {
               {"clicked",                   "OnClicked",                   G_CALLBACK( OnEventos ),NULL},                /* 0 -- GtkButton -- */
               {"pressed",                   "OnPressed",                   G_CALLBACK( OnEventos ),NULL},                /* 1 -- GtkButton -- */
               {"released",                  "OnReleased",                  G_CALLBACK( OnEventos ),NULL},                /* 2 -- GtkButton -- */
               {"enter",                     "OnEnter",                     G_CALLBACK( OnEventos ),NULL},                /* 3 -- GtkButton -- */
               {"leave",                     "OnLeave",                     G_CALLBACK( OnEventos ),NULL},                /* 4 -- GtkButton -- */
               {"toggled",                   "OnToggled",                   G_CALLBACK( OnEventos ),NULL},                /* 5 -- GtkToggleButton*/
               {"delete-event",              "OnDelete_event",              G_CALLBACK( OnDelete_Event ),NULL},           /* 6 -- GtkWidget -- */
               {"day-selected",              "OnDay_selected",              G_CALLBACK( OnEventos ),NULL},                /* 7 -- GtkCalendar  -- */
               {"day-selected-double-click", "OnDay_selected_double_click", G_CALLBACK( OnEventos ),NULL},                /* 8 -- GtkCalendar  -- */
               {"month-changed",             "OnMonth_changed",             G_CALLBACK( OnEventos ),NULL},                /* 9 -- GtkCalendar  -- */
               {"next-month",                "OnNext_month",                G_CALLBACK( OnEventos ),NULL},                /*10 -- GtkCalendar  -- */
               {"next-year",                 "OnNext_year",                 G_CALLBACK( OnEventos ),NULL},                /*11 -- GtkCalendar  -- */
               {"prev-month",                "OnPrev_month",                G_CALLBACK( OnEventos ),NULL},                /*12 -- GtkCalendar  -- */
               {"prev-year",                 "OnPrev_year",                 G_CALLBACK( OnEventos ),NULL},                /*13 -- GtkCalendar  -- */
               {"activate",                  "OnActivate",                  G_CALLBACK( OnEventos ),NULL},                /*14*/
               {"focus-out-event",           "OnFocus_out_event",           G_CALLBACK( OnFocusEvent ),NULL},             /*15 -- GtkWidget -- */
               {"key-press-event",           "OnKey_press_event",           G_CALLBACK( OnKeyPressEvent ),NULL},          /*16 -- GtkWidget -- */
               {"response",                  "OnResponse",                  G_CALLBACK( OnResponse ),NULL},               /*17 -- GtkDialog -- */
               {"destroy",                   "OnDestroy",                   G_CALLBACK( OnEventos ),NULL},                /*18 -- GtkWidget -- */
               {"focus-in-event",            "OnFocus_in_event",            G_CALLBACK( OnFocusEvent ),NULL},             /*19 -- GtkWidget -- */
               {"changed",                   "OnChanged",                   G_CALLBACK( OnEventos ),NULL},                /*20*/
               {"value-changed",             "OnValue_changed",             G_CALLBACK( OnEventos ),NULL},                /*21 -- GtkRange  -- */
               {"move-slider",               "OnMove_slider",               G_CALLBACK( OnMove_slider ),NULL},            /*22 -- GtkRange  -- */
               {"expose-event",              "OnExpose_Event",              G_CALLBACK( OnExpose_Event ),NULL},           /*23 -- GtkWidget -- */
               {"select-child",              "OnSelect_child",              G_CALLBACK( OnSelect_child ),NULL},           /*24*/
               {"selection-changed",         "OnSelection_changed",         G_CALLBACK( OnSelection_changed ),NULL},      /*25*/
               {"switch-page",               "OnSwitch_page",               G_CALLBACK( OnSwitch_page ),NULL},            /*26*/
               {"key-release-event",         "OnKey_release_event",         G_CALLBACK( OnKeyPressEvent ),NULL},          /*27 -- GtkWidget    -- */
               {"group-changed",             "OnGroup_changed",             G_CALLBACK( OnGroup_changed ),NULL},          /*28 Pendiente, no logro que funcione! */
               {"row-activated",             "OnRow_Activated",             G_CALLBACK( OnRow_activated ),NULL},          /*29*/
               {"toggled",                   "OnCell_toggled",              G_CALLBACK( OnCell_toggled ), "GtkCellRendererToggle" },           /*30 OJO! realmente la señal es toggled, para las cell.*/
               {"insert-at-cursor",          "OnInsert_At_Cursor",          G_CALLBACK( OnInsert_at_cursor ),NULL},       /*31*/
               {"show-menu",                 "OnShow_Menu",                 G_CALLBACK( OnEventos ),NULL},                /*32*/
               {"item-activated",            "OnItem_Activated",            G_CALLBACK( OnItem_Activated ),NULL},         /*33*/
               {"configure-event",           "OnConfigure_Event",           G_CALLBACK( OnConfigure_Event ),NULL},        /*34 -- GtkWidget -- */
               {"realize",                   "OnRealize",                   G_CALLBACK( OnEventos_void ),NULL},           /*35 -- GtkWidget -- */
               {"unrealize",                 "OnUnrealize",                 G_CALLBACK( OnEventos_void ),NULL},           /*36 -- GtkWidget -- */
               {"cursor-changed",            "OnCursorChanged",             G_CALLBACK( OnCursor_Changed ),NULL},         /*37*/
               {"edited",                    "OnEdited",                    G_CALLBACK( OnEdited ),NULL},                 /*38*/
               {"event",                     "OnEvent",                     G_CALLBACK( OnDelete_Event ),NULL},           /*39 -- GtkWidget -- */
               {"enter-notify-event",        "OnEnterNotifyEvent",          G_CALLBACK( OnEnter_Leave_NotifyEvent ),NULL},/*40 -- GtkWidget -- */
               {"leave-notify-event",        "OnLeaveNotifyEvent",          G_CALLBACK( OnEnter_Leave_NotifyEvent ),NULL},/*41 -- GtkWidget -- */
               {"accel-closures-changed",    "OnAccelClosuresChanged",      G_CALLBACK( OnEventos_void ),NULL},           /*42 -- GtkWidget -- */
               {"button-press-event",        "OnButtonPressEvent",          G_CALLBACK( OnButton_Press_Event ),NULL},     /*43 -- GtkWidget -- */
               {"button-release-event",      "OnButtonReleaseEvent",        G_CALLBACK( OnButton_Press_Event ),NULL},     /*44 -- GtkWidget -- */
               {"can-activate-accel",        "OnCanActivateAccel",          G_CALLBACK( OnCan_Activate_Accel ),NULL},     /*45 -- GtkWidget -- */
               {"child-notify",              "OnChildNotify",               G_CALLBACK( OnChild_Notify ),NULL},           /*46 -- GtkWidget -- */
               {"client-event",              "OnClientEvent",               G_CALLBACK( OnClient_Event ),NULL},           /*47 -- GtkWidget -- */
               {"destroy-event",             "OnDestroyEvent",              G_CALLBACK( OnDelete_Event ),NULL},           /*48 -- GtkWidget -- */
               {"direction-changed",         "OnDirectionChanged",          G_CALLBACK( OnDirection_Changed ),NULL},      /*49 -- GtkWidget -- */
               {"event-after",               "OnEventAfter",                G_CALLBACK( OnEvent_After ),NULL},            /*50 -- GtkWidget -- */
               {"focus",                     "OnFocus",                     G_CALLBACK( OnFocus ),NULL},                  /*51 -- GtkWidget -- */
               {"add",                       "OnAdd",                       G_CALLBACK( OnSignals_Container ),NULL},      /*52 -- GtkContainer -- */
               {"remove",                    "OnRemove",                    G_CALLBACK( OnSignals_Container ),NULL},      /*53 -- GtkContainer -- */
               {"set-focus-child",           "OnSetFocusChild",             G_CALLBACK( OnSignals_Container ),NULL},      /*54 -- GtkContainer -- */
               {"check-resize",              "OnCheckResize",               G_CALLBACK( OnCheck_Resize ),NULL},           /*55 -- GtkContainer -- */
               #if GTK_CHECK_VERSION(2,8,0)
               {"grab-broken-event",         "OnGrabBrokenEvent",           G_CALLBACK( OnGrab_Broken_Event ),NULL},      /*56 -- GtkWidget -- */
               #endif
               {"grab-focus",                "OnGrabFocus",                 G_CALLBACK( OnEventos_void ),NULL},           /*57 -- GtkWidget -- */
               {"grab-notify",               "OnGrabNotify",                G_CALLBACK( OnGrab_Notify ),NULL},            /*58 -- GtkWidget -- */
               {"hide",                      "OnHide",                      G_CALLBACK( OnEventos_void ),NULL},           /*59 -- GtkWidget -- */
               {"hierarchy-changed",         "OnHierarchyChanged",          G_CALLBACK( OnHierarchy_Changed ),NULL},      /*60 -- GtkWidget -- */
               {"map",                       "OnMap",                       G_CALLBACK( OnEventos_void ),NULL},           /*61 -- GtkWidget -- */
               {"map-event",                 "OnMapEvent",                  G_CALLBACK( OnDelete_Event ),NULL},           /*62 -- GtkWidget -- */
               {"mnemonic-activate",         "OnMnemonicActivate",          G_CALLBACK( OnMnemonic_Activate ),NULL},      /*63 -- GtkWidget -- */
               {"motion-notify-event",       "OnMotionNotifyEvent",         G_CALLBACK( OnMotion_Notify_Event ),NULL},    /*64 -- GtkWidget -- */
               {"no-expose-event",           "OnNoExposeEvent",             G_CALLBACK( OnNo_Expose_Event ),NULL},        /*65 -- GtkWidget -- */
               {"parent-set",                "OnParentSet",                 G_CALLBACK( OnParent_Set ),NULL},             /*66 -- GtkWidget -- */
               {"popup-menu",                "OnPopupMenu",                 G_CALLBACK( OnEventos ),NULL},                /*67 -- GtkWidget -- */
               {"property-notify-event",     "OnPropertyNotifyEvent",       G_CALLBACK( OnProperty_Notify_Event ),NULL},  /*68 -- GtkWidget -- */
               {"proximity-in-event",        "OnProximityInEvent",          G_CALLBACK( OnProximity_Event ),NULL},        /*69 -- GtkWidget -- */
               {"proximity-out-event",       "OnProximityOutEvent",         G_CALLBACK( OnProximity_Event ),NULL},        /*70 -- GtkWidget -- */
               {"screen-changed",            "OnScreenChanged",             G_CALLBACK( OnScreen_Changed ),NULL},         /*71 -- GtkWidget -- */
               {"scroll-event",              "OnScrollEvent",               G_CALLBACK( OnScroll_Event ),NULL},           /*72 -- GtkWidget -- */
               {"selection-clear-event",     "OnSelectionClearEvent",       G_CALLBACK( OnSelection_Event ),NULL},        /*73 -- GtkWidget -- */
               {"selection-get",             "OnSelectionGet",              G_CALLBACK( OnSelection_Get ),NULL},          /*74 -- GtkWidget -- */
               {"selection-notify-event",    "OnSelectionNotifyEvent",      G_CALLBACK( OnSelection_Event ),NULL},        /*75 -- GtkWidget -- */
               {"selection-received",        "OnSelectionReceived",         G_CALLBACK( OnSelection_Received ),NULL},     /*76 -- GtkWidget -- */
               {"selection-request-event",   "OnSelectionRequestEvent",     G_CALLBACK( OnSelection_Event ),NULL},        /*77 -- GtkWidget -- */
               {"show",                      "OnShow",                      G_CALLBACK( OnEventos_void ),NULL},           /*78 -- GtkWidget -- */
               {"show-help",                 "OnShowHelp",                  G_CALLBACK( OnShow_Help ),NULL},              /*79 -- GtkWidget -- */
               {"size-allocate",             "OnSizeAllocate",              G_CALLBACK( OnSize_Allocate ),NULL},          /*80 -- GtkWidget -- */
               {"size-request",              "OnSizeRequest",               G_CALLBACK( OnSize_Request ),NULL},           /*81 -- GtkWidget -- */
               {"state-changed",             "OnStateChanged",              G_CALLBACK( OnState_Changed ),NULL},          /*82 -- GtkWidget -- */
               {"style-set",                 "OnStyleSet",                  G_CALLBACK( OnStyle_Set ),NULL},              /*83 -- GtkWidget -- */
               {"unmap",                     "OnUnMap",                     G_CALLBACK( OnEventos_void ),NULL},           /*84 -- GtkWidget -- */
               {"unmap-event",               "OnUnMapEvent",                G_CALLBACK( OnDelete_Event ),NULL},           /*85 -- GtkWidget -- */
               {"visibility-notify-event",   "OnVisibilityNotifyEvent",     G_CALLBACK( OnVisibility_Notify_Event ),NULL},/*86 -- GtkWidget -- */
               {"window-state-event",        "OnWindowStateEvent",          G_CALLBACK( OnWindow_State_Event ),NULL},     /*87 -- GtkWidget -- */
               {"activate-default",          "OnActivateDefault",           G_CALLBACK( OnEventos_void ),NULL},           /*88 -- GtkWindow -- */
               {"activate-focus",            "OnActivateFocus",             G_CALLBACK( OnEventos_void ),NULL},           /*89 -- GtkWindow -- */
               {"frame-event",               "OnFrameEvent",                G_CALLBACK( OnDelete_Event ),NULL},           /*90 -- GtkWindow -- */
               {"keys-changed",              "OnKeysChanged",               G_CALLBACK( OnEventos_void ),NULL},           /*91 -- GtkWindow -- */
               {"move-focus",                "OnMoveFocus",                 G_CALLBACK( OnMove_Focus ),NULL},             /*92 -- GtkWindow -- */
               {"set-focus",                 "OnSetFocus",                  G_CALLBACK( OnHierarchy_Changed ),NULL},      /*93 -- GtkWindow -- */
               {"close",                     "OnClose",                     G_CALLBACK( OnEventos_void ),NULL},           /*94 -- GtkDialog -- */
               {"accept-position",           "OnAcceptPosition",            G_CALLBACK( OnEventos ),NULL},                /*95 -- GtkPaned  -- */
               {"cancel-position",           "OnCancelPosition",            G_CALLBACK( OnEventos ),NULL},                /*96 -- GtkPaned  -- */
               {"cycle-child-focus",         "OnCycleChildFocus",           G_CALLBACK( OnCycle_Child_Focus ),NULL},      /*97 -- GtkPaned  -- */
               {"cycle-handle-focus",        "OnCycleHandleFocus",          G_CALLBACK( OnCycle_Child_Focus ),NULL},      /*98 -- GtkPaned  -- */
               {"move-handle",               "OnMoveHandle",                G_CALLBACK( OnMove_Handle ),NULL},            /*99 -- GtkPaned  -- */
               {"toggle-handle-focus",       "OnToggleHandleFocus",         G_CALLBACK( OnEventos ),NULL},                /*100 -- GtkPaned  -- */
               {"adjust-bounds",             "OnAdjustBounds",              G_CALLBACK( OnAdjust_Bounds ),NULL},          /*101 -- GtkRange  -- */
               /* change-value, OJO SpinButton tiene mismo nombre, pero recibe != pararametros-- */
               {"change-value",              "OnChangeValue",               G_CALLBACK( OnChange_Value ),NULL},           /*102 -- GtkRange  -- */
               {"move-focus-out",            "OnMoveFocusOut",              G_CALLBACK( OnMove_Focus ),NULL},             /*103 -- GtkScrolledWindow  -- */
               {"scroll-child",              "OnScrollChild",               G_CALLBACK( OnScroll_Child ),NULL},           /*104 -- GtkScrolledWindow  -- */
               {"backspace",                 "OnBackspace",                 G_CALLBACK( OnBackspace ),NULL},             /*105 -- GtkEntry  -- */
               {"copy-clipboard",            "OnCopy_Clipboard",            G_CALLBACK( OnCopy_Clipboard ),NULL},         /*106 -- GtkEntry  -- */
               {"cut-clipboard",             "OnCut_Clipboard",             G_CALLBACK( OnCut_Clipboard ),NULL},          /*107 -- GtkEntry  -- */
               {"delete-from-cursor",        "OnDelete_From_Cursor",        G_CALLBACK( OnDelete_From_Cursor ),NULL},     /*108 -- GtkEntry  -- */
               {"move-cursor",               "OnMove_Cursor",               G_CALLBACK( OnMove_Cursor ),NULL},           /*109 -- GtkEntry  -- void  OnMove_Cursor(GtkEntry *entry, GtkMovementStep *arg1, gint arg2, gboolean  arg3, gpointer  user_data)*/
               {"paste-clipboard",           "OnPaste_Clipboard",           G_CALLBACK( OnPaste_Clipboard ),NULL},       /*111 -- GtkEntry  -- void   OnPaste_Clipboard(GtkEntry *entry, gpointer  user_data)*/
               {"populate-popup",            "OnPopulate_Popup",            G_CALLBACK( OnPopulate_Popup ),NULL},        /*112 -- GtkEntry  -- void  OnPopulate_Popup(GtkEntry *entry,GtkMenu  *arg1, gpointer  user_data) */
               #if GTK_CHECK_VERSION(2,10,0)
               {"begin-print",               "OnBegin_Print",               G_CALLBACK( OnBegin_Print ),NULL},            /*114 -- GtkPrintOperation */
               {"end-print",                 "OnEnd_Print",                 G_CALLBACK( OnBegin_Print ),NULL},            /*115 -- GtkPrintOperation */
               {"draw-page",                 "OnDraw_Page",                 G_CALLBACK( OnDraw_Page ),NULL},              /*116 -- GtkPrintOperation */
               {"request-page-setup",        "OnRequest_Page_Setup",        G_CALLBACK( OnRequest_Page_Setup ),NULL},     /*117 -- GtkPrintOperation */
               {"paginate",                  "OnPaginate",                  G_CALLBACK( OnPaginate ),NULL},               /*118 -- GtkPrintOperation */
               {"apply",                     "OnApply",                     G_CALLBACK( OnEventos_void ),NULL},           /*119 -- GtkAssistant */
               {"cancel",                    "OnCancel",                    G_CALLBACK( OnEventos_void ),NULL},           /*120 -- GtkAssistant */
               {"close",                     "Onclose",                     G_CALLBACK( OnEventos_void ),NULL},           /*121 -- GtkAssistant */
               {"prepare",                   "OnPrepare",                   G_CALLBACK( OnPrepare ),NULL},                /*122 -- GtkAssistant */
               {"popup-menu",                "OnPopupMenu",                 G_CALLBACK( OnPopupMenu ),"GtkStatusIcon"},     /*123 -- GtkStatusIcon -- */
               #endif
               {"toggle-overwrite",          "OnToggle_Overwrite",          G_CALLBACK( OnToggle_Overwrite ),NULL}        /*113 -- GtkEntry  -- void  OnToggle_Overwrite(GtkEntry *entry, gpointer  user_data) */

};  /**/

#define COUNT_ARRAY     122


static TGtkPreDfnParce predefine[] = {
               {"toggled" } ,
               {"popup-menu" },
};
#define CONTT_PREDEFINE 1

