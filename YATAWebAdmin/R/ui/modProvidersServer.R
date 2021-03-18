modpProvidersServer = function(id, full) {
   ns = NS(id)
   PNLProviders = R6::R6Class("PNL.PROVIDERS"
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

