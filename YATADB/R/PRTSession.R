PRTSession = R6::R6Class("PART.SESION"
    ,inherit    = TBLSession
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, db=db)
             private$tblControl = TBLSessionCtrl$new("SessionCtrl", db)
         }
         ,getLastUpdate = function() {
             tblControl$select(id=1)
             if (is.null(tblControl$current)) return (0)
             tblControl$current$tms
         }
         ,update = function(data, isolated = FALSE) {
             if (nrow(data) == 0) return (invisible(self))
             tblControl$select(id=1, create = TRUE)
             tblControl$setField("tms", as.integer(as.POSIXct(data[1,"last"])))
             tblControl$apply()
             super$update(data)
             invisible(self)
         }
         ,getLatest     = function() {
             last = getLastUpdate()
             if (is.null(last)) return (data.frame())
             table(last=last)
         }
     )
     ,private = list (
         tblControl = NULL
     )
)
