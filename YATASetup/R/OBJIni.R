YATAINI = R6::R6Class("YATA.R6.INI"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize    = function() {
          fname = system.file("", "yata.cfg", package="YATASetup")
          private$.cfg = ini::read.ini(fname)
      }
      ,getSite     = function() { .cfg$base$site       }
      ,getUserPass = function() { .cfg$variables$passw }
      ,add = function (fini) {
          if (file.exists(fini)) {
              data = ini::read.ini(fini)
              private$.cfg = list.merge(.cfg, data)
          }
          invisible(self)
      }
      ,getPattern = function(pattern) {
          tok = substr(pattern,3, nchar(pattern) - 2)
          .cfg$variables[[tok]]
      }
      ,getSectionValues = function(section) {
          .cfg[[section]]
      }
    )
   ,private = list(
       .cfg = NULL
    )
)
