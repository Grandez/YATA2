# Tabla con los cambios que ofrece cada proveedor
TBLExchangesPair = R6::R6Class("TBL.EXCHANGES.PAIR"
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
           idExch    = "ID_EXCH"
          ,exchange  = "EXCHANGE"
          ,idBase    = "ID_BASE"
          ,base      = "BASE"
          ,idCounter = "ID_COUNTER"
          ,counter   = "COUNTER"
        )
         ,key    = c("idExch", "idBase", "idCounter")
     )
)

