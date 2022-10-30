# Factoria para acceso a la base de datos

DBFactory <- R6::R6Class("YATA.CLIENT.DB.FACTORY"
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = AbstractDBFactory
   ,public = list(
       # dict       = DBDict
       print      = function()     { message("Database Factory for end users") }
      ,initialize = function() {
          super$initialize()
          sf   = system.file("config", "config.ini", package=utils::packageName())
          cfg  = YATABase::ini(sf)
          info = cfg$getSection("DB")
          self$connect(info)
       }
      ,finalize   = function()     {
         super$finalize()
      }
      ,destroy = function() {
          super$destroy()
      }
      ,getTable   = function(name, force = FALSE) {
         # force obliga a crear el objeto sin cachearlo
         full = paste0("TBL", name)
         if (force) return (private$createObject(full, name))

         if (is.null(private$objects$get(full))) {
            obj = private$createObject(full, name)
            private$objects$put(full, obj)
         }
         private$objects$get(full)
      }
   )
   ,private = list(
      createObject     = function(tblName, name) {
          if (is.null(self$db)) stop("ERROR DBFactory: Called getTable without DB")
          obj = tryCatch({
              eval(parse(text=paste0(tblName, "$new(name, self$db)")))
          }, error = function (cond) {
              stop(paste("ERROR DBFactory: Table", name, "not found"))
          })
          obj
      }

   )
)


# YATADBFactory <- R6::R6Class("YATA.DB.FACTORY"
#    ,portable  = FALSE
#    ,cloneable = FALSE
#    ,lock_class = TRUE
#    ,public = list(
#        dict       = DBDict
#       ,print      = function()     { message("Databases Factory") }
#       ,initialize = function(user="YATA", base) {
#           private$objects = YATABase::map()
#           data = "base"
#           if (!missing(base)) data = base
#           private$lstdb$dbBase  = connectFromList(data)
#           private$lstdb$dbData  = connectFromTable(10, 101)
#           private$lstdb$dbUser  = connectFromTable(10, 102)
#        }
#       ,finalize   = function()     {
#          if (!is.null(lstdb$dbBase)) { lstdb$dbBase$finalize(); private$lstdb$dbBase = NULL }
#          if (!is.null(lstdb$dbData)) { lstdb$dbData$finalize(); private$lstdb$dbData = NULL }
#          if (!is.null(lstdb$dbUser)) { lstdb$dbUser$finalize(); private$lstdb$dbUser = NULL }
#          if (!is.null(lstdb$dbAct))  { lstdb$dbAct$finalize();  private$lstdb$dbAct  = NULL }
#       }
#       ,getDBBase  = function()     { lstdb$dbBase }
#       ,getDBData  = function()     { lstdb$dbData }
#       ,getDBUser  = function()     { lstdb$dbUser }
#       ,getDB      = function()     { lstdb$dbAct  }
#       ,setDB      = function(info) {
#           if (missing(info)) stop("Se ha llamado a setDB sin datos")
#           if (!is.null(lstdb$dbAct)) lstdb$dbAct$disconnect()
#           private$lstdb$dbAct = connect(info)
#           private$objects     = YATABase::map()
#           private$dbID        = info$id
#           invisible(self)
#       }
#       ,getID      = function()     { private$dbID   }
#       ,getTable   = function(name, force = FALSE) {get(name, force) }
#       ,get        = function(name, force = FALSE) {
#          # force obliga a crear el objeto sin cachearlo
#          prfx = ifelse (is.null(DBDict$parts[[name]]), "TBL", "PRT")
#          full = paste0(prfx, name)
#          if (force) return (createObject(prfx, name))
#
#          if (is.null(private$objects$get(full))) {
#             obj = createObject(prfx, name)
#             private$objects$put(full, obj)
#          }
#          private$objects$get(full)
#       }
#    )
#    ,private = list(
#        lstdb   = list()
#       ,dbID    = NULL
#       ,objects = NULL
#       ,connect          = function(info) {
#           if (info$engine == "MariaDB") {
#               MARIADB$new(info)
#           }
#           else {
#              message("Datos de conexion invalidos")
#              stop("Datos de conexion invalidos")
#           }
#       }
#       ,createObject     = function(type, name) {
#           db = NULL
#           for (numDB in 1:4) { # Allow duplicates
#               if (numDB == 1 && !is.null(dict$base  [[name]])) { db = lstdb$dbBase; break; }
#               if (numDB == 2 && !is.null(dict$data  [[name]])) { db = lstdb$dbData; break; }
#               if (numDB == 3 && !is.null(dict$user  [[name]])) { db = lstdb$dbUser; break; }
#               if (numDB == 4 && !is.null(dict$tables[[name]])) { db = lstdb$dbAct;  break; }
#           }
#           if (is.null(db)) {
#               sys.calls()
#               stop(paste("QUE NO ENCUENTRO LA TABLA", name))
#           }
#           eval(parse(text=paste0(type, name, "$new(name, db)")))
#       }
#       ,connectFromList  = function(base) {
#           if (!is.list(base)) {
#                sf   = system.file("extdata", "yatadb.ini", package=packageName())
#                cfg  = YATABase::ini(sf)
#                base = cfg$getSection("base")
#           }
#           connect(base)
#       }
#       ,connectFromTable = function(group,subgroup) {
#           tbl = getTable("Parameters")
#           df = tbl$table(group = group, subgroup = subgroup)
#           data = tidyr::spread(df[,c("name", "value")], name, value)
#           connect(as.list(data))
#       }
#    )
# )
#
