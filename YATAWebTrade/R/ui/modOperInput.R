modOperInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       yataAlertPanelUI(ns("alert"))
      ,tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",   value=ns("pos"),    YATAModule(ns("pos")))
         ,tabPanel("Abrir",      value=ns("open"),   YATAModule(ns("open")))
         ,tabPanel("Comprar",    value=ns("buy"),    YATAModule(ns("buy")))
         ,tabPanel("Vender",     value=ns("sell"),   YATAModule(ns("sell")))
         ,tabPanel("Transferir", value=ns("xfer"),   YATAModule(ns("xfer")))
         ,tabPanel("Custom",     value=ns("custom"), YATAModule(ns("custom")))
      )
    )
    list(left=NULL, main=main, right=NULL)        
}