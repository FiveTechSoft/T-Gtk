/*
 * $Id: postgres.ch,v 1.3 2009-12-11 21:13:40 riztan Exp $
 */

#define VARHDRSZ                        4


#define CONNECTION_OK                   0
#define CONNECTION_BAD                  1
#define CONNECTION_STARTED              2
#define CONNECTION_MADE                 3
#define CONNECTION_AWAITING_RESPONSE    4
#define CONNECTION_AUTH_OK              5
#define CONNECTION_SETENV               6
#define CONNECTION_SSL_STARTUP          7
#define CONNECTION_NEEDED               8


/*
 *  Respuestas de PQResultStatus
*/
#define PGRES_EMPTY_QUERY               0
#define PGRES_COMMAND_OK                1
#define PGRES_TUPLES_OK                 2
#define PGRES_COPY_OUT                  3
#define PGRES_COPY_IN                   4
#define PGRES_BAD_RESPONSE              5
#define PGRES_NONFATAL_ERROR            6
#define PGRES_FATAL_ERROR               7

#define PQTRANS_IDLE                    0
#define PQTRANS_ACTIVE                  1
#define PQTRANS_INTRANS                 2
#define PQTRANS_INERROR                 3
#define PQTRANS_UNKNOWN                 4

#define PQERRORS_TERSE                  0
#define PQERRORS_DEFAULT                1
#define PQERRORS_VERBOSE                2
