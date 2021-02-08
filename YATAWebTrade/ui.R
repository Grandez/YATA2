YATAPage("Navbar!", id="mainMenu",
   tabPanel("Posicion",      value=pnl$pos,    YATAModule("Position", pnl$pos))
  ,tabPanel("Operaciones",   value=pnl$oper,   YATAModule("Oper",     pnl$oper))
  ,tabPanel("Configuracion", value=pnl$config, YATAModule("Config",   pnl$config))
  ,tags$head(
    tags$link(rel="stylesheet", type="text/css", href="yata/yata.css"),
    tags$script(src="yata/yata.js")
  )
)
