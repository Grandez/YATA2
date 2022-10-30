# Factoria para acceso a la base de datos

DBFactory = R6::R6Class("YATA.BACKEND.DB.FACTORY"
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = YATADBFactory
   ,public = list(
       print      = function() { message("Database Factory for Base System") }
      ,initialize = function() { super$initialize("base") }
      ,finalize   = function() { super$finalize()         }
      ,destroy    = function() { super$destroy()          }
   )
   ,private = list(
       createObject     = function(tblName, name) {
          # createObject is in same fatory as package
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

