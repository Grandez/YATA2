YATAINI = R6::R6Class("YATA.R6.INI"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize    = function() {
          fname = system.file("", "yata.cfg", package="YATASetup")
          private$.cfg = YATABase$ini(fname)
      }
      ,getSite     = function() { .cfg$getValue("base", "site")       }
      ,getUserPass = function() { .cfg$getValue("variables", "passw") }
      ,add = function (fini) {
          if (file.exists(fini)) .cfg$add(fini)
          invisible(self)
      }
      ,getPattern = function(pattern) {
          tok = substr(pattern,3, nchar(pattern) - 2)
          .cfg$getValue("variables", tok)
      }
      ,getSection = function(section) { .cfgetSection(section) }
    )
   ,private = list(
       .cfg = NULL
    )
)
