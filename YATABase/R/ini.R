YATABaseIni = R6::R6Class("YATA.BASE.INI"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize    = function(iniFile) {
         if (!missing(iniFile)) private$.cfg = ini::read.ini(iniFile)
      }
      ,load = function(iniFile) {
         private$.cfg = ini::read.ini(iniFile)
      }
      ,getSection = function (section) { .cfg[[section]] }
      ,getValue   = function (section, key) {
         #JGG Pendiente de manejar las listas cuando hay valores duplicados
         .cfg[[section]][[key]]
      }
      ,add = function (fini) {
          if (file.exists(fini)) {
              data = ini::read.ini(fini)
              private$.cfg = list.merge(.cfg, data)
          }
          invisible(self)
      }
    )
   ,private = list(
       .cfg = NULL
    )
)
