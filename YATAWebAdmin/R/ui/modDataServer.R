modDataServer = function(id, full) {
   ns = NS(id)
   PNLData = R6::R6Class("PNL.DATA"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            initialize     = function(id) {
               super$initialize(id)
           }
        )
       ,private = list(
       )
    )
   
   moduleServer(id, function(input, output, session) {
  })
}

