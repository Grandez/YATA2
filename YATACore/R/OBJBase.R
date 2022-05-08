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
       ,factory  = NULL
       ,print      = function() { message("This is an abstract class")}
       ,initialize = function(factory) {
           self$factory = factory
           self$parms   = factory$parms
           self$db      = factory$getDB()
           self$codes   = factory$codes
       }
       ,getColumnNames = function(yataNames) {
           if(is.null(tblBase)) return("")
           tblBase$translateColNames(yataNames)
        }
       ,getDBTableName = function()          {
           if(is.null(tblBase)) return("")
           tblBase$getDBTableName()
        }
       ,getDBName      = function()          {
           if(is.null(tblBase)) return("")
           tblBase$getDB()$getName()
       }
       ,empty_data = function() { stop(paste("This method is not implemented for ", name)) }
    )
    , private = list(
         tblBase  = NULL
    )
)
