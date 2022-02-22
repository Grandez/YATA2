YATAINI = R6::R6Class("YATA.R6.INI"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize    = function() {
          fname = system.file("", "yatacfg")
          private$cfg = ini::read.ini(fname)
       }
    )
   ,private = list(
       cfg = NULL
    )
)
