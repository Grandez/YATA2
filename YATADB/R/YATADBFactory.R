# Factoria para diferentes provedores de base de datos

YATADBFactory <- R6::R6Class("YATA.DB.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       initialize = function(base) {
          if (!missing(base)) {
              private$dbBase  = connect(base)
          } else {
               sf             = system.file("extdata", "yatadb.ini", package=packageName())
               cfg    = read.config(file=sf)
               private$dbBase = connect(cfg$base)
          }
       }
      ,print      = function()     { message("Databases Factory") }
      ,finalize   = function()     {
         if (!is.null(dbBase)) { dbBase$finalize(); private$dbBase = NULL }
         if (!is.null(dbAct))  { dbAct$finalize();  private$dbAct  = NULL }
      }
      ,getDBBase = function()     { private$dbBase }
      ,getDB     = function()     { private$dbAct  }
      ,setDB     = function(info) {
          if (missing(info)) stop("Se ha llamado a setDB sin datos")
          if (!is.null(dbAct)) dbAct$disconnect()
          private$dbAct = connect(info)
          private$tables    = HashMap$new()
          private$dbAct
      }
      ,getTable = function(name, force=FALSE) {
         if (force) return (createTable(name))
         if (is.null(private$tables$get(name))) private$tables$put(name, createTable(name))
         private$tables$get(name)
      }
   )
   ,private = list(
       dbBase  = NULL
      ,dbAct   = NULL
      ,tables  = HashMap$new()
      ,connect = function(info) {
          if (info$engine == "MariaDB") {
              MARIADB$new(info)
          }
          else {
             message("Datos de conexion invalidos")
             stop("Datos de conexion invalidos")
          }
      }
      ,createTable = function(name) {
         db = dbAct
         if (!is.null(DBDict$baseTables[[name]])) db = dbBase
         eval(parse(text=paste0("TBL", name, "$new(name, db)")))
      }
   )
)

