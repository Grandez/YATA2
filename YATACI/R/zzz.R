# unloadNamespace("YATACore")
# unloadNamespace("YATAProviders")
# unloadNamespace("YATADB")
# unloadNamespace("YATATools")
#
# library(YATACore)

# YATACodes = YATACore:::YATACODES$new()
.onLoad <- function(libname, pkgname){
  message("Loading YATACI")
}
.onAttach <- function(libname, pkgname){
  message("Attaching YATACore")
  DBCI=list(name="CI", dbname="YATACI")
  Factory <<- YATAFACTORY$new(auto=FALSE)
  Factory$setDB(DBCI)

  # Codigos. Short typing
  Codes  <<- YATACODES$new()
  Tables <<- Codes$tables
}

# Clase base para los mensajes
YATACIBase = R6::R6Class("YATA.CI.BASE"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       db     = NULL
      ,mode   = "console"
      ,initialize = function(mode, txtBlock) {
          self$mode = mode
          if (!missing(txtBlock)) outfmt(bold, paste("Testing", txtBlock, "\n"))
       }
      ,finalize   = function() {
          message("Deleting YATACI")
      }
      ,out = function(fmt, ...) { cat(sprintf(fmt, ...)) }
      ,err = function(fmt, ...) {
          sink(stderr())
          cat(red(sprintf(fmt, ...)))
          sink()
      }
      ,outfmt = function(attr, fmt, ...) { cat(attr(sprintf(fmt, ...))) }
      ,errfmt = function(attr, fmt, ...) {
          sink(stderr())
          cat(attr(sprintf(fmt, ...)))
          sink()
      }
      ,logical = function(object, expected, result) {
         txt = paste0("ERROR in ", object, ". Expected: ", expected, "- Found: ", result)
         err(txt)
      }
      ,ok = function() { out(bold("\tOK\n")) }
      ,ko = function() { out(bold $ red("\tKO\n")) }
      ,msgBlock = function(txt) {
          cat(txt)
          # write(txt, stdout())
      }
   )
   ,private = list(

  )
)

# Clase global para control del proceso
YATACI = R6::R6Class("YATA.CI"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,inherit    = YATACIBase
   ,active = list(
      case = function(result) {
         if (missing(result)) return (.cases)
         if (result) {
            ok()
            private$.cases = .cases + 1
         }
         else {
            ko()
            self$errors = errors + 1
            if (.max > 0 && errors == max) stop("Maximum of errors reached")
         }
      }
   )
   ,public = list(
        blocks = 0
       ,errors = 0
       ,initialize = function(mode, max) {
          super$initialize(mode)
          private$.max = max
       }
   )
   ,private = list (
       .cases = 0
      ,.max   = 0
   )
)


