/*  $Id: tgtk.ch,v 1.1 2008-10-07 19:38:57 riztan Exp $ */

/*
 * Definicion de comandos para T-Gtk.
 * (c)2008 Riztan Gutierrez
 */

#xcommand MsgAlert( <cMessage> [, <cTitle> ] [ <lMarkup: MARKUP> ] );
          =>;
          Msg_Alert( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ] )


#xcommand MsgInfo( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
          =>;
          Msg_Info( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ],[ <cIconFile> ] )


#xcommand MsgStop( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
          =>;
          Msg_Stop( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ],[ <cIconFile> ] )


#xcommand MsgNoYes( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
          =>;
          Msg_NoYes( <cMessage>,[ <cTitle> ], .F. ,[ <.lMarkup.> ] , [ <cIconFile> ] )


#xcommand MsgYesNo( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
          =>;
          Msg_NoYes( <cMessage>,[ <cTitle> ],.T.,[ <.lMarkup.> ] , [ <cIconFile> ] )


#xcommand MsgOkCancel( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
          =>;
          Msg_OkCancel( <cMessage>,[ <cTitle> ],.T.,[ <.lMarkup.> ],[ <cIconFile> ] )

#xcommand MsgCancelOk( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
          =>;
          Msg_OkCancel( <cMessage>,[ <cTitle> ],.F.,[ <.lMarkup.> ],[ <cIconFile> ] )



