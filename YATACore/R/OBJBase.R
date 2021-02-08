# Objeto Base de todos los objetos funcionales
OBJBase = R6::R6Class("OBJ.BASE"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        current = NULL
       ,print      = function() { message("Clearings Object")}
       ,initialize = function() {
           private$parms = YATAFactory$getParms()
           private$db    = YATAFactory$getDB()
        }
    )
    ,private = list(
        selected = FALSE
       ,parms    = NULL
       ,db       = NULL
    )
)
