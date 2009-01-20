/* $Id: gnomedb.ch,v 1.2 2009-01-20 03:01:33 riztan Exp $*/

/*
 * gnomdb.ch Fichero de definiciones de GnomeDB y GDA -----------------------
 * Porting Harbour to GTK+ power !
 * (C) 2008. Rafa Carmona -TheFull-
 */


#define GDA_CONNECTION_OPTIONS_NONE               0
#define GDA_CONNECTION_OPTIONS_READ_ONLY          1 << 0
#define GDA_CONNECTION_OPTIONS_DONT_SHARE         2 << 0


/* enum GdaConnectionFeature */

#define GDA_CONNECTION_FEATURE_AGGREGATES           0
#define GDA_CONNECTION_FEATURE_BLOBS                1
#define GDA_CONNECTION_FEATURE_INDEXES              2
#define GDA_CONNECTION_FEATURE_INHERITANCE          3
#define GDA_CONNECTION_FEATURE_NAMESPACES           4
#define GDA_CONNECTION_FEATURE_PROCEDURES           5
#define GDA_CONNECTION_FEATURE_SEQUENCES            6
#define GDA_CONNECTION_FEATURE_SQL                  7
#define GDA_CONNECTION_FEATURE_TRANSACTIONS         8
#define GDA_CONNECTION_FEATURE_SAVEPOINTS           9
#define GDA_CONNECTION_FEATURE_SAVEPOINTS_REMOVE    10
#define GDA_CONNECTION_FEATURE_TRIGGERS             11
#define GDA_CONNECTION_FEATURE_UPDATABLE_CURSOR     12
#define GDA_CONNECTION_FEATURE_USERS                13
#define GDA_CONNECTION_FEATURE_VIEWS                14
#define GDA_CONNECTION_FEATURE_XML_QUERIES          15


/* enum GdaConnectionSchema */

#define GDA_CONNECTION_SCHEMA_AGGREGATES            0
#define GDA_CONNECTION_SCHEMA_DATABASES             1
#define GDA_CONNECTION_SCHEMA_FIELDS                2
#define GDA_CONNECTION_SCHEMA_INDEXES               3
#define GDA_CONNECTION_SCHEMA_LANGUAGES             4
#define GDA_CONNECTION_SCHEMA_NAMESPACES            5
#define GDA_CONNECTION_SCHEMA_PARENT_TABLES         6
#define GDA_CONNECTION_SCHEMA_PROCEDURES            7
#define GDA_CONNECTION_SCHEMA_SEQUENCES             8
#define GDA_CONNECTION_SCHEMA_TABLES                9
#define GDA_CONNECTION_SCHEMA_TRIGGERS              10
#define GDA_CONNECTION_SCHEMA_TYPES                 11
#define GDA_CONNECTION_SCHEMA_USERS                 12
#define GDA_CONNECTION_SCHEMA_VIEWS                 13
#define GDA_CONNECTION_SCHEMA_CONSTRAINTS           14
#define GDA_CONNECTION_SCHEMA_TABLE_CONTENTS        15


/* GdaCommandOptions */
#define GDA_COMMAND_OPTION_IGNORE_ERRORS          1
#define GDA_COMMAND_OPTION_STOP_ON_ERRORS         1 << 1
#define GDA_COMMAND_OPTION_BAD_OPTION             1 << 2


/* enum GdaCommandType */
#define GDA_COMMAND_TYPE_SQL                        0
#define GDA_COMMAND_TYPE_XML                        1
#define GDA_COMMAND_TYPE_PROCEDURE                  2
#define GDA_COMMAND_TYPE_TABLE                      3
#define GDA_COMMAND_TYPE_SCHEMA                     4
#define GDA_COMMAND_TYPE_INVALID                    5


/* enum GdaTransactionIsolation */
#define GDA_TRANSACTION_ISOLATION_UNKNOWN           0
#define GDA_TRANSACTION_ISOLATION_READ_COMMITTED    1
#define GDA_TRANSACTION_ISOLATION_READ_UNCOMMITTED  2
#define GDA_TRANSACTION_ISOLATION_REPEATABLE_READ   3
#define GDA_TRANSACTION_ISOLATION_SERIALIZABLE      4


/* enum GdaDataModelIOFormat */
#define GDA_DATA_MODEL_IO_DATA_ARRAY_XML            0
#define GDA_DATA_MODEL_IO_TEXT_SEPARATED            1


