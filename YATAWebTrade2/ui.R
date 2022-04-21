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
#  ,YATATabPanel(lbl$POSITION,  value="pos",    YATAModule("pos")    )

   ,YATATab(lbl$OPERATION, id="oper",   YATAModule("oper"))
  # ,YATATabPanel(lbl$HISTORY,   value="hist",   YATAModule("hist")   )
  # ,YATATabPanel(lbl$ANALYSIS,  value="ana",    YATAModule("ana")    )
  # ,YATATabPanel(lbl$LOG,       value="log",    YATAModule("log")    )
    ,YATATab(lbl$ADMIN,    id="admin", YATAModule("admin") )
  # ,YATATabPanel(lbl$STATUS,    value="status", YATAModule("status") )

)
#cat(paste(Sys.time(), " - After YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
