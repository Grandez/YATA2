# Tabla con los cambios que ofrece cada proveedor
TBLExchangesCtc = R6::R6Class("TBL.EXCHANGES.CTC"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize     = function(name, db=NULL) {
           super$initialize(name, fields=private$fields, key=key, db=db)
        }
     )
     ,private = list (
          fields = list(
               idExch = "ID_EXCH"
              ,idCtc  = "ID_CTC"
          )
         ,key    = c("idExch", "idCtc")
     )
)

