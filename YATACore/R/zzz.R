# YATAFactory <<- YATAFACTORY$new() # Va primero
# YATAEnv = YATAENV$new()
#YATAFactory$env = YATAEnv

library(YATADB)
library(YATAProviders)

# YATACodes = YATACore:::YATACODES$new()
.onLoad <- function(libname, pkgname){
  message("Loading YATACore")
#  YATAFactory <<- YATAFACTORY$new()
# getFactory = function(force = FALSE) {
#    if (length(ls(".GlobalEnv", pattern="Factory")) == 0 || is.null(Factory)) {
#        force = TRUE
#    }
#    if (force || !Factory$valid()) {
#        fact = YATACore::YATAFactory$new()
#        assign("Factory",   fact,       envir=.GlobalEnv)
#        assign("YATACodes", fact$CODES, envir=.GlobalEnv)
#    }
#    Factory
# }

}
.onAttach <- function(libname, pkgname){
  message("Attaching YATACore")
  # YATACore::loadFactory()
  # if (!exists("YATACodes")) {
  #     message("Creando YATACodes")
  #     YATACodes   <<- YATACore::YATACODES$new()
  # }
}
