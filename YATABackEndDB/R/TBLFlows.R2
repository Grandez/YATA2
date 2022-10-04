TBLFlows = R6::R6Class("TBL.FLOWS"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
           super$initialize(name, fields=private$fields, key=private$key, db=db)
        }
     )
     ,private = list (
           key = c("idOper", "idFlow")
          ,fields = list(
              idOper   = "ID_OPER"
             ,idFlow   = "ID_FLOW"
             ,type     = "TYPE"
             ,currency = "CURRENCY"
             ,amount   = "AMOUNT"
             ,price    = "PRICE"
             ,tms      = "TMS"
          )

     )
)
