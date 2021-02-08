TBLProviders = R6::R6Class("TBL.PROVIDERS"
    ,inherit    = YATATableSimple
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
            super$initialize(name, fields=private$fields, db=db)
        }
     )
     ,private = list (
         fields = list(
            id     = "PROVIDER"
           ,name   = "NAME"
           ,active = "ACTIVE"
           ,order  = "ORDER"
           ,token  = "TOKEN"
           ,user   = "USER"
           ,pwd    = "PWD"
           ,icon   = "ICON"
           ,object = "OBJECT"
         )
     )
)
