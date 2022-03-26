.onLoad <- function(libname, pkgname) {
    message("Loading YATAWebCore")
    # if (Sys.info()[["sysname"]] == "Windows") {
    #     shiny::addResourcePath("icons",   normalizePath("P:\\R\\YATA2\\YATAExt\\icons"))
    # } else {
    #     shiny::addResourcePath("icons",   normalizePath("/srv/YATA2/YATAExt/icons"))
    # }

    # shiny::addResourcePath("icons2", normalizePath(system.file("extdata/www/icons", package = "YATAWebCore")))
    # shiny::addResourcePath("img",    normalizePath(system.file("extdata/www/img",   package = "YATAWebCore")))
    # shiny::addResourcePath("yata",   normalizePath(system.file("extdata/www/yata",  package = "YATAWebCore")))
}

.onUnload <- function(libname, pkgname) {
   shiny::removeResourcePath("icons")
}

