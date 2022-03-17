YATAPage = function( title="YATA", id = "mainMenu"
         ,titleActive = TRUE
         ,theme =  my_theme,lang = NULL, ...) {
   theme = bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"),
    "-apple-system", "BlinkMacSystemFont", "Segoe UI",
    font_google("Roboto"), "Helvetica Neue", "Arial",
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"),
    font_scale = NULL
    )

    paths = list(
       yata = normalizePath(system.file("extdata/www/yata", package = packageName()))
    )
    jsShiny = list( script="yata/yataappjs"
                   ,functions = c("yata_layout")
              )
    customJS  = list(shiny=jsShiny,js=("yata/yataapp.js"))
    customCSS = list("yata/yata.css")
    JGGDashboardFull( title,  id
                       ,theme    = theme
                       ,paths    = paths
                       ,cssFiles = customCSS
                       ,jsFiles  = customJS
                       ,jsInit   = NULL
                       ,titleActive = TRUE
                       ,lang    = NULL
                       , ...)

}

