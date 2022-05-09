.onLoad <- function(libname, pkgname){
  message("Loading jggweb")

  # Required when building
#  if (!exists("WEB")) {
       web = YATAWebCore::YATAWebEnv$new(YATACore::YATAFACTORY$new())
       assign("WEB", web, envir=.GlobalEnv)
#  }
}
.onAttach <- function(libname, pkgname){
  message("Attaching jggweb")
#  if (!exists("WEB")) {
       web = YATAWebCore::YATAWebEnv$new(YATACore::YATAFACTORY$new())
       assign("WEB", web, envir=.GlobalEnv)
#  }

  # YATACore::loadFactory()
  # if (!exists("YATACodes")) {
  #     message("Creando YATACodes")
  #     YATACodes   <<- YATACore::YATACODES$new()
  # }
}
