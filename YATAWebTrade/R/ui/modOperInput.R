modOperInput = function(id, title) {
    ns = NS(id)
    tagList(
       yataAlertPanelUI(ns("alert"))
      ,tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",   value=ns("pos"),    YATAModule("OperPos",    ns("pos")))
         ,tabPanel("Abrir",      value=ns("open"),   YATAModule("OperOpen",   ns("open"), "Abrir posicion"))
         ,tabPanel("Comprar",    value=ns("buy"),    YATAModule("OperOpen",   ns("buy"),  "Comprar monedas"))
         ,tabPanel("Vender",     value=ns("sell"),   YATAModule("OperSell",   ns("sell")))
         ,tabPanel("Transferir", value=ns("xfer"),   YATAModule("OperXfer",   ns("xfer")))
         ,tabPanel("Custom",     value=ns("custom"), YATAModule("OperCustom", ns("custom")))
         )
)}