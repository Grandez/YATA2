# Factoria para acceso a la base de datos

DBFactory = R6::R6Class("YATA.DB.USER.FACTORY"
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = YATADBFactory
   ,public = list(
       print      = function() { message("Database Factory for User data") }
      ,initialize = function(name="user") {
          super$initialize(name) }
      ,finalize   = function() { super$finalize()         }
      ,destroy    = function() { super$destroy()          }
    )
   ,private = list(
       createObject = function(tblName, name) {
          # createObject is in same factory as package
          if (is.null(private$db)) stop("ERROR DBFactory: Called getTable without DB")
          obj = tryCatch({
              eval(parse(text=paste0(tblName, "$new(name, private$db)")))
          }, error = function (cond) {
              stop(paste("ERROR DBFactory: Table", name, "not found"))
          })
          obj
      }
   )
)

