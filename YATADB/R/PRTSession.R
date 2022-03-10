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
             if (is.null(tblControl$current)) return (NULL)
             tblControl$current$tms
         }
         ,update = function(data, isolated = FALSE) {
             if (nrow(data) == 0) return (invisible(self))
             tryCatch({
                if (isolated) db$begin()
                tblControl$select(id=1, create = TRUE)
                tblControl$setField("tms", data[1,"last"])
                tblControl$apply()
                super$update(data)
                if (isolated) db$commit()
             }, YATAERROR = function(cond){
                if (isolated) db$rollback()
                 YATABase$cond$propagate(cond)
             })
             invisible(self)
         }
         ,getLatest     = function() {
             last = getLastUpdate()
             if (is.null(last)) return (NULL)
             table(last=last)
         }
     )
     ,private = list (
         tblControl = NULL
     )
)
