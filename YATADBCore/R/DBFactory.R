# Factoria para acceso a la base de datos

DBFactory <- R6::R6Class("YATA.BACKEND.DB.FACTORY"
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = AbstractDBFactory
   ,public = list(
       # dict       = DBDict
       print      = function()     { message("BackEnd Database Factory") }
      ,initialize = function() {
          #reg.finalizer(self, function(this) destroy(this), onexit = TRUE)
          #private$objects = YATABase::map()
          super$initialize()
          sf   = system.file("config", "config.ini", package=utils::packageName())
          cfg  = YATABase::ini(sf)
          info = cfg$getSection("DB")
          self$connect(info)

         #  data = "base"
         #  if (!missing(base)) data = base
         #  private$lstdb$dbBase  = connectFromList(data)
         #  private$lstdb$dbData  = connectFromTable(10, 101)
         #  private$lstdb$dbUser  = connectFromTable(10, 102)
         # super$initialize()


       }
      ,finalize   = function()     {
          message("DBFactory Finalize")
         super$finalize()
         # if (!is.null(lstdb$dbBase)) { lstdb$dbBase$finalize(); private$lstdb$dbBase = NULL }
         # if (!is.null(lstdb$dbData)) { lstdb$dbData$finalize(); private$lstdb$dbData = NULL }
         # if (!is.null(lstdb$dbUser)) { lstdb$dbUser$finalize(); private$lstdb$dbUser = NULL }
         # if (!is.null(lstdb$dbAct))  { lstdb$dbAct$finalize();  private$lstdb$dbAct  = NULL }
      }
      ,destroy = function() {
          super$destroy()
      }
      # ,getDBBase  = function()     { lstdb$dbBase }
      # ,getDBData  = function()     { lstdb$dbData }
      # ,getDBUser  = function()     { lstdb$dbUser }
      # ,getDB      = function()     { lstdb$dbAct  }
      # ,setDB      = function(info) {
      #     if (missing(info)) stop("Se ha llamado a setDB sin datos")
      #     if (!is.null(lstdb$dbAct)) lstdb$dbAct$disconnect()
      #     private$lstdb$dbAct = connect(info)
      #     private$objects     = YATABase::map()
      #     private$dbID        = info$id
      #     invisible(self)
      # }
      # ,getID      = function()     { private$dbID   }
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
      #  lstdb   = list()
      # ,dbID    = NULL
      # ,objects = NULL
      # ,connect          = function(info) {
      #     if (info$engine == "MariaDB") {
      #         MARIADB$new(info)
      #     }
      #     else {
      #        message("Datos de conexion invalidos")
      #        stop("Datos de conexion invalidos")
      #     }
      # }
      # ,connectFromList  = function(base) {
      #     if (!is.list(base)) {
      #          sf   = system.file("extdata", "yatadb.ini", package=packageName())
      #          cfg  = YATABase::ini(sf)
      #          base = cfg$getSection("base")
      #     }
      #     connect(base)
      # }
      # ,connectFromTable = function(group,subgroup) {
      #     tbl = getTable("Parameters")
      #     df = tbl$table(group = group, subgroup = subgroup)
      #     data = tidyr::spread(df[,c("name", "value")], name, value)
      #     connect(as.list(data))
      # }
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

