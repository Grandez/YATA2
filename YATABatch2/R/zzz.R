
.onLoad <- function(libname, pkgname){
   message("Loading YATABatch")
#   batch <<- YATABATCH$new()


   # if (!exists("YATACodes")) YATACodes <<- YATACore::YATACODES$new()
   # if (!exists("YATAFactory")) YATAFactory <<- YATACore::YATAFACTORY$new()
}
.onAttach <- function(libname, pkgname){
  message("Attaching YATACore")
#  YATACore::loadFactory()
}
