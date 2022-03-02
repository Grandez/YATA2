# YATAFactory <<- YATAFACTORY$new() # Va primero
# YATAEnv = YATAENV$new()
#YATAFactory$env = YATAEnv

library(YATADB)
library(YATAProviders)

# YATACodes = YATACore:::YATACODES$new()
.onLoad <- function(libname, pkgname){
  message("Loading YATACore")
}
.onAttach <- function(libname, pkgname){
  message("Attaching YATACore")
  if (!exists("YATACodes")) {
      message("Creando YATACodes")
      YATACodes   <<- YATACore::YATACODES$new()
  }
  # if (!exists(YATAFactory)) YATAFactory <<- YATACore::YATAFACTORY$new()
}
