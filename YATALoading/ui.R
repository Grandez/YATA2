   theme = bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"),
    "-apple-system", "BlinkMacSystemFont", "Segoe UI",
    font_google("Roboto"), "Helvetica Neue", "Arial",
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"),
    font_scale = NULL
    )
    #jsShiny = list( script="yata/yatashiny.js",funct#ions = parseShinyJS())
#     paths = list(
#        yata = normalizePath(system.file("extdata/www/yata", package = packageName()))
#       ,icons = paste0(Sys.getenv("YATA_SITE"), "/ext/icons")
# #      ,icons2 = normalizePath(system.file("extdata/www/icons", package = packageName()))
#       ,img    = normalizePath(system.file("extdata/www/img", package = packageName()))
#       ,yata   = normalizePath(system.file("extdata/www/yata", package = packageName()))
#     )

    #customJS  = list(shiny=jsShiny,js=("yata/yataapp.js"))
    customCSS = list( "page_loading.css"
                     ,"yata/yata.css"             # Base
                     ,"yata/yata_reactable.css")  # Paquete reactable
# ,cssFiles=c("page_loading.css")
    jsInit = c( "   globalThis.yata = new YATA();"
               ,"   yata.init();"
#               ,"   Shiny.addCustomMessageHandler('yataShowBlock', function(data) { yata.show_block(data); });"
              )
    JGGLoader( YATA,  id="loader"
                       ,theme    = theme
                       ,paths    = NULL
                       ,cssFiles = customCSS
                       ,jsFiles  = NULL
                       ,jsInit   = jsInit
                       ,titleActive = TRUE
                       ,lang    = NULL
                       ,background = NULL
#                        , ...)
#
# JGGLoader("YATA", id="loader"
  ,useShinyjs()
 ,guiDivCenter(tags$span(style="display: none;", numericInput("block", label="bloque", value=0))
    ,tags$table(class="jgg_table_loader"
         ,tags$tr(
             tags$td(shinyjs::hidden(tags$span(id="block0","Loading libraries")))
            ,tags$td( shinyjs::hidden(tags$span(id="block0OK",tags$i(class = "fas fa-check", style = "color: green;")))
                     ,shinyjs::hidden(tags$span(id="block0KO",tags$i(class = "fas fa-times", style = "color: red;")))))

         ,tags$tr(
             tags$td( shinyjs::hidden(tags$span(id="block1","Checking daemons and servers")))
            ,tags$td( shinyjs::hidden(tags$span(id="block1OK",tags$i(class = "fas fa-check", style = "color: green;")))
                     ,shinyjs::hidden(tags$span(id="block1KO",tags$i(class = "fas fa-times", style = "color: red;")))))

         ,tags$tr(
             tags$td(shinyjs::hidden(tags$span(id="block2","Creating factories")))
            ,tags$td( shinyjs::hidden(tags$span(id="block2OK",tags$i(class = "fas fa-check", style = "color: green;")))
                     ,shinyjs::hidden(tags$span(id="block2KO",tags$i(class = "fas fa-times", style = "color: red;")))))

         ,tags$tr(
             tags$td(shinyjs::hidden(tags$span(id="block3","Loading sources")))
            ,tags$td( shinyjs::hidden(tags$span(id="block3OK",tags$i(class = "fas fa-check", style = "color: green;")))
                     ,shinyjs::hidden(tags$span(id="block3KO",tags$i(class = "fas fa-times", style = "color: red;")))))

         ,tags$tr(
             tags$td(shinyjs::hidden(tags$span(id="block4","Creating landing page")))
            ,tags$td( shinyjs::hidden(tags$span(id="block4OK",tags$i(class = "fas fa-check", style = "color: green;")))
                     ,shinyjs::hidden(tags$span(id="block4KO",tags$i(class = "fas fa-times", style = "color: red;")))))

         ,tags$tr(
             tags$td(shinyjs::hidden(tags$span(id="block5","Activating landing page")))
            ,tags$td( shinyjs::hidden(tags$span(id="block5OK",tags$i(class = "fas fa-check", style = "color: green;")))
                     ,shinyjs::hidden(tags$span(id="block5KO",tags$i(class = "fas fa-times", style = "color: red;")))))

    )
  )

)
