YATAPage("Navbar!", id="mainMenu",
   tabPanel("Posicion",      value="pos",    YATAModule("pos"))
  ,tabPanel("Operaciones",   value="oper",   YATAModule("oper"))
  ,tabPanel("Configuracion", value="config", YATAModule("config"))

    ,tags$head(
    tags$link(rel="stylesheet", type="text/css", href="yata/yata.css"),
    tags$script(src="yata/yata.js")
  )
)
