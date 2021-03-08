# Objeto Base de todos los objetos funcionales
OBJBase = R6::R6Class("OBJ.BASE"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        current = NULL
       ,name    = NULL
       ,id      = NULL
       ,print      = function() { message("Clearings Object")}
       ,initialize = function(factory) {
           if (missing(factory) && !exists("YATAFactory")) {
               stop("Falta la factoria")
           }
           if (!missing(factory)) {
               private$factory = factory
           }
           else {
               private$factory = YATAFactory
           }
           private$parms = factory$parms
           private$codes = factory$codes
           private$db    = factory$getDB()
        }
    )
    ,private = list(
        selected = FALSE
       ,parms    = NULL
       ,db       = NULL
       ,factory = NULL
       ,codes   = NULL
    )
)
