TBLOperControl   = R6::R6Class("TBL.OPER.CONTROL"
   ,inherit    = YATATable
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       initialize = function(name, db=NULL) {
          super$initialize(name,fields=private$fields,db=db)
       }
   )
   ,private = list (
       key = c("id")
      ,fields = list(
          id       = "ID_OPER"
         ,fee      = "FEE"
         ,gas      = "GAS"
         ,limit    = "LIMITE"
         ,stop     = "STOP"
         ,target   = "TARGET"
         ,deadline = "DEADLINE"
         ,amountIn = "AMOUNT_IN"
         ,priceIn  = "PRICE_IN"
         ,alert    = "ALERT"
         ,dtAlert  = "TMS_ALERT"
       )
  )
)
