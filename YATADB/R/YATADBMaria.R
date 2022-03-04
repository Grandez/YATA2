MARIADB = R6::R6Class("YATA.DB.MYSQL"
   ,inherit    = YATA.DB
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
        connRead   = NULL   # Conexion para leer datos
       ,connTran   = NULL   # Conexion para actualizar datos
       ,initialize = function(data) {
           private$dbInfo = data
           self$engine    = dbInfo$engine
           self$name      = dbInfo$name
           self$connRead  = connect()
           self$connTran  = connect()
       }
      ,finalize = function() {
          if (!is.null(connTran)) {
              commit()
              disconnect(connTran)
          }
          if (!is.null(connRead)) {
             disconnect(connRead)
          }
       }
      ,print      = function() {
          db = ifelse(is.null(self$connRead), "No Connection", paste0(dbInfo$name, " (", dbInfo$dbname, ")"))
          message(db, ": MariaDB Database")
      }
      ,isValid = function(conn) { RMariaDB::dbIsValid(conn) }
      ,restoreConnection = function(conn) {
         if (isValid(conn)) return (conn)
         disconnect(conn)
         connect()
      }
      ,connect    = function ()     {
          tryCatch({conn = RMariaDB::dbConnect( drv = RMariaDB::MariaDB()
                                               ,username = dbInfo$user
                                               ,password = dbInfo$password
                                               ,host     = dbInfo$host
                                               ,port     = dbInfo$port
                                               ,dbname   = dbInfo$dbname
                    )
          },error = function(cond) {
              YATABase$cond$SQL("Connection error", origin=cond, action="connect") })
      }
      ,disconnect = function(conn) {
          if (isValid(conn))  {
              tryCatch({ RMariaDB::dbDisconnect(conn) }
                        ,error = function(cond) {
                              message("ERROR en disconnect")
                      })
          }
          invisible(self)
      }
      ,begin      = function() {
          if (!isValid(connTran)) self$connTran = restoreConnection(connTran)
          if (!private$trx) RMariaDB::dbBegin   (connTran)
          private$trx = TRUE
          invisible(connTran)
      }
      ,commit     = function() {
          if (private$trx) RMariaDB::dbCommit   (connTran)
          private$trx = FALSE
          invisible(connTran)
      }
      ,rollback   = function() {
          if (private$trx) RMariaDB::dbRollback   (connTran)
          private$trx = FALSE
          invisible(connTran)
      }
      ,query      = function(qry, params=NULL) {
          if (!is.null(params)) names(params) = NULL
          tryCatch({ RMariaDB::dbGetQuery(getConn(), qry, param=params) }
                    ,error = function (cond) {
                       YATABase$cond$SQL("QUERY Error", origin=cond, action="query", )
                    })
      }
      ,execute    = function(qry, params=NULL, isolated=FALSE) {
          # isolated crea una transaccion para esa query
          # Si son varias acciones se activa con begin - commit

           if (!is.null(params)) names(params) = NULL
           tryCatch({res = RMariaDB::dbExecute(getConn(isolated), qry, params=params)
                     if (isolated) commit()
                    },warning = function(cond) {
                        browser()
                       if (isolated) rollback()
                       YATABase$cond$SQL("EXECUTE", origin=cond, sql=qry, action="execute")
                    },error = function (cond) {
                        browser()
                       if (isolated) rollback()
                       YATABase$cond$SQL("EXECUTE", origin=cond, sql=qry, action="execute")
                    })
      }
      ,write      = function(table, data, append=TRUE, isolated=FALSE) {
         over = ifelse(append, FALSE, TRUE)
         tryCatch({ conn = getConn(isolated)
                    res = RMariaDB::dbWriteTable(conn, table, data, append=append, overwrite=over)
                    if (isolated) commit()
                  },warning = function(cond) {
                     browser()
#                       yataWarning("Warning SQL", cond, "SQL", "WriteTable", cause=tab#le)
                     stop(paste("Aviso en DB Write: ", cond))
                  },error   = function(cond) {
                      if (isolated) rollback()
#                       yataError("Error SQL", cond, "SQL", "Writetable", cause=table)#
                     stop(paste("ERROR en DB Write: ", cond))
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
      # ,connRead  = NULL   # Conexion para leer datos
      # ,connTran  = NULL   # Conexion para actualizar datos
      ,trx       = FALSE
      ,getConn   = function(isolated=FALSE) {
         if (isolated) return (begin())
         if (private$trx) {
             self$connTran = restoreConnection(connTran)
             connTran
         } else {
             self$connRead = restoreConnection(connRead)
             connRead
         }
      }
   )
)
