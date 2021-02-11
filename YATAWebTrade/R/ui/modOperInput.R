modOperInput = function(id, title) {
    ns = NS(id)
    tagList(
       yataAlertPanelUI(ns("alert"))
      ,tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",   value=ns("pos"),    YATAModule(ns("pos")))
         ,tabPanel("Abrir",      value=ns("open"),   YATAModule(ns("open"), "Abrir posicion"))
         ,tabPanel("Comprar",    value=ns("buy"),    YATAModule(ns("buy"),  "Comprar monedas"))
         ,tabPanel("Vender",     value=ns("sell"),   YATAModule(ns("sell")))
         ,tabPanel("Transferir", value=ns("xfer"),   YATAModule(ns("xfer")))
         ,tabPanel("Custom",     value=ns("custom"), YATAModule(ns("custom")))
         )
)}