TBLFavorites = R6::R6Class("TBL.FAVORITES"
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
          id     = "ID"
         ,symbol = "SYMBOL"
         ,prty   = "PRTY"
       )
   )
)
