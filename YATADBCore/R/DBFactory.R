# Factoria para acceso a la base de datos

DBFactory = R6::R6Class("YATA.BACKEND.DB.FACTORY"
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = AbstractDBFactory
   ,public = list(
       # dict       = DBDict
       print      = function()     { message("BackEnd Database Factory") }
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

