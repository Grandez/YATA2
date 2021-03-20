.onLoad <- function(libname, pkgname) {
    message("Loading YATAWebCore")
    shiny::addResourcePath("icons",   normalizePath("P:\\R\\YATA2\\YATAExternal\\icons"))
    shiny::addResourcePath("icons2",  normalizePath(system.file("extdata/www/icons", package = "YATAWebCore")))
    shiny::addResourcePath("yata",   normalizePath(system.file("extdata/www/yata",  package = "YATAWebCore")))
#    shiny::addResourcePath("yata",   normalizePath(system.file("extdata/www/yata",  package = "YATAWebCore")))
#    shiny::addResourcePath("resext", normalizePath("P:\\R\\YATA2\\YATAExternal"))
}

.onUnload <- function(libname, pkgname) {
   shiny::removeResourcePath("icons")
}
