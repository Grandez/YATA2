# Factoria para diferentes provedores de base de datos

YATADBFactory <- R6::R6Class("YATA.DB.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       print      = function()     { message("Databases Factory") }
      ,initialize = function(base, data) {
          private$yatabase = YATABase$new()
          if (missing(base)) {
               sf   = system.file("extdata", "yatadb.ini", package=packageName())
               cfg  = yatabase$ini(sf)
               base = cfg$getSection("base")
               data = cfg$getSection("data")
          }
          private$objects = yatabase$map()
          private$dbBase  = connect(base)
          private$dbData  = connect(data)
       }
      ,finalize   = function()     {
         if (!is.null(dbBase)) { dbBase$finalize(); private$dbBase = NULL }
         if (!is.null(dbData)) { dbData$finalize(); private$dbData = NULL }
         if (!is.null(dbAct))  { dbAct$finalize();  private$dbAct  = NULL }
      }
      ,getDBBase  = function()     { private$dbBase }
      ,getDBData  = function()     { private$dbData }
      ,getDB      = function()     { private$dbAct  }
      ,setDB      = function(info) {
          if (missing(info)) stop("Se ha llamado a setDB sin datos")
          if (!is.null(dbAct)) dbAct$disconnect()
          private$dbAct   = connect(info)
          private$objects = yatabase$map()
          private$dbID = info$id
          invisible(self)
      }
      ,getID      = function()     { private$dbID   }
      ,getTable   = function(name, force = FALSE) {
          message("YATADB con ", name)
          get(name, force) }
      ,get        = function(name, force = FALSE) {
         # force obliga a crear el objeto sin cachearlo
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
       dbBase   = NULL
      ,dbData   = NULL
      ,dbAct    = NULL
      ,dbID     = NULL
      ,yatabase = NULL
      ,objects  = NULL
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
          db = NULL
          for (numDB in 1:3) {
              if (numDB == 1 && !is.null(DBDict$base  [[name]])) { db = dbBase; break; }
              if (numDB == 2 && !is.null(DBDict$data  [[name]])) { db = dbData; break; }
              if (numDB == 3 && !is.null(DBDict$tables[[name]])) { db = dbAct;  break; }
          }
          if (is.null(db)) {
              sys.calls()
              stop(paste("QUE NO ENCUENTRO LA TABLA", name))
          }
          eval(parse(text=paste0(type, name, "$new(name, db)")))
      }
   )
)

