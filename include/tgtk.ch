/*  $Id: tgtk.ch,v 1.2 2008-10-16 14:55:00 riztan Exp $ */

/*
 * Definicion de comandos para T-Gtk.
 * (c)2008 Riztan Gutierrez
 */

#xtranslate MsgAlert( <cMessage> [, <cTitle> ] [ <lMarkup: MARKUP> ] );
            =>;
            Msg_Alert( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ] )


#xtranslate MsgInfo( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_Info( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ],[ <cIconFile> ] )


#xtranslate MsgStop( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_Stop( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ],[ <cIconFile> ] )


#xtranslate MsgNoYes( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_NoYes( <cMessage>,[ <cTitle> ], .F. ,[ <.lMarkup.> ] , [ <cIconFile> ] )


#xtranslate MsgYesNo( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_NoYes( <cMessage>,[ <cTitle> ],.T.,[ <.lMarkup.> ] , [ <cIconFile> ] )


#xtranslate MsgOkCancel( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_OkCancel( <cMessage>,[ <cTitle> ],.T.,[ <.lMarkup.> ],[ <cIconFile> ] )

#xtranslate MsgCancelOk( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_OkCancel( <cMessage>,[ <cTitle> ],.F.,[ <.lMarkup.> ],[ <cIconFile> ] )


