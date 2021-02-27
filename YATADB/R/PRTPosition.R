PRTPosition = R6::R6Class("PART.POSITION"
    ,inherit    = TBLPosition
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, db=db)
             private$tblRegularization = TBLRegularization$new("Regularization", db)
         }
        ,select = function(camera, currency, create=FALSE) {
            res = super$select(camera=camera, currency=currency, create=create)
            tblRegularization$select(camera=camera, currency=currency, create=create)
            res
        }
        ,getPrice    = function() {
            from = tblRegularization$getRegularizationDate(camera, currency)
        }
     )
     ,private = list (
         tblRegularization = NULL
     )
)
