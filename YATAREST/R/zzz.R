library(future)
library(YATACore)

.onLoad <- function(libname, pkgname){
   message("Loading YATREST")
   #plan(multisession)
   # if (!exists("YATACodes")) YATACodes <<- YATACore::YATACODES$new()
   # if (!exists("YATAFactory")) YATAFactory <<- YATACore::YATAFACTORY$new()
}
