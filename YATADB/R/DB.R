# Clase base para acceder a la base de datos
# Define los metodos a implementar como interfaz
YATADB <- R6::R6Class("YATA.BASE.DB"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
     #  engine     = NULL
     # ,name       = NULL
     # ,invalid    = FALSE
      lastErr    = NULL
     ,initialize = function ()     { }
     ,finalize   = function ()     { }
     ,print      = function ()     { stop(notImpl) }
     ,connect    = function ()     { stop(notImpl) }
     ,disconnect = function ()     { stop(notImpl) }
     ,begin      = function()      { stop(notImpl) }
     ,commit     = function()      { stop(notImpl) }
     ,rollback   = function()      { stop(notImpl) }
     ,metadata   = function(table) { stop(notImpl) }
     ,execute    = function(qry, params=NULL, isolated=F) { stop(notImpl) }
     ,query      = function(qry, params=NULL, isolated=F) { stop(notImpl) }
     ,load       = function(table, isolated=F)            { stop(notImpl) }
     ,write      = function(table, data, isolated=T)      { stop(notImpl) }
     # SQLCODES
     ,checkSQLCode  = function(cond) { stop(notImpl) }
     ,SQLDuplicated = function(cond) { stop(notImpl) }
     ,SQLLock       = function(cond) { stop(notImpl) }
     # ,getDefault = function()     { self$getTable(self$active) }
     # ,getTable   = function(name) { pos = which(private$.tableNames == name)[1]
     #                                if (is.na(pos)) return(NA)
     #                                private$.tables[[pos]]
     #                              }
     # ,getTables = function() { private$.tableNames }
     # ,addTables = function(tables) {
     #     for (t in tables) {
     #         if (is.na(self$getTable(t$name))) {
     #            private$.tableNames = c(private$.tableNames, t$name)
     #            private$.tables     = c(private$.tables,     t)
     #            self$active = t$name
     #         }
     #     }
     #     invisible(self)
     # }

#     ,SQLTran    = function()     { message("YATA.DB: This method is not implemented") }
     # ,connects   = function() {
     #    # Utility para test
     #    if (is.null(private$conns) || length(private$conns) == 0) return (0)
     #    length(private$conns)
     # }
   )
   ,private = list(
       notImpl = "YATA.DB: This method is not implemented"
      ,dbInfo       = NULL
      ,connRead     = NULL   # Conexion para leer datos
      ,connTran     = NULL   # Conexion para actualizar datos
      ,connIsolated = NULL   # Conexion para actualizar datos inplace
      #  conns     = NULL   # Lista de conexiones
      # ,addConn = function (conn) {
      #    # Inserta una conexion en la lista de conexiones
      #    if (is.null(private$conns) || length(private$conns) == 0) {
      #       private$conns = list(conn)
      #    }
      #    else {
      #       private$conns = c(private$conns, conn)
      #    }
      #    conn
      # }
      # ,removeConn = function() {
      #    idx = length(conns)
      #    if (idx == 0) return (NULL)
      #    private$conns[idx] = NULL
      #    if (idx > 1) return (private$conns[[idx - 1]])
      #    NULL
      # }

   )
)

