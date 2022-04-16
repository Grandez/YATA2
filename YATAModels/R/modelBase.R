# Este se exporta para las extensiones
ModelBase = R6::R6Class("YATA.MODEL"
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       factory = NULL
      ,args = NULL
      ,initialize    = function(...) {
          self$args = list(...)
          # if (!exists("YATAFactory"))
          #      assign("YATAFactory", YATACore::YATAFactory$new(), envir = .GlobalEnv)
          # self$factory = YATAFactory
       }
     )
     ,private = list (
     )
)
# Este no se exporta para evitar tener que teclear self y private
YATAModel = R6::R6Class("YATA.MODEL"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       factory = NULL
      ,args = NULL
      ,initialize    = function(...) {
          self$args = list(...)
          # if (!exists("YATAFactory"))
          #      assign("YATAFactory", YATACore::YATAFactory$new(), envir = .GlobalEnv)
          # self$factory = YATAFactory
       }
     )
     ,private = list (
     )
)
