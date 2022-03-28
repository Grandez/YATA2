MARIADB = R6::R6Class("YATA.DB.MYSQL"
   ,inherit    = YATA.DB
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
        initialize = function(data) {
           private$base     = YATABase$new()
           private$map      = base$map()
           private$dbInfo   = data
           self$engine      = dbInfo$engine
           self$name        = dbInfo$name
           private$connRead = connect()
       }
      ,finalize = function() {
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
          RMariaDB::dbIsValid(conn)
       }
      ,connect    = function ()     {
          tryCatch({RMariaDB::dbConnect( drv = RMariaDB::MariaDB()
                                        ,username = dbInfo$user
                                        ,password = dbInfo$password
                                        ,host     = dbInfo$host
                                        ,port     = dbInfo$port
                                        ,dbname   = dbInfo$dbname
                    )
          },error = function(cond) {
              YATABase:::SQL( "DB Connection error", origin=cond
                             ,action="connect", sqlcode = getSQLCode(cond))
          })
      }
      ,disconnect = function(conn) {
          if (!is.null(conn) && isValid(conn))  {
              tryCatch({ RMariaDB::dbDisconnect(conn)
          },error = function(cond) {
              YATABase:::SQL( "DB Disconnect", origin=cond
                             ,action="connect", sqlcode = getSQLCode(cond))
          })
          }
          NULL
      }
      ,begin      = function() {
          if (!is.null(connTran)) {
              YATABase:::SQL( "Transacciones activas", origin=NULL
                             , action="begin", sqlcode = getSQLCode(cond))
          }
          private$connTran = connect()
          RMariaDB::dbBegin(connTran)
          invisible(self)
      }
      ,commit     = function() {
          if (is.null(private$connTran)) {
              warning("Commit sin transaccion")
              return (invisible(self))
          }
          RMariaDB::dbCommit(connTran)
          private$connTran = disconnect(connTran)
          invisible(self)
      }
      ,rollback   = function() {
          if (is.null(private$connTran)) {
              warning("Rollback sin transaccion")
              return (invisible(self))
          }
          RMariaDB::dbRollback   (connTran)
          private$connTran = disconnect(connTran)
          invisible(self)
      }
      ,query      = function(qry, params=NULL) {
          if (!is.null(params)) names(params) = NULL
          tryCatch({ RMariaDB::dbGetQuery(getConn(), qry, param=params)
              }, error = function (cond) {
                YATABase:::SQL( "QUERY Error",  origin=cond
                               ,action="query", sqlcode = getSQLCode(cond))
          })
      }
      ,execute    = function(qry, params=NULL, isolated=FALSE) {
          # isolated crea una transaccion para esa query
          # Si son varias acciones se activa con begin - commit

          if (!is.null(params)) names(params) = NULL
          tryCatch({
              conn = getConn(isolated)
              res = RMariaDB::dbExecute(conn, qry, params=params)
              if (isolated) commit()
          },warning = function(cond) {
               if (isolated) rollback()
               YATABase:::SQL("EXECUTE", origin=cond, sql=qry, action="execute")
          },error = function (cond) {
               sqlcode = getSQLCode(cond)
               if (sqlcode == SQL_LOCK) isolated = TRUE
               if (isolated) rollback()
               YATABase:::SQL( "SQL EXECUTE ERROR",origin=cond,sql=qry
                              ,action="execute", sqlcode=sqlcode)
          })
      }
      ,write      = function(table, data, append=TRUE, isolated=FALSE) {
         over = ifelse(append, FALSE, TRUE)
         tryCatch({
             conn = getConn(isolated)
             res = RMariaDB::dbWriteTable(conn, table, data, append=append, overwrite=over)
             if (isolated) commit()
         }, warning = function(cond) {
#                       yataWarning("Warning SQL", cond, "SQL", "WriteTable", cause=tab#le)
                     stop(paste("Aviso en DB Write: ", cond))
         }, error   = function(cond) {
            if (isolated) rollback()
            YATABase:::SQL( "SQL WRITE TABLE ERROR", origin = cond, sql = qry
                           ,action = "WriteTable", sqlcode = getSQLCode(cond))
             })
      }
      ,add        = function(table, values, isolated=FALSE) {
         # inserta en un registro en la tabla
         # values: lista de valores con nombres
         # Los datos a NULL se ignoran
         data = list.clean(values)
         cols  = paste(names(data), collapse = ",")
         marks = paste(rep("?", length(data)), collapse=",")
         sql = paste("INSERT INTO ", table, "(", cols, ") VALUES (", marks, ")")
         execute(sql, data, isolated)
      }
      ,count = function(table, filter) {
           sql = paste("SELECT COUNT(*) FROM ", table)
           if (!missing(filter) && !(is.null(filter))) {
               clause = paste(names(filter), "= ? AND", collapse=" " )
               sql = paste(sql, sub("AND$", "", clause))
           }
           df = query(sql)
           as.integer(df[1,1])
        }
    )
   ,private = list(
       dbInfo    = NULL
      ,connRead  = NULL   # Conexion para leer datos
      ,connTran  = NULL   # Conexion para actualizar datos
      ,map       = NULL
      ,base      = NULL
      ,SQL_LOCK  = 1205
      ,getConn   = function(isolated=FALSE) {
         if (isolated) return (begin())
         private$connRead
      }
      ,getSQLCode = function (cond) {
          # Los codigos van al final del mensaje [nnnnn]
          # https://mariadb.com/kb/en/mariadb-error-codes/
          browser()
          rc = 0
          res = regexpr("\\[[0-9]+\\]", cond$message, value = TRUE)
          if (length(res) > 0) {
              end = attr(res,"match.length")[1]
              rc = substr(cond$message,res + 1, res + end - 1)
          }
          rc
      }

   )
)
