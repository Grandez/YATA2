.onLoad <- function(libname, pkgname) {
    message("Loading YATAWebCore")
    if (Sys.info()[["sysname"]] == "Windows") {
        shiny::addResourcePath("icons",   normalizePath("P:\\R\\YATA2\\YATAExternal\\icons"))
    } else {
        shiny::addResourcePath("icons",   normalizePath("/srv/YATA2/YATAExternal/icons"))
    }

    shiny::addResourcePath("icons2", normalizePath(system.file("extdata/www/icons", package = "YATAWebCore")))
    shiny::addResourcePath("img",    normalizePath(system.file("extdata/www/img",   package = "YATAWebCore")))
    shiny::addResourcePath("yata",   normalizePath(system.file("extdata/www/yata",  package = "YATAWebCore")))
#    shiny::addResourcePath("sbs",    normalizePath(system.file("www",  package = "shinyBS")))
#    shiny::addResourcePath("yata",   normalizePath(system.file("extdata/www/yata",  package = "YATAWebCore")))
#    shiny::addResourcePath("resext", normalizePath("P:\\R\\YATA2\\YATAExternal"))
}

.onUnload <- function(libname, pkgname) {
   shiny::removeResourcePath("icons")
}

