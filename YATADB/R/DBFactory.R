YATADBFactory = R6::R6Class("YATA.DB.FACTORY"
   ,portable  = TRUE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       print      = function()     { message("Databases Factory") }
      ,initialize = function(bbdd) {
          private$objects = YATATools::map()
          private$hDB     = YATATools::map()
          if (missing(bbdd)) return()
          self$connect(bbdd)
       }
      ,finalize   = function()     {
          self$destroy()
      }
      ,destroy    = function()     {
          if (!is.null(private$db)) private$db$destroy()
      }
      ,connect    = function(info) {
          info = private$checkConnectInfo(info)
          if (!is.null(private$db)) {
              if (private$db$getName() == info$dbName) return ()
              db$disconnect()
          }
          if (info$engine == "MariaDB") private$db = MARIADB$new(info)
          invisible(self)
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
      ,getDB      = function()     { private$db }
   )
   ,private = list(
       objects = NULL
      ,hDB     = NULL
      ,dbID    = NULL
      ,db      = NULL
      ,checkConnectInfo = function (info) {
          if (missing(info))            stop("ERROR: Invalid call to connect. Missing connection info")
          if (length(info) == 1) { # Is a key
              sf   = system.file("config", "config.ini", package=utils::packageName())
              cfg  = YATATools::ini(sf)
              info = cfg$getSection(tolower(info))
          }
          if (is.null(info))            stop("ERROR: Invalid key info for Database")
          if (is.null(info$engine))     stop("ERROR: Invalid call to connect. Missing SGDB engine")
          if (info$engine != "MariaDB") stop(paste("ERROR: SGDB engine not supported:", info$engine))
          info
      }
      ,createObject     = function(tblName, name) {
          if (is.null(private$db)) stop("ERROR DBFactory: Called getTable without DB")
          obj = tryCatch({
              eval(parse(text=paste0(tblName, "$new(name, db)")))
          }, error = function (cond) {
              stop(paste("ERROR DBFactory: Table", name, "not found"))
          })
          obj
      }
      # ,initialize = function() {
      #     super$initialize()
      #     sf   = system.file("config", "config.ini", package=utils::packageName())
      #     cfg  = YATABase::ini(sf)
      #     info = cfg$getSection("DB")
      #     self$connect(info)
      #  }
      # ,connect          = function(info) {
      #     nfo = info
      #     if (!is.list(info)) {
      #         sf  = system.file("config", "config.ini", package=utils::packageName())
      #         cfg = YATABase::ini(sf)
      #         nfo = cfg$getSection(tolower(info))
      #
      #     }
      #
      #     if (nfo$engine == "MariaDB") {
      #         hndl = MARIADB$new(nfo)
      #         private$hDB$put(tolower(nfo$name), hndl)
      #     }
      #     else {
      #        message("Datos de conexion invalidos")
      #        stop("NO hay soporte para el motor de base de datos")
      #     }
      #     hndl
      # }
      # ,createObject     = function(type, name) {
      #     db = NULL
      #     for (numDB in 1:4) { # Allow duplicates
      #         if (numDB == 1 && !is.null(dict$base  [[name]])) { db = lstdb$dbBase; break; }
      #         if (numDB == 2 && !is.null(dict$data  [[name]])) { db = lstdb$dbData; break; }
      #         if (numDB == 3 && !is.null(dict$user  [[name]])) { db = lstdb$dbUser; break; }
      #         if (numDB == 4 && !is.null(dict$tables[[name]])) { db = lstdb$dbAct;  break; }
      #     }
      #     if (is.null(db)) {
      #         sys.calls()
      #         stop(paste("QUE NO ENCUENTRO LA TABLA", name))
      #     }
      #     eval(parse(text=paste0(type, name, "$new(name, db)")))
      # }
      # ,connectFromList  = function(base) {
      #     if (!is.list(base)) {
      #          sf   = system.file("extdata", "yatadb.ini", package=packageName())
      #          cfg  = YATATools::ini(sf)
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
   )
)

