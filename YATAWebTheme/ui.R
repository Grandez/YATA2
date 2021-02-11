YATAPage("Navbar!", id="mainMenu",
    tabPanel("Etiquetas",  value="label",    YATAModule("label"))
   ,tabPanel("Tablas",  value="table",    YATAModule("table"))  
   ,tabPanel("Lineas",  value="line",    YATAModule("line"))
   ,tabPanel("Barras",  value="bar",    YATAModule("bar"))
  # ,tabPanel("Operaciones",   value=pnl$oper,   YATAModule(pnl$oper))
  # ,tabPanel("Configuracion", value=pnl$config, YATAModule(pnl$config))
  # ,tags$head(
  #   tags$link(rel="stylesheet", type="text/css", href="yata/yata.css"),
  #   tags$script(src="yata/yata.js")
  # )
)
