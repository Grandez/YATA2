my_theme = bslib::bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"),
    "-apple-system", "BlinkMacSystemFont", "Segoe UI",
    font_google("Roboto"), "Helvetica Neue", "Arial",
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"),
    font_scale = NULL
    )

lbl = WEB$getLabelsMenuMain()

#JGGDashboardFull(title="YATA", id = "mainMenu"
#cat(paste(Sys.time(), " - Before YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
YATAWebCore::YATAPage("YATA", id="mainMenu",titleActive = TRUE, theme =  my_theme,lang = NULL
  ,tabPanel(lbl$POSITION,  value="pos",    YATAWebShiny::YATAModule("pos")    )
  ,tabPanel(lbl$OPERATION, value="oper",   YATAWebShiny::YATAModule("oper")   )
  # ,tabPanel(lbl$HISTORY,   value="hist",   YATAWebShiny::YATAModule("hist")   )
  # ,tabPanel(lbl$ANALYSIS,  value="ana",    YATAWebShiny::YATAModule("ana")    )
  # ,tabPanel(lbl$LOG,       value="log",    YATAWebShiny::YATAModule("log")    )
  # ,tabPanel(lbl$ADMIN,     value="admin",  YATAWebShiny::YATAModule("admin")  )
  # ,tabPanel(lbl$STATUS,    value="status", YATAWebShiny::YATAModule("status") )
  # ,tabPanel("Test",        value="test",  YATAWebShiny::YATAModule("test"))
)
#cat(paste(Sys.time(), " - After YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
