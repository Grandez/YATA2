my_theme <- bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"), 
    "-apple-system", "BlinkMacSystemFont", "Segoe UI", 
    font_google("Roboto"), "Helvetica Neue", "Arial", 
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"), 
    font_scale = NULL
    )
JGGDashboardFull(title="YATA", id = "mainMenu"

#YATAPage("YATA", id="mainMenu"
  ,tabPanel("Test",       value="test",  YATAModule("test"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.POSITION"),  value="pos",   YATAModule("pos"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.OPERATION"), value="oper",  YATAModule("oper"))
  ,tabPanel(YATAWEB$MSG$get("PNL.HISTORY"),   value="hist",  YATAModule("hist"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.ANALYSIS"),  value="ana",   YATAModule("ana"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.LOG"),       value="log",   YATAModule("log"))
  ,titleActive = TRUE, theme =  my_theme,lang = NULL    
)
