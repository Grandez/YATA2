
.onLoad <- function(libname, pkgname){
   message("Loading YATABatch")
   batch <<- YATABATCH$new()


   # if (!exists("YATACodes")) YATACodes <<- YATACore::YATACODES$new()
   # if (!exists("YATAFactory")) YATAFactory <<- YATACore::YATAFACTORY$new()
}
