YATAINI = R6::R6Class("YATA.R6.INI"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize    = function() {
          fname = system.file("", "yata.cfg", package="YATASetup")
          private$cfg = ini::read.ini(fname)
      }
      ,getSectionValues = function(section) {
          cfg[[section]]
      }
    )
   ,private = list(
       cfg = NULL
    )
)
