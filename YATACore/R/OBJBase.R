# Objeto Base de todos los objetos funcionales
OBJBase = R6::R6Class("OBJ.BASE"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        current = NULL
       ,name    = "OBJ"
       ,id      = NULL
       ,parms    = NULL
       ,codes    = NULL
       ,db       = NULL
       ,print      = function() { message("This is an abstract class")}
       ,initialize = function(Factory) {
           self$parms = Factory$parms
           self$db    = Factory$getDB()
           self$codes = Factory$CODES
        }
    )
)
