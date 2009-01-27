/*  $Id: tgtkext.ch,v 1.4 2009-01-27 14:51:55 riztan Exp $ */
/*
 * Llamadas externas para ejecutar desde script.
 * (c)2008 Riztan Gutierrez
 */

 EXTERNAL TIPCLIENTHTTP

 EXTERNAL MSG_INFO
 EXTERNAL MSGBOX
 EXTERNAL MSG_NOYES
 EXTERNAL MSG_OKCANCEL
// EXTERNAL MSG_ALERT

// GTK Functions
 EXTERNAL GTK_WINDOW_SET_ICON
 EXTERNAL GTK_WINDOW_SET_ICON_NAME
 EXTERNAL GTK_WINDOW_SET_ICON_FROM_FILE

/*
 EXTERNAL MSGABOUT
 EXTERNAL MSGBEEP
 EXTERNAL MSGGET
 EXTERNAL MSGLOGO
 EXTERNAL MSGMETER
 EXTERNAL MSGRUN
*/

 EXTERNAL GCALENDAR
 EXTERNAL GMENU
 EXTERNAL GMENUITEM
 EXTERNAL GMENUSEPARATOR
 EXTERNAL GSTATUSBAR
 EXTERNAL GIMAGE
 EXTERNAL GMENUBAR
 EXTERNAL GMENUTEAROFF
 EXTERNAL GMENUITEMCHECK
 EXTERNAL GMENUITEMIMAGE
 EXTERNAL GTOOLTIP
 EXTERNAL GTOGGLEBUTTON
 EXTERNAL GENTRY
 EXTERNAL GSPINBUTTON
 EXTERNAL GCHECKBOX
 EXTERNAL GTREEVIEWCOLUMN
 EXTERNAL GTEXTVIEW
 EXTERNAL GSOURCEVIEW
 EXTERNAL GTOOLBAR
 EXTERNAL GTOOLBUTTON
 EXTERNAL GBUTTON

 /* native */
 EXTERNAL GTK_CONTAINER
 EXTERNAL GTK_WIDGET_SHOW_ALL

 /* gnomedb */
 EXTERNAL GNOME_DB_INIT
 EXTERNAL GNOME_DB_LOGIN_DIALOG_NEW
 EXTERNAL GNOME_DB_LOGIN_DIALOG_RUN
 EXTERNAL GNOME_DB_LOGIN_DIALOG_GET_DSN
 EXTERNAL GNOME_DB_LOGIN_DIALOG_GET_USERNAME
 EXTERNAL GNOME_DB_LOGIN_DIALOG_GET_PASSWORD
 EXTERNAL GNOME_DB_GRID_NEW

 /* gda_config */
 EXTERNAL GDA_CONFIG_SAVE_DATA_SOURCE
 EXTERNAL GDA_CONFIG_REMOVE_DATA_SOURCE
 EXTERNAL GDA_CONFIG_GET_PROVIDER_LIST
 EXTERNAL GDA_CONFIG_GET_DATA_SOURCE_LIST

 /* gda_client */
 EXTERNAL GDA_CLIENT_NEW
 EXTERNAL GDA_CLIENT_GET_CONNECTIONS
 EXTERNAL GDA_CLIENT_OPEN_CONNECTION
 EXTERNAL GDA_CLIENT_CLOSE_ALL_CONNECTION
 EXTERNAL GDA_CLIENT_BEGIN_TRANSACTION
 EXTERNAL GDA_CLIENT_COMMIT_TRANSACTION
 EXTERNAL GDA_CLIENT_ROLLBACK_TRANSACTION
 EXTERNAL GDA_CLIENT_GET_DSN_SPECS 
 
 /* gda_command */
 EXTERNAL GDA_COMMAND_NEW
 
 /* gda_connection */
 EXTERNAL GDA_CONNECTION_EXECUTE_SELECT_COMMAND
 EXTERNAL GDA_CONNECTION_EXECUTE_NON_SELECT_COMMAND
 EXTERNAL GDA_CONNECTION_CLOSE
 EXTERNAL GDA_CONNECTION_SUPPORTS_FEATURE
 EXTERNAL GDA_CONNECTION_IS_OPENED
 EXTERNAL GDA_CONNECTION_GET_SERVER_VERSION
 EXTERNAL GDA_CONNECTION_GET_DATABASE
 EXTERNAL GDA_CONNECTION_SET_DSN
 EXTERNAL GDA_CONNECTION_GET_DSN
 EXTERNAL GDA_CONNECTION_GET_CNC_STRING
 EXTERNAL GDA_CONNECTION_GET_PROVIDER
 EXTERNAL GDA_CONNECTION_SET_USERNAME
 EXTERNAL GDA_CONNECTION_GET_USERNAME
 EXTERNAL GDA_CONNECTION_SET_PASSWORD 
 EXTERNAL GDA_CONNECTION_GET_PASSWORD
 EXTERNAL GDA_CONNECTION_CHANGE_DATABASE
 EXTERNAL GDA_CONNECTION_BEGIN_TRANSACTION
 EXTERNAL GDA_CONNECTION_COMMIT_TRANSACTION
 EXTERNAL GDA_CONNECTION_ROLLBACK_TRANSACTION
 EXTERNAL GDA_CONNECTION_ADD_SAVEPOINT
 EXTERNAL GDA_CONNECTION_ROLLBACK_SAVEPOINT
 EXTERNAL GDA_CONNECTION_DELETE_SAVEPOINT
 

 /* gda_data_model */
 //EXTERNAL GDA_DATA_MODEL_ROW_INSERTED
 EXTERNAL GDA_DATA_MODEL_FREEZE
 EXTERNAL GDA_DATA_MODEL_THAW
 EXTERNAL GDA_DATA_MODEL_GET_N_ROWS
 EXTERNAL GDA_DATA_MODEL_GET_N_COLUMNS
 EXTERNAL GDA_DATA_MODEL_DESCRIBE_COLUMN
 EXTERNAL GDA_DATA_MODEL_GET_COLUMN_INDEX_BY_NAME
 EXTERNAL GDA_DATA_MODEL_GET_COLUMN_TITLE
 EXTERNAL GDA_DATA_MODEL_SET_COLUMN_TITLE
