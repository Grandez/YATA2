PRTfIAT = R6::R6Class("PART.FIAT"
    ,inherit    = TBLFIAT
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, db=db)
             private$tblExchange = TBLFIATExch$new("FIATExch", db)
         }
     )
     ,private = list (
         tblExchange = NULL
     )
)
