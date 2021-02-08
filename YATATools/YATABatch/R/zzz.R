.onLoad <- function(libname, pkgname){
  message("Loading YATABatch")
# YATACodes   <<- YATACore::YATACODES$new()
# YATAFactory <<- YATACore::YATAFACTORY$new() # Va primero
# YATAEnv <<- YATACore::YATAENV$new()
# YATAFactory$env = YATAEnv

  # if ("YATAProviders" %in% .packages()) detach("package:YATAProviders", unload=TRUE)
  # if ("YATADB" %in% .packages()) detach("package:YATADB", unload=TRUE)
  # if ("YATACore" %in% .packages()) detach("package:YATACore", unload=TRUE)
  # #
  #  library(YATAProviders)
  #  library(YATADB)
  #  library(YATACore)

  # YATAFactory <<- YATAFACTORY$new()
  # YATAEnv <<- YATACore::YATAENV$new()
#  if (exists("YATAFactory")) YATAFactory = NULL

    #YATAEnv     <<- YATACore:::YATAENV$new()
}
