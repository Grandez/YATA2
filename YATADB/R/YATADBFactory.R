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
      ,getDBBase  = function()     { private$dbBase }
      ,getDB      = function()     { private$dbAct  }
      ,setDB      = function(info) {
          if (missing(info)) stop("Se ha llamado a setDB sin datos")
          if (!is.null(dbAct)) dbAct$disconnect()
          private$dbAct   = connect(info)
          private$objects = HashMap$new()
          private$dbAct
          private$dbID = info$id
          invisible(self)
      }
      ,getID      = function()     { private$dbID   }
      ,getTable   = function(name, force = FALSE) { get(name, force) }
      ,get       = function(name, force = FALSE) {
         prfx = ifelse (is.null(DBDict$parts[[name]]), "TBL", "PRT")
         full = paste0(prfx, name)
         if (force) return (createObject(prfx, name))

         if (is.null(private$objects$get(full))) {
            obj = createObject(prfx, name)
            private$objects$put(full, obj)
         }
         private$objects$get(full)
      }
   )
   ,private = list(
       dbBase  = NULL
      ,dbAct   = NULL
      ,dbID    = NULL
      ,objects = HashMap$new()
      ,connect = function(info) {
          if (info$engine == "MariaDB") {
              MARIADB$new(info)
          }
          else {
             message("Datos de conexion invalidos")
             stop("Datos de conexion invalidos")
          }
      }
      ,createObject = function(type, name) {
         db = dbAct
         if (!is.null(DBDict$baseTables[[name]])) db = dbBase
         eval(parse(text=paste0(type, name, "$new(name, db)")))
      }
   )
)

