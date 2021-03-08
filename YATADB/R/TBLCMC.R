# Tabla con los cambios que ofrece cada proveedor
TBLCMC = R6::R6Class("TBL.CMC"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize     = function(name, db=NULL) {
           super$initialize(name, fields=private$fields, key=private$key, db=db)
        }
        ,getID = function(...) {
            syms = args2list(...)
            ids = lapply(syms, function(x) {
                df = table(symbol=x)
                df[1,"id"]
            })
            ids
         }
     )
     ,private = list (
          fields = list(
              id      = "ID"
             ,name    = "NAME"
             ,symbol  = "SYMBOL"
             ,slug    = "SLUG"
             ,cameras = "CAMERAS"
             ,data    = "DATA"

          )
     )
)
