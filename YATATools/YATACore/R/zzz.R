# YATAFactory <<- YATAFACTORY$new() # Va primero
# YATAEnv = YATAENV$new()
#YATAFactory$env = YATAEnv



.onLoad <- function(libname, pkgname){
  message("Loading YATACore")
  # YATAFactory <<- YATAFACTORY$new()
  # YATAEnv     <<- YATAENV$new()

  # if (!("RMariaDB" %in% .packages())) {
  #     library("RMariaDB", character.only = T)
  # }
  # if ("YATADB" %in% .packages()) detach("package:YATADB", unload=TRUE)
  #
  # library("YATADB", character.only = T)

#  if (exists("YATAFactory")) YATAFactory = NULL
}
