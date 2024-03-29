TBLFlows = R6::R6Class("YATA.TBL.FLOWS"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
           super$initialize(name, private$tblName, fields=private$fields, key=private$key, db=db)
        }
     )
     ,private = list (
           tblName = "FLOWS"
          ,key = c("idOper", "idFlow")
          ,fields = list(
              idOper   = "ID_OPER"
             ,idFlow   = "ID_FLOW"
             ,type     = "TYPE"
             ,camera   = "CAMERA"
             ,currency = "CURRENCY"
             ,amount   = "AMOUNT"
             ,price    = "PRICE"
             ,dateOper = "DATEOPER"
             ,dateVal  = "DATEVAL"
             ,tms      = "TMS"
          )

     )
)
