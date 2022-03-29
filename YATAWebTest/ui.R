my_theme = bslib::bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"),
    "-apple-system", "BlinkMacSystemFont", "Segoe UI",
    font_google("Roboto"), "Helvetica Neue", "Arial",
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"),
    font_scale = NULL
    )

#JGGDashboardFull(title="YATA", id = "mainMenu"
#cat(paste(Sys.time(), " - Before YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
YATAWebCore::YATAPage("YATA", id="mainMenu",titleActive = TRUE, theme =  my_theme,lang = NULL
  ,tabPanel(WEB$MSG$get("PNL.POSITION"),  value="pos",   YATAWebShiny::YATAModule("pos"))
  ,tabPanel(WEB$MSG$get("PNL.OPERATION"), value="oper",  YATAWebShiny::YATAModule("oper"))
  ,tabPanel(WEB$MSG$get("PNL.HISTORY"),   value="hist",  YATAWebShiny::YATAModule("hist"))
  ,tabPanel(WEB$MSG$get("PNL.ANALYSIS"),  value="ana",   YATAWebShiny::YATAModule("ana"))
  ,tabPanel(WEB$MSG$get("PNL.LOG"),       value="log",   YATAWebShiny::YATAModule("log"))
  ,tabPanel(WEB$MSG$get("PNL.ADMIN"),     value="admin", YATAWebShiny::YATAModule("admin"))
  ,tabPanel("Test",       value="test",  YATAWebShiny::YATAModule("test"))
)
#cat(paste(Sys.time(), " - After YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
