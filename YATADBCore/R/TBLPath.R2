TBLPath = R6::R6Class("TBL.PATH"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
             super$initialize(name, fields=private$fields, key=private$key,db=db)
          }
     )
     ,private = list (key = c("provider", "base", "counter")
           ,fields = list(
               provider = "PROVIDER"
              ,base     = "BASE"
              ,counter  = "COUNTER"
              ,path     = "PATH"
              ,active   = "ACTIVE"
          )
     )
)
