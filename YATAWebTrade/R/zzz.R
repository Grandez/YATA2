.onLoad <- function(libname, pkgname){
  message("Loading jggweb")
}
.onAttach <- function(libname, pkgname){
  message("Attaching jggweb")
  # YATACore::loadFactory()
  # if (!exists("YATACodes")) {
  #     message("Creando YATACodes")
  #     YATACodes   <<- YATACore::YATACODES$new()
  # }
}
