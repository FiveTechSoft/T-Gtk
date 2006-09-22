/* $Id: events.h,v 1.3 2006-09-22 09:09:04 rosenwla Exp $*/
// Statics vars , for events.c

static TGtkActionParce array[] = {
               {"clicked",                   "OnClicked",                   G_CALLBACK( OnEventos )},                /* 0 -- GtkButton -- */
               {"pressed",                   "OnPressed",                   G_CALLBACK( OnEventos )},                /* 1 -- GtkButton -- */
               {"released",                  "OnReleased",                  G_CALLBACK( OnEventos )},                /* 2 -- GtkButton -- */
               {"enter",                     "OnEnter",                     G_CALLBACK( OnEventos )},                /* 3 -- GtkButton -- */
               {"leave",                     "OnLeave",                     G_CALLBACK( OnEventos )},                /* 4 -- GtkButton -- */
               {"toggled",                   "OnToggled",                   G_CALLBACK( OnEventos )},                /* 5 -- GtkToggleButton*/
               {"delete-event",              "OnDelete_event",              G_CALLBACK( OnDelete_Event )},           /* 6 -- GtkWidget -- */
               {"day-selected",              "OnDay_selected",              G_CALLBACK( OnEventos )},                /* 7 -- GtkCalendar  -- */
               {"day-selected-double-click", "OnDay_selected_double_click", G_CALLBACK( OnEventos )},                /* 8 -- GtkCalendar  -- */
               {"month-changed",             "OnMonth_changed",             G_CALLBACK( OnEventos )},                /* 9 -- GtkCalendar  -- */
               {"next-month",                "OnNext_month",                G_CALLBACK( OnEventos )},                /*10 -- GtkCalendar  -- */
               {"next-year",                 "OnNext_year",                 G_CALLBACK( OnEventos )},                /*11 -- GtkCalendar  -- */
               {"prev-month",                "OnPrev_month",                G_CALLBACK( OnEventos )},                /*12 -- GtkCalendar  -- */
               {"prev-year",                 "OnPrev_year",                 G_CALLBACK( OnEventos )},                /*13 -- GtkCalendar  -- */
               {"activate",                  "OnActivate",                  G_CALLBACK( OnEventos )},                /*14*/
               {"focus-out-event",           "OnFocus_out_event",           G_CALLBACK( OnFocusEvent )},             /*15 -- GtkWidget -- */
               {"key-press-event",           "OnKey_press_event",           G_CALLBACK( OnKeyPressEvent )},          /*16 -- GtkWidget -- */
               {"response",                  "OnResponse",                  G_CALLBACK( OnResponse )},               /*17 -- GtkDialog -- */
               {"destroy",                   "OnDestroy",                   G_CALLBACK( OnEventos )},                /*18 -- GtkWidget -- */
               {"focus-in-event",            "OnFocus_in_event",            G_CALLBACK( OnFocusEvent )},             /*19 -- GtkWidget -- */
               {"changed",                   "OnChanged",                   G_CALLBACK( OnEventos )},                /*20*/
               {"value-changed",             "OnValue_changed",             G_CALLBACK( OnEventos )},                /*21 -- GtkRange  -- */
               {"move-slider",               "OnMove_slider",               G_CALLBACK( OnMove_slider )},            /*22 -- GtkRange  -- */
               {"expose-event",              "OnExpose_Event",              G_CALLBACK( OnExpose_Event )},           /*23 -- GtkWidget -- */
               {"select-child",              "OnSelect_child",              G_CALLBACK( OnSelect_child )},           /*24*/
               {"selection-changed",         "OnSelection_changed",         G_CALLBACK( OnSelection_changed )},      /*25*/
               {"switch-page",               "OnSwitch_page",               G_CALLBACK( OnSwitch_page )},            /*26*/
               {"key-release-event",         "OnKey_release_event",         G_CALLBACK( OnKeyPressEvent )},          /*27 -- GtkWidget    -- */
               {"group-changed",             "OnGroup_changed",             G_CALLBACK( OnGroup_changed )},          /*28 Pendiente, no logro que funcione! */
               {"row-activated",             "OnRow_Activated",             G_CALLBACK( OnRow_activated )},          /*29*/
               {"toggled",                   "OnCell_toggled",              G_CALLBACK( OnCell_toggled )},           /*30 OJO! realmente la señal es toggled, para las cell.*/
               {"insert-at-cursor",          "OnInsert_At_Cursor",          G_CALLBACK( OnInsert_at_cursor )},       /*31*/
               {"show-menu",                 "OnShow_Menu",                 G_CALLBACK( OnEventos )},                /*32*/
               {"item-activated",            "OnItem_Activated",            G_CALLBACK( OnItem_Activated )},         /*33*/
               {"configure-event",           "OnConfigure_Event",           G_CALLBACK( OnConfigure_Event )},        /*34 -- GtkWidget -- */
               {"realize",                   "OnRealize",                   G_CALLBACK( OnEventos_void )},           /*35 -- GtkWidget -- */
               {"unrealize",                 "OnUnrealize",                 G_CALLBACK( OnEventos_void )},           /*36 -- GtkWidget -- */
               {"cursor-changed",            "OnCursorChanged",             G_CALLBACK( OnCursor_Changed )},         /*37*/
               {"edited",                    "OnEdited",                    G_CALLBACK( OnEdited )},                 /*38*/
               {"event",                     "OnEvent",                     G_CALLBACK( OnDelete_Event )},           /*39 -- GtkWidget -- */
               {"enter-notify-event",        "OnEnterNotifyEvent",          G_CALLBACK( OnEnter_Leave_NotifyEvent )},/*40 -- GtkWidget -- */
               {"leave-notify-event",        "OnLeaveNotifyEvent",          G_CALLBACK( OnEnter_Leave_NotifyEvent )},/*41 -- GtkWidget -- */
               {"accel-closures-changed",    "OnAccelClosuresChanged",      G_CALLBACK( OnEventos_void )},           /*42 -- GtkWidget -- */
               {"button-press-event",        "OnButtonPressEvent",          G_CALLBACK( OnButton_Press_Event )},     /*43 -- GtkWidget -- */
               {"button-release-event",      "OnButtonReleaseEvent",        G_CALLBACK( OnButton_Press_Event )},     /*44 -- GtkWidget -- */
               {"can-activate-accel",        "OnCanActivateAccel",          G_CALLBACK( OnCan_Activate_Accel )},     /*45 -- GtkWidget -- */
               {"child-notify",              "OnChildNotify",               G_CALLBACK( OnChild_Notify )},           /*46 -- GtkWidget -- */
               {"client-event",              "OnClientEvent",               G_CALLBACK( OnClient_Event )},           /*47 -- GtkWidget -- */
               {"destroy-event",             "OnDestroyEvent",              G_CALLBACK( OnDelete_Event )},           /*48 -- GtkWidget -- */
               {"direction-changed",         "OnDirectionChanged",          G_CALLBACK( OnDirection_Changed )},      /*49 -- GtkWidget -- */
               {"event-after",               "OnEventAfter",                G_CALLBACK( OnEvent_After )},            /*50 -- GtkWidget -- */
               {"focus",                     "OnFocus",                     G_CALLBACK( OnFocus )},                  /*51 -- GtkWidget -- */
               {"add",                       "OnAdd",                       G_CALLBACK( OnSignals_Container )},      /*52 -- GtkContainer -- */
               {"remove",                    "OnRemove",                    G_CALLBACK( OnSignals_Container )},      /*53 -- GtkContainer -- */
               {"set-focus-child",           "OnSetFocusChild",             G_CALLBACK( OnSignals_Container )},      /*54 -- GtkContainer -- */
               {"check-resize",              "OnCheckResize",               G_CALLBACK( OnCheck_Resize )},           /*55 -- GtkContainer -- */
               {"grab-broken-event",         "OnGrabBrokenEvent",           G_CALLBACK( OnGrab_Broken_Event )},      /*56 -- GtkWidget -- */
               {"grab-focus",                "OnGrabFocus",                 G_CALLBACK( OnEventos_void )},           /*57 -- GtkWidget -- */
               {"grab-notify",               "OnGrabNotify",                G_CALLBACK( OnGrab_Notify )},            /*58 -- GtkWidget -- */
               {"hide",                      "OnHide",                      G_CALLBACK( OnEventos_void )},           /*59 -- GtkWidget -- */
               {"hierarchy-changed",         "OnHierarchyChanged",          G_CALLBACK( OnHierarchy_Changed )},      /*60 -- GtkWidget -- */
               {"map",                       "OnMap",                       G_CALLBACK( OnEventos_void )},           /*61 -- GtkWidget -- */
               {"map-event",                 "OnMapEvent",                  G_CALLBACK( OnDelete_Event )},           /*62 -- GtkWidget -- */
               {"mnemonic-activate",         "OnMnemonicActivate",          G_CALLBACK( OnMnemonic_Activate )},      /*63 -- GtkWidget -- */
               {"motion-notify-event",       "OnMotionNotifyEvent",         G_CALLBACK( OnMotion_Notify_Event )},    /*64 -- GtkWidget -- */
               {"no-expose-event",           "OnNoExposeEvent",             G_CALLBACK( OnNo_Expose_Event )},        /*65 -- GtkWidget -- */
               {"parent-set",                "OnParentSet",                 G_CALLBACK( OnParent_Set )},             /*66 -- GtkWidget -- */
               {"popup-menu",                "OnPopupMenu",                 G_CALLBACK( OnEventos )},                /*67 -- GtkWidget -- */
               {"property-notify-event",     "OnPropertyNotifyEvent",       G_CALLBACK( OnProperty_Notify_Event )},  /*68 -- GtkWidget -- */
               {"proximity-in-event",        "OnProximityInEvent",          G_CALLBACK( OnProximity_Event )},        /*69 -- GtkWidget -- */
               {"proximity-out-event",       "OnProximityOutEvent",         G_CALLBACK( OnProximity_Event )},        /*70 -- GtkWidget -- */
               {"screen-changed",            "OnScreenChanged",             G_CALLBACK( OnScreen_Changed )},         /*71 -- GtkWidget -- */
               {"scroll-event",              "OnScrollEvent",               G_CALLBACK( OnScroll_Event )},           /*72 -- GtkWidget -- */
               {"selection-clear-event",     "OnSelectionClearEvent",       G_CALLBACK( OnSelection_Event )},        /*73 -- GtkWidget -- */
               {"selection-get",             "OnSelectionGet",              G_CALLBACK( OnSelection_Get )},          /*74 -- GtkWidget -- */
               {"selection-notify-event",    "OnSelectionNotifyEvent",      G_CALLBACK( OnSelection_Event )},        /*75 -- GtkWidget -- */
               {"selection-received",        "OnSelectionReceived",         G_CALLBACK( OnSelection_Received )},     /*76 -- GtkWidget -- */
               {"selection-request-event",   "OnSelectionRequestEvent",     G_CALLBACK( OnSelection_Event )},        /*77 -- GtkWidget -- */
               {"show",                      "OnShow",                      G_CALLBACK( OnEventos_void )},           /*78 -- GtkWidget -- */
               {"show-help",                 "OnShowHelp",                  G_CALLBACK( OnShow_Help )},              /*79 -- GtkWidget -- */
               {"size-allocate",             "OnSizeAllocate",              G_CALLBACK( OnSize_Allocate )},          /*80 -- GtkWidget -- */
               {"size-request",              "OnSizeRequest",               G_CALLBACK( OnSize_Request )},           /*81 -- GtkWidget -- */
               {"state-changed",             "OnStateChanged",              G_CALLBACK( OnState_Changed )},          /*82 -- GtkWidget -- */
               {"style-set",                 "OnStyleSet",                  G_CALLBACK( OnStyle_Set )},              /*83 -- GtkWidget -- */
               {"unmap",                     "OnUnMap",                     G_CALLBACK( OnEventos_void )},           /*84 -- GtkWidget -- */
               {"unmap-event",               "OnUnMapEvent",                G_CALLBACK( OnDelete_Event )},           /*85 -- GtkWidget -- */
               {"visibility-notify-event",   "OnVisibilityNotifyEvent",     G_CALLBACK( OnVisibility_Notify_Event )},/*86 -- GtkWidget -- */
               {"window-state-event",        "OnWindowStateEvent",          G_CALLBACK( OnWindow_State_Event )},     /*87 -- GtkWidget -- */
               {"activate-default",          "OnActivateDefault",           G_CALLBACK( OnEventos_void )},           /*88 -- GtkWindow -- */
               {"activate-focus",            "OnActivateFocus",             G_CALLBACK( OnEventos_void )},           /*89 -- GtkWindow -- */
               {"frame-event",               "OnFrameEvent",                G_CALLBACK( OnDelete_Event )},           /*90 -- GtkWindow -- */
               {"keys-changed",              "OnKeysChanged",               G_CALLBACK( OnEventos_void )},           /*91 -- GtkWindow -- */
               {"move-focus",                "OnMoveFocus",                 G_CALLBACK( OnMove_Focus )},             /*92 -- GtkWindow -- */
               {"set-focus",                 "OnSetFocus",                  G_CALLBACK( OnHierarchy_Changed )},      /*93 -- GtkWindow -- */
               {"close",                     "OnClose",                     G_CALLBACK( OnEventos_void )},           /*94 -- GtkDialog -- */
               {"accept-position",           "OnAcceptPosition",            G_CALLBACK( OnEventos )},                /*95 -- GtkPaned  -- */
               {"cancel-position",           "OnCancelPosition",            G_CALLBACK( OnEventos )},                /*96 -- GtkPaned  -- */
               {"cycle-child-focus",         "OnCycleChildFocus",           G_CALLBACK( OnCycle_Child_Focus )},      /*97 -- GtkPaned  -- */
               {"cycle-handle-focus",        "OnCycleHandleFocus",          G_CALLBACK( OnCycle_Child_Focus )},      /*98 -- GtkPaned  -- */
               {"move-handle",               "OnMoveHandle",                G_CALLBACK( OnMove_Handle )},            /*99 -- GtkPaned  -- */
               {"toggle-handle-focus",       "OnToggleHandleFocus",         G_CALLBACK( OnEventos )},                /*100 -- GtkPaned  -- */
               {"adjust-bounds",             "OnAdjustBounds",              G_CALLBACK( OnAdjust_Bounds )},          /*101 -- GtkRange  -- */
               /* change-value, OJO SpinButton tiene mismo nombre, pero recibe != pararametros-- */
               {"change-value", "OnChangeValue",                            G_CALLBACK( OnChange_Value )},           /*102 -- GtkRange  -- */
               {"move-focus-out", "OnMoveFocusOut",                         G_CALLBACK( OnMove_Focus )},             /*103 -- GtkScrolledWindow  -- */
               {"scroll-child", "OnScrollChild",                            G_CALLBACK( OnScroll_Child )}            /*104 -- GtkScrolledWindow  -- */
};  /**/

#define COUNT_ARRAY     104

static TGtkPreDfnParce predefine[] = {
               {"toggled", "cell_toggled"}
};
#define CONTT_PREDEFINE 1

