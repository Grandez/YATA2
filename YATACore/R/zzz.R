# YATAFactory <<- YATAFACTORY$new() # Va primero
# YATAEnv = YATAENV$new()
#YATAFactory$env = YATAEnv

library(YATATools)
library(YATADB)
library(YATAProviders)

YATACodes = YATACore:::YATACODES$new()
.onAttach <- function(libname, pkgname){
  message("Loading YATACore")
  if (!exists("YATACodes")) {
      message("Creando YATACodes")
      YATACodes   <<- YATACore::YATACODES$new()
  }
  # if (!exists(YATAFactory)) YATAFactory <<- YATACore::YATAFACTORY$new()
}