// EXTERNAL GDA_DATA_MODEL_GET_ATTRIBUTES_AT
 EXTERNAL GDA_DATA_MODEL_GET_VALUE_AT
 EXTERNAL GDA_DATA_MODEL_CREATE_ITER
 EXTERNAL GDA_DATA_MODEL_APPEND_VALUES
 EXTERNAL GDA_DATA_MODEL_APPEND_ROW
 EXTERNAL GDA_DATA_MODEL_REMOVE_ROW
 EXTERNAL GDA_DATA_MODEL_DUMP
 EXTERNAL GDA_DATA_MODEL_DUMP_AS_STRING
 EXTERNAL GDA_DATA_MODEL_ITER_NEW
 EXTERNAL GDA_DATA_MODEL_ITER_IS_VALID
 EXTERNAL GDA_DATA_MODEL_ITER_MOVE_NEXT
 EXTERNAL GDA_DATA_MODEL_ITER_MOVE_PREV
 EXTERNAL GDA_DATA_MODEL_ITER_GET_ROW
 EXTERNAL GDA_DATA_MODEL_ITER_INVALIDATE_CONTENTS
 EXTERNAL GDA_DATA_MODEL_ITER_GET_COLUMN_FOR_PARAM
 
 
 
 /* CURL */
 EXTERNAL CURL_EASY_INIT
 EXTERNAL CURL_EASY_CLEANUP
 EXTERNAL CURL_EASY_DUPHANDLE
// EXTERNAL CURL_EASY_GETINFO
 EXTERNAL CURL_EASY_SETOPT
 EXTERNAL CURL_EASY_STRERROR
 EXTERNAL CURL_EASY_PERFORM
 EXTERNAL CURL_VERSION  
 EXTERNAL FILE_OPEN
 EXTERNAL FILE_CLOSE
