# Emula un factor o una enumeracion
FSCOPE <- R6::R6Class("FSCOPE",
    public = list(
         value  = 0
        ,size   = 4
        ,NONE   = 0
        ,LONG   = 1
        ,MEDIUM = 2
        ,SHORT  = 4
        ,ALL    = 7
        ,names  = c("Long", "Medium", "", "Short")
        ,initialize = function(scope = 0) { self$value = scope }

        ,getCombo = function() {
            values = c(1,2,4)
            names(values) = self$names
            values
        }
     )
)

