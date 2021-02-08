modOperInput = function(id) {
    ns = NS(id)
    tagList(
       yataAlertPanelUI(ns("alert"))
      ,tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",   value=ns("pos"),    YATAModule("OperPos",    ns("pos")))
         ,tabPanel("Abrir",      value=ns("open"),   YATAModule("OperOpen",   ns("open")))
         ,tabPanel("Comprar",    value=ns("buy"),    YATAModule("OperBuy",    ns("buy")))
         ,tabPanel("Vender",     value=ns("sell"),   YATAModule("OperSell",   ns("sell")))
         ,tabPanel("Transferir", value=ns("xfer"),   YATAModule("OperXfer",   ns("xfer")))
         ,tabPanel("Custom",     value=ns("custom"), YATAModule("OperCustom", ns("custom")))
         )
)}