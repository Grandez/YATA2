add_shiny_resources = function() {
    browser()
  # tags$link  (rel="stylesheet", type="text/css", href="yata/yatabootstrap.css")
  #  message("Loading YATAWebCore")
    if (Sys.info()[["sysname"]] == "Windows") {
        shiny::addResourcePath("icons",   normalizePath("P:\\R\\YATA2\\YATAExternal\\icons"))
    } else {
        shiny::addResourcePath("icons",   normalizePath("/srv/yata/YATAExternal/icons"))
    }

  rootPath = normalizePath(system.file("extdata/www", package = packageName()))
  shiny::addResourcePath("jggshiny", rootPath)
}
