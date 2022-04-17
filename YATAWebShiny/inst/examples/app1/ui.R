my_theme = bslib::bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"),
    "-apple-system", "BlinkMacSystemFont", "Segoe UI",
    font_google("Roboto"), "Helvetica Neue", "Arial",
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"),
    font_scale = NULL
    )
JGGDashboard (id="jgg"
  ,tabPanel("Cookies",  value="cookie",   JGGModule("cookie")    )
  ,tabPanel("TAB1",  value="noLeft",   JGGModule("noLeft")    )
#  ,tabPanel("TAB2", value="oper",   h2("Panel 2")) #YATAModule("oper")   )
        ,  title="JGG"
        ,titleActive = TRUE
        , theme =  my_theme
        ,lang = NULL
        ,cssFiles = NULL
        ,jsFiles  = NULL
        ,jsInit   = NULL
)

