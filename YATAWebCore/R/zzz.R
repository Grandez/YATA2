.onLoad <- function(libname, pkgname) {
    message("Loading YATAWebCore")
    shiny::addResourcePath("icons",  normalizePath(system.file("extdata/icons", package = "YATACore")))
    shiny::addResourcePath("yata",   normalizePath(system.file("extdata/www/yata",  package = "YATAWebCore")))
#    shiny::addResourcePath("yata",   normalizePath(system.file("extdata/www/yata",  package = "YATAWebCore")))
#    shiny::addResourcePath("resext", normalizePath("P:\\R\\YATA2\\YATAExternal"))
}

.onUnload <- function(libname, pkgname) {
   shiny::removeResourcePath("icons")
}
