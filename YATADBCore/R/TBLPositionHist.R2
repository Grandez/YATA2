TBLPositionHist = R6::R6Class("TBL.POSITION.HIST"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, fields=private$fields,key=key, db=db)
         }
     )
     ,private = list (
           key    = c("datePos", "camera", "currency")
          ,fields = list(
              datePos   = "DATE_POS"
             ,camera    = "CAMERA"
             ,currency  = "CURRENCY"
             ,balance   = "BALANCE"
             ,available = "AVAILABLE"
             ,price     = "PRICE"
             ,tms       = "TMS"
          )
     )
)
