YATAError = R6::R6Class("YATA.ERROR"
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,portable   = FALSE
    ,public     = list(
         text = ""
        ,cond = NULL
        ,ext  = ""
        ,initialize = function(text, cond, ext) {
            self$text = text
            self$cond = cond
            self$ext  = ext
        }
    )
    ,private = list(

    )
)
