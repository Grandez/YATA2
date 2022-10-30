MARIADB = R6::R6Class("YATA.DB.MARIADB"
   ,inherit    = YATADB
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
        initialize = function(data) {
           super$initialize()
           self$name        = data$name
           private$dbInfo   = data
           private$connRead = connect()
       }
      ,finalize = function() { destroy() }
      ,destroy  = function() {
          if (!is.null(connTran)) commit()
          disconnect(connTran)
          disconnect(connRead)
      }
      ,print      = function() {
          db = ifelse(is.null(connRead), "No Connection", paste0(dbInfo$name, " (", dbInfo$dbname, ")"))
          message(db, ": MariaDB Database")
      }
      ,isValid = function(conn) {
          if (missing(conn)) conn = connRead
          rc = RMariaDB::dbIsValid(conn)
          rc
      }
      ,getName    = function ()     { dbInfo$dbname }
      ,connect    = function (data) {
          if (!missing(data)) private$dbInfo = data
          tryCatch({RMariaDB::dbConnect( drv = RMariaDB::MariaDB()
                                        ,username = dbInfo$user
                                        ,password = dbInfo$password
                                        ,host     = dbInfo$host
                                        ,port     = dbInfo$port
                                        ,dbname   = dbInfo$dbname
                    )
          },error = function(cond) {
              browser()
              YATATools::SQL( "DB Connection error", origin=cond$message
                             ,action="connect", rc = getSQLCode(cond)
                             ,sql="connect")
          })
      }
      ,disconnect = function(conn) {
          if (missing(conn)) conn = private$connRead
          if (!is.null(conn) && isValid(conn))  {
              tryCatch({ RMariaDB::dbDisconnect(conn)
                       },error = function(cond) {
                              YATATools::SQL( "DB Disconnect", origin=cond$message
                             ,action="disconnect", rc = getSQLCode(cond)
                             ,sql = "disconnect")
                       })
          }
          NULL
      }
      ,begin      = function(conn) {
          if (!missing(conn)) { # isolated
              RMariaDB::dbBegin(conn)
              return (invisible(self))
          }
          if (!is.null(connTran)) {
              WARN( "Transacciones activas", "YATATools::SQL", origin=NULL
                             ,action="begin", rc = 1192 # Transaction active
                             ,sql="begin")
          }
          private$connTran = connect()
          RMariaDB::dbBegin(connTran)
          invisible(self)
      }
      ,commit     = function(conn) {
          if (!missing(conn)) {
              RMariaDB::dbCommit(conn)
              disconnect(conn)
          } else if (!is.null(private$connTran)) {
              RMariaDB::dbCommit(connTran)
              private$connTran = disconnect(connTran)
          }
          invisible(self)
      }
      ,rollback   = function(conn) {
          if (!missing(conn)) {
              RMariaDB::dbRollback(conn)
              disconnect(conn)
          } else if (!is.null(private$connTran)) {
              RMariaDB::dbRollback   (connTran)
              private$connTran = disconnect(connTran)
          }
          invisible(self)
      }
      ,query      = function(qry, params=NULL) {
          if (!is.null(params)) names(params) = NULL
          tryCatch({ RMariaDB::dbGetQuery(getConn(), qry, params=params)
              }, error = function (cond) {
                  browser()
                YATATools::SQL( "QUERY Error",  origin=cond$message
                               ,action="query", rc = getSQLCode(cond)
                               ,sql=qry)
          })
      }
      ,execute    = function(qry, params=NULL, isolated=FALSE) {
          # isolated crea una transaccion para esa query
          # Si son varias acciones se activa con begin - commit

          if (!is.null(params)) names(params) = NULL
          tryCatch({
              conn = getConn(isolated)
              res = RMariaDB::dbExecute(conn, qry, params=params)
              if (isolated) commit(conn)
          },warning = function(cond) {
              browser()
               if (isolated) rollback(conn)
               YATATools::SQL("EXECUTE", origin=cond$message, sql=qry, action="execute")
          },error = function (cond) {
              browser()
               sqlcode = getSQLCode(cond)
#               if (sqlcode == 1205) isolated = TRUE # Table lock
               if (isolated) rollback(conn)
               YATATools::SQL( "YATATools::SQL EXECUTE ERROR",origin=cond$message,sql=qry
                              ,action="execute", rc = getSQLCode(cond))
          })
      }
      ,write      = function(table, data, append=TRUE, isolated=FALSE) {
         over = ifelse(append, FALSE, TRUE)
         tryCatch({
             conn = getConn(isolated)
             res = RMariaDB::dbWriteTable(conn, table, data, append=append, overwrite=over)
             if (isolated) commit(conn)
         }, warning = function(cond) {
#                       yataWarning("Warning YATATools::SQL", cond, "YATATools::SQL", "WriteTable", cause=tab#le)
                     stop(paste("Aviso en DB Write: ", cond$message))
         }, error   = function(cond) {
            if (isolated) rollback(conn)
            YATATools::SQL( "YATATools::SQL WRITE TABLE ERROR", origin = cond$message, sql = table
                           ,action = "WriteTable", rc = getSQLCode(cond)
                           ,sql="writeTable")
             })
      }
      ,insert        = function(table, values, isolated=FALSE) {
         # inserta en un registro en la tabla
         # values: lista de valores con nombres
         # Los datos a NULL se ignoran
         data = jgg_list_clean(values)
         cols  = paste(names(data), collapse = ",")
         marks = paste(rep("?", length(data)), collapse=",")
         sql = paste("INSERT INTO ", table, "(", cols, ") VALUES (", marks, ")")
         execute(YATATools::SQL, data, isolated)
      }
      ,count = function(table, filter) {
           sql = paste("SELECT COUNT(*) FROM ", table)
           if (!missing(filter) && !(is.null(filter))) {
               clause = paste(names(filter), "= ? AND", collapse=" " )
               sql = paste(YATATools::SQL, sub("AND$", "", clause))
           }
           df = query(YATATools::SQL)
           as.integer(df[1,1])
      }
     ,checkSQLCode  = function(cond) { cond$rc }
     ,SQLDuplicated = function(cond) { cond$rc == 1062 }
     ,SQLLock       = function(cond) { cond$rc == 1205 }

    )
   ,private = list(
       getConn   = function(isolated=FALSE) {
         conn = private$connRead
         if (isolated) {
             private$connIsolated = connect()
             begin(private$connIsolated)
             return (private$connIsolated)
         }
         if (!is.null(connTran)) conn = private$connTran
         conn
      }
      ,getSQLCode = function (cond) {
          # Los codigos van al final del mensaje [nnnnn]
          # https://mariadb.com/kb/en/mariadb-error-codes/
          rc = 99999 # Not found
          res = regexpr("\\[[0-9]+\\]", cond$message)
          if (length(res) > 0 && res > 0) {
              end = attr(res,"match.length")[1]
              rc = as.integer(substr(cond$message,res + 1, res + end - 2))
          }
          rc
      }

   )
)
