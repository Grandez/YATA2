.onLoad <- function(libname, pkgname){
    #JGG Chequear que se esta cargando desde otra libreria
    if (!interactive()) {
        message("Cargando DB batch")
        #if (!exists(YATACore::YATAEnv)) stop("This library should loaded from YATACore")
    }

    message("Loading YATADB")
  # if (!("RMariaDB" %in% .packages())) {
  #     library("RMariaDB", character.only = T)
  # }
}
