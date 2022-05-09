# Clase base para acceder a la base de datos
# Clase base de los ficheros
# dbGetQuery(con, "SELECT * FROM mtcars", n = 6)
#
#  Ejemplo
#
# # Pass values using the param argument:
# # (This query runs eight times, once for each different
# # parameter. The resulting rows are combined into a single
# # data frame.)
# dbGetQuery(
#   con,
#   "SELECT COUNT(*) FROM mtcars WHERE cyl = ?",
#   params = list(1:8)
#)

YATA.DB <- R6::R6Class("YATA.DB"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
      engine     = NULL
     ,name       = NULL
     ,invalid    = FALSE
     ,lastErr    = NULL
     ,finalize   = function() {
          conn = disconnect()
          while (!is.null(conn)) conn = disconnect()
     }
     ,print      = function()      { message(self$name) }
     ,getDefault = function()     { self$getTable(self$active) }
     ,getTable   = function(name) { pos = which(private$.tableNames == name)[1]
                                    if (is.na(pos)) return(NA)
                                    private$.tables[[pos]]
                                  }
     ,getTables = function() { private$.tableNames }
     ,addTables = function(tables) {
         for (t in tables) {
             if (is.na(self$getTable(t$name))) {
                private$.tableNames = c(private$.tableNames, t$name)
                private$.tables     = c(private$.tables,     t)
                self$active = t$name
             }
         }
         invisible(self)
     }
     ,connect    = function ()     { message("This method is virtual") }
     ,disconnect = function ()     { message("This method is virtual") }
     ,metadata   = function(table) { message("This method is virtual") }

#     ,SQLTran    = function()     { message("This method is virtual") }
     ,begin      = function()     { stop("This method is virtual")    }
     ,commit     = function()     { stop("This method is virtual")    }
     ,rollback   = function()     { stop("This method is virtual")    }
     ,execute    = function(qry, params=NULL, isolated=F) { message("This method is virtual") }
     ,query      = function(qry, params=NULL, isolated=F) { message("This method is virtual") }
     ,load       = function(table, isolated=F)            { message("This method is virtual") }
     ,write      = function(table, data, isolated=T)      { message("This method is virtual") }
     ,connects   = function() {
        # Utility para test
        if (is.null(private$conns) || length(private$conns) == 0) return (0)
        length(private$conns)
     }
   )
   ,private = list(
       conns     = NULL   # Lista de conexiones
      ,addConn = function (conn) {
         # Inserta una conexion en la lista de conexiones
         if (is.null(private$conns) || length(private$conns) == 0) {
            private$conns = list(conn)
         }
         else {
            private$conns = c(private$conns, conn)
         }
         conn
      }
      ,removeConn = function() {
         idx = length(conns)
         if (idx == 0) return (NULL)
         private$conns[idx] = NULL
         if (idx > 1) return (private$conns[[idx - 1]])
         NULL
      }

   )
)

