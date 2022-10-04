TBLFIATExch = R6::R6Class("TBL.FIAT.EXCHANGE"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize    = function(name,  db=NULL) {
           super$initialize(name, fields=private$fields, db=db)
        }
     )
     ,private = list (
         fields = list(
             idfrom    = "IDFROM"
            ,idto      = "IDTO"
            ,exchange  = "EXCHANGE"
            ,date      = "DATE"
          )
     )
)
