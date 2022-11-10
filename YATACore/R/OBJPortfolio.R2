OBJPortfolio = R6::R6Class("OBJ.PORTFOLIO"
  ,inherit    = OBJBase
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      print       = function() { message("Portfolio Object")}
     ,initialize = function(factory) {
         super$initialize(factory)
         private$parms = factory$parms
     }
     ,getPortfolios = function()   { private$parms$getPortfolios()   }
     ,getportfolio  = function(id) { private$parms$getCameraInfo(id) }
  )
  ,private = list(
      parms = NULL

  )
)
