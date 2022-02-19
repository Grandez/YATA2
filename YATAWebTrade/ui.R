YATAPage("YATA", id="mainMenu"
  ,tabPanel("Test",       value="test",  YATAModule("test"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.POSITION"),  value="pos",   YATAModule("pos"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.OPERATION"), value="oper",  YATAModule("oper"))
  ,tabPanel(YATAWEB$MSG$get("PNL.HISTORY"),   value="hist",  YATAModule("hist"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.ANALYSIS"),  value="ana",   YATAModule("ana"))  
  ,tabPanel(YATAWEB$MSG$get("PNL.LOG"),       value="log",   YATAModule("log"))
)
