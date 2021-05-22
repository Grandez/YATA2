YATAPage("Navbar!", id="mainMenu"
  ,tabPanel("Test",      value="test",    YATAModule("test"))  
  ,tabPanel("Posicion",      value=panel$pos,    YATAModule(panel$pos))  
  ,tabPanel("Operaciones",   value=panel$oper,   YATAModule(panel$oper))
  ,tabPanel("Historia",      value=panel$hist,   YATAModule(panel$hist))  
  ,tabPanel("Analisis",      value=panel$ana,    YATAModule(panel$ana))  
  ,tabPanel("Log",           value=panel$log,    YATAModule(panel$log))
)
