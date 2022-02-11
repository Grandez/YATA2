library(YATACore)

# YATACodes = YATACore:::YATACODES$new()
.onLoad <- function(libname, pkgname){
  message("Loading YATACore")
}
.onAttach <- function(libname, pkgname){
  message("Attaching YATACore")
  DBCI=list(name="CI", dbname="YATACI")
  Fact <<- YATAFACTORY$new(auto=FALSE)
  Fact$setDB(DBCI)
  # Codigos
  YATACodes <<- YATACODES$new()
  YATATables <<- YATACodes$tables
}
